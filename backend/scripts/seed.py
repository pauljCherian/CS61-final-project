"""Seed the workout_tracker DB from the exported CSVs in scripts/seed_data/.

Mirrors the backend's data model and logic:
  workouts.csv  -> Workouts
  lifts.csv     -> WorkoutExercise   (movement -> get-or-create Exercises, like the API)
  sets.csv      -> WorkoutSets        (joined to lifts by lift_id)
  distance.csv  -> CardioSessions

All rows are attached to one seed user. Re-running first deletes that user's
workouts (which cascades to lifts/sets/cardio), so the seed is idempotent.

Run from the backend/ directory:   python scripts/seed.py
"""
import csv
import os
import re
import json
from datetime import datetime

import bcrypt
import mysql.connector

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(HERE, "seed_data")

SEED_USERNAME = "demo"
SEED_EMAIL = "demo@example.com"
SEED_PASSWORD = "password"


# ---- connect using the same db.json the backend uses ----
with open(os.path.join(HERE, "..", "db.json")) as f:
    creds = json.load(f)["localhost"]

db = mysql.connector.connect(host=creds["host"], user=creds["user"],
                             password=creds["password"], database=creds["database"])
cur = db.cursor()


# ---- small parsers for the messy spreadsheet values ----
def read_csv(name):
    with open(os.path.join(DATA, name), newline="") as fh:
        return list(csv.DictReader(fh))

def parse_date(text):
    # "1/1/2026 7:00:00" -> "2026-01-01"
    if not text:
        return None
    return datetime.strptime(text.split()[0], "%m/%d/%Y").date().isoformat()

def hms_to_seconds(text):
    # "0:39:18" -> 2358; unparseable junk -> None
    if not text:
        return None
    try:
        parts = [int(p) if p else 0 for p in text.split(":")]
    except ValueError:
        return None
    while len(parts) < 3:
        parts.insert(0, 0)
    return parts[-3] * 3600 + parts[-2] * 60 + parts[-1]

def to_float(text):
    try:
        return float(text)
    except (TypeError, ValueError):
        return None

def to_int(text):
    text = (text or "").strip()
    return int(text) if text.isdigit() else None

def cardio_unit(text):
    return {"miles": "mi", "meters": "m", "km": "km"}.get((text or "").strip().lower())

def zone_to_intensity(text):
    # "zone 2" -> 2, clamped to 1-5
    m = re.search(r"\d+", text or "")
    if not m:
        return None
    n = int(m.group())
    return n if 1 <= n <= 5 else None

def clean(text):
    text = (text or "").strip()
    return text or None


# ---- get-or-create exercise by name (case-insensitive), same as the API ----
exercise_cache = {}

def get_or_create_exercise(name):
    key = name.strip().lower()
    if key in exercise_cache:
        return exercise_cache[key]
    cur.execute("SELECT ExerciseID FROM Exercises WHERE LOWER(ExerciseName) = %s", (key,))
    row = cur.fetchone()
    if row:
        eid = row[0]
    else:
        cur.execute("INSERT INTO Exercises (ExerciseName) VALUES (%s)", (name.strip(),))
        eid = cur.lastrowid
    exercise_cache[key] = eid
    return eid


# ---- seed user ----
cur.execute("SELECT UserID FROM Users WHERE Username = %s", (SEED_USERNAME,))
row = cur.fetchone()
if row:
    user_id = row[0]
else:
    hashed = bcrypt.hashpw(SEED_PASSWORD.encode(), bcrypt.gensalt()).decode()
    cur.execute("INSERT INTO Users (Username, Email, HashedPassword) VALUES (%s, %s, %s)",
                (SEED_USERNAME, SEED_EMAIL, hashed))
    user_id = cur.lastrowid

# Fresh start: deleting the workouts cascades to lifts, sets, and cardio.
cur.execute("DELETE FROM Workouts WHERE UserID = %s", (user_id,))


# ---- workouts ----  csv id -> db WorkoutID
workout_id_map = {}
for w in read_csv("workouts.csv"):
    cur.execute(
        "INSERT INTO Workouts (UserID, WorkoutDate, Description, Notes) VALUES (%s, %s, %s, %s)",
        (user_id, parse_date(w["datetime"]), clean(w["desc"]), clean(w["notes"])),
    )
    workout_id_map[w["id"]] = cur.lastrowid

# ---- lifts (WorkoutExercise) ----  csv lift id -> db WorkoutExerciseID
lift_id_map = {}
order_counter = {}          # db WorkoutID -> next OrderNum
lifts_skipped = 0
for l in read_csv("lifts.csv"):
    movement = clean(l.get("movement"))
    workout_db_id = workout_id_map.get(l.get("workout_id"))
    if not movement or workout_db_id is None:
        lifts_skipped += 1
        continue
    exercise_id = get_or_create_exercise(movement)
    order_counter[workout_db_id] = order_counter.get(workout_db_id, 0) + 1
    notes = " | ".join(p for p in [clean(l.get("plan")), clean(l.get("notes"))] if p) or None
    cur.execute(
        "INSERT INTO WorkoutExercise (WorkoutID, ExerciseID, OrderNum, Notes) VALUES (%s, %s, %s, %s)",
        (workout_db_id, exercise_id, order_counter[workout_db_id], notes),
    )
    lift_id_map[l["id"]] = cur.lastrowid

# ---- sets (WorkoutSets) ----
sets_inserted = 0
sets_skipped = 0
set_counter = {}            # we_id -> next SetNum (csv set_number is unreliable: blanks + dups)
for s in read_csv("sets.csv"):
    we_id = lift_id_map.get(s.get("lift_id"))
    if we_id is None:                       # lift_id not present in lifts.csv mapping
        sets_skipped += 1
        continue
    set_counter[we_id] = set_counter.get(we_id, 0) + 1
    rpe = to_float(s.get("rpe"))
    cur.execute(
        "INSERT INTO WorkoutSets (WorkoutExerciseID, SetNum, Weight, Unit, Reps, RPE) "
        "VALUES (%s, %s, %s, %s, %s, %s)",
        (we_id, set_counter[we_id], to_float(s.get("weight")), "lb",
         to_int(s.get("reps")), rpe if rpe is not None and 0 <= rpe <= 10 else None),
    )
    sets_inserted += 1

# ---- cardio (CardioSessions) ----
cardio_inserted = 0
cardio_skipped = 0
for c in read_csv("distance.csv"):
    workout_db_id = workout_id_map.get(c.get("workout_id"))
    if workout_db_id is None:
        cardio_skipped += 1
        continue
    extras = [x for x in [clean(c.get("type")),
                          (c["watts"] + "w") if clean(c.get("watts")) else None] if x]
    note = clean(c.get("notes")) or ""
    if extras:
        note = (note + " " if note else "") + "(" + ", ".join(extras) + ")"
    cur.execute(
        "INSERT INTO CardioSessions (WorkoutID, ActivityType, Duration, Distance, Units, Intensity, Notes) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s)",
        (workout_db_id, clean(c.get("movement")), hms_to_seconds(c.get("time")),
         to_float(c.get("distance")), cardio_unit(c.get("unit")),
         zone_to_intensity(c.get("intensity")), note or None),
    )
    cardio_inserted += 1


db.commit()
cur.close()
db.close()

print(f"Seeded user '{SEED_USERNAME}' (UserID {user_id})")
print(f"  exercises in catalog used/created: {len(exercise_cache)}")
print(f"  workouts: {len(workout_id_map)}")
print(f"  lifts:    {len(lift_id_map)} inserted, {lifts_skipped} skipped (no workout match)")
print(f"  sets:     {sets_inserted} inserted, {sets_skipped} skipped (lift_id missing from lifts.csv)")
print(f"  cardio:   {cardio_inserted} inserted, {cardio_skipped} skipped (no workout match)")
if sets_skipped:
    print(f"\n  NOTE: {sets_skipped} sets were skipped because their lift_id isn't in lifts.csv.")
    print("  Re-export the current 'lifts' sheet to seed_data/lifts.csv to capture them all.")
