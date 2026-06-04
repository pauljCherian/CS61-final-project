from flask import Flask, render_template, request, redirect, url_for, jsonify
import requests
from datetime import datetime
from zoneinfo import ZoneInfo

app = Flask(__name__)

API_URL = "http://127.0.0.1:8080"

# Timezone used to decide "today" for workout dates. Change to your zone.
TIMEZONE = ZoneInfo("America/New_York")

# Once you log in, the token lives here. None means "not logged in".
token = None


# Runs before every request: if you're not logged in, send you to /login.
# Written by Claude Code Opus 4.8 - was not sure how to gate pages
@app.before_request
def require_login():
    allowed = {"login", "login_page", "signup", "static"}
    if request.endpoint not in allowed and not token:
        return redirect(url_for("login_page"))


# Cardio Duration is stored in seconds; the UI uses HH:MM:SS.
# Conversion functions also written by Claude Code Opus 4.8
def hms_to_seconds(text):
    parts = [int(p) if p else 0 for p in text.split(":")]
    while len(parts) < 3:
        parts.insert(0, 0)
    return parts[-3] * 3600 + parts[-2] * 60 + parts[-1]

def seconds_to_hms(total):
    return f"{total // 3600:02d}:{total % 3600 // 60:02d}:{total % 60:02d}"


# ----- pages -----

@app.route('/')
def home():
    return render_template("index.html")

@app.route('/workout/<int:workout_id>')
def workout(workout_id):
    headers = {"Authorization": f"Bearer {token}"}

    # THE REST OF THIS FUNCTION WAS WRITTEN BY CLAUDE CODE OPUS 4.8
    # The workout itself (date, description, notes).
    w_resp = requests.get(f"{API_URL}/api/workouts/{workout_id}", headers=headers)
    w_rows = w_resp.json() if w_resp.ok else []
    workout_row = w_rows[0] if w_rows else {}

    # Convert the date to YYYY-MM-DD so the date input can show it.
    if workout_row.get("WorkoutDate"):
        workout_row["WorkoutDate"] = datetime.strptime(workout_row["WorkoutDate"], "%a, %d %b %Y %H:%M:%S %Z").date().isoformat()

    # Fetch the saved lifts (with exercise names) so the page renders full on load.
    resp = requests.get(f"{API_URL}/api/workouts/{workout_id}/exercises", headers=headers)
    lifts = resp.json() if resp.ok else []

    # Attach each lift's sets.
    for lift in lifts:
        we_id = lift["WorkoutExerciseID"]
        sets_resp = requests.get(f"{API_URL}/api/workout-exercises/{we_id}/sets", headers=headers)
        lift["sets"] = sets_resp.json() if sets_resp.ok else []

    # Cardio sessions for this workout.
    c_resp = requests.get(f"{API_URL}/api/workouts/{workout_id}/cardio", headers=headers)
    cardio = c_resp.json() if c_resp.ok else []

    # Duration is stored in seconds; show it as HH:MM:SS.
    for c in cardio:
        if c.get("Duration") is not None:
            c["Duration"] = seconds_to_hms(c["Duration"])

    return render_template("workout.html", workout_id=workout_id, workout=workout_row, lifts=lifts, cardio=cardio)

# To view the list of workouts done
@app.route('/workouts')
def workouts():
    headers = {"Authorization": f"Bearer {token}"}

    resp = requests.get(f"{API_URL}/api/workouts", headers=headers)
    workouts = resp.json() if resp.ok else []

    return render_template("workouts.html", workouts=workouts)

@app.route('/weight')
def weight():
    return render_template("weight.html")

@app.route('/sleep')
def sleep():
    return render_template("sleep.html")


# ----- login -----

@app.route('/login', methods=["GET"])
def login_page():
    return render_template("login.html")

@app.route('/login', methods=["POST"])
def login():
    global token
    username = request.form.get("username")
    password = request.form.get("password")

    data = {"Username": username, "Password": password}
    response = requests.post(API_URL + "/api/login", json=data)

    if response.status_code == 200:
        token = response.json()["token"]
        return redirect(url_for("home"))

    return render_template("login.html", error="Login failed. Check your username and password.")

@app.route('/signup', methods=["POST"])
def signup():
    app.logger.debug("signing up")
    username = request.form.get("username")
    password = request.form.get("password")
    email = request.form.get("email")

    data = {"Email": email, "Username": username, "Password": password}

    response = requests.post(API_URL + "/api/register", json=data)

    if response.status_code == 201:
        return redirect(url_for("login"))

    return render_template("login.html", error="Signup failed. Retry.")

# ------ server interaction -------

# ------- Workouts -----------
# User posts their workout
@app.route('/create-workout', methods=["POST"])
def create_workout():
    try:
        endpoint = "/api/workouts"
        headers = { "Authorization": f"Bearer {token}"}

        # Use the current day in our configured timezone, as an ISO string
        # ("YYYY-MM-DD") so it can be JSON-serialized.
        workout_date = datetime.now(TIMEZONE).date().isoformat()

        # User edits desc and notes after creating the workout
        data = {"WorkoutDate": workout_date, "Description": "", "Notes": ""}
        response = requests.post(API_URL + endpoint, json=data, headers=headers)

        if response.status_code == 201:
            resp = response.json()
            return redirect(url_for("workout", workout_id=resp["id"]))
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return redirect(url_for("home"))

# User updates their workout's date, description, notes
@app.route('/workout/<int:workout_id>', methods=["PUT"])
def update_workout(workout_id):
    try:
        endpoint = f"/api/workouts/{workout_id}"
        headers = { "Authorization": f"Bearer {token}"}

        body = request.get_json()
        data = {"WorkoutDate": body.get("date"), "Description": body.get("description"), "Notes": body.get("notes")}

        response = requests.put(API_URL + endpoint, json=data, headers=headers)

        if response.status_code == 200:
            return jsonify(response.json()), 200
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# User deletes their workout
@app.route('/delete-workout/<int:workout_id>', methods=["POST"])
def delete_workout(workout_id):
    try:
        endpoint = f"/api/workouts/{workout_id}"
        headers = { "Authorization": f"Bearer {token}"}

        response = requests.delete(API_URL + endpoint, headers=headers)

        if response.status_code == 200:
            resp = response.json()
            print("Deleted workout with ID: ", resp["id"])
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

    return redirect(url_for("workouts"))

# ------ lifts and sets -------

# User adds a lift
@app.route('/workout/<int:workout_id>/lifts', methods=["POST"])
def create_lift(workout_id):
    try:
        endpoint = f"/api/workouts/{workout_id}/exercises"
        headers = { "Authorization": f"Bearer {token}"}

        body = request.get_json()
        data = {"ExerciseName": body.get("name"), "Notes": body.get("notes", ""), "OrderNum": body.get("order")}

        response = requests.post(API_URL + endpoint, json=data, headers=headers)

        if response.status_code == 201:
            resp = response.json()
            return jsonify({"we_id": resp["id"]}), 201
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# User updates a lift
@app.route('/lifts/<int:we_id>', methods=["PUT"])
def update_lift(we_id):
    try:
        endpoint = f"/api/workout-exercises/{we_id}"
        headers = { "Authorization": f"Bearer {token}"}

        body = request.get_json()
        data = {"ExerciseName": body.get("name"), "Notes": body.get("notes", "")}

        response = requests.put(API_URL + endpoint, json=data, headers=headers)

        if response.status_code == 200:
            return jsonify(response.json()), 200
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# User deletes a lift
@app.route('/lifts/<int:we_id>', methods=["DELETE"])
def delete_lift(we_id):
    try:
        endpoint = f"/api/workout-exercises/{we_id}"
        headers = { "Authorization": f"Bearer {token}"}

        response = requests.delete(API_URL + endpoint, headers=headers)

        if response.status_code == 200:
            return jsonify(response.json()), 200
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# User adds a set
@app.route('/lifts/<int:we_id>/sets', methods=["POST"])
def create_set(we_id):
    try:
        endpoint = f"/api/workout-exercises/{we_id}/sets"
        headers = { "Authorization": f"Bearer {token}"}

        body = request.get_json()
        data = {"SetNum": body.get("set_num"), "Weight": body.get("weight"), "Reps": body.get("reps"), "RPE": body.get("rpe")}

        response = requests.post(API_URL + endpoint, json=data, headers=headers)

        if response.status_code == 201:
            resp = response.json()
            return jsonify({"set_id": resp["id"]}), 201
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# User updates a set
@app.route('/sets/<int:set_id>', methods=["PUT"])
def update_set(set_id):
    try:
        endpoint = f"/api/sets/{set_id}"
        headers = { "Authorization": f"Bearer {token}"}

        body = request.get_json()
        data = {"Weight": body.get("weight"), "Reps": body.get("reps"), "RPE": body.get("rpe")}

        response = requests.put(API_URL + endpoint, json=data, headers=headers)

        if response.status_code == 200:
            return jsonify(response.json()), 200
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# User deletes a set
@app.route('/sets/<int:set_id>', methods=["DELETE"])
def delete_set(set_id):
    try:
        endpoint = f"/api/sets/{set_id}"
        headers = { "Authorization": f"Bearer {token}"}

        response = requests.delete(API_URL + endpoint, headers=headers)

        if response.status_code == 200:
            return jsonify(response.json()), 200
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# User adds a cardio session
@app.route('/workout/<int:workout_id>/cardio', methods=["POST"])
def create_cardio(workout_id):
    try:
        endpoint = f"/api/workouts/{workout_id}/cardio"
        headers = { "Authorization": f"Bearer {token}"}

        response = requests.post(API_URL + endpoint, json={}, headers=headers)

        if response.status_code == 201:
            resp = response.json()
            return jsonify({"cardio_id": resp["id"]}), 201
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# User updates a cardio session
@app.route('/cardio/<int:cardio_id>', methods=["PUT"])
def update_cardio(cardio_id):
    try:
        endpoint = f"/api/cardio/{cardio_id}"
        headers = { "Authorization": f"Bearer {token}"}

        body = request.get_json()
        data = {"ActivityType": body.get("type"),
                "Duration": hms_to_seconds(body["time"]) if body.get("time") else None,
                "Distance": body.get("distance"),
                "Units": body.get("unit"), "Intensity": body.get("intensity"), "Notes": body.get("notes")}

        response = requests.put(API_URL + endpoint, json=data, headers=headers)

        if response.status_code == 200:
            return jsonify(response.json()), 200
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# User deletes a cardio session
@app.route('/cardio/<int:cardio_id>', methods=["DELETE"])
def delete_cardio(cardio_id):
    try:
        endpoint = f"/api/cardio/{cardio_id}"
        headers = { "Authorization": f"Bearer {token}"}

        response = requests.delete(API_URL + endpoint, headers=headers)

        if response.status_code == 200:
            return jsonify(response.json()), 200
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({"error": "request failed"}), 500

# ------- Weight --------------

# Look up the weight already logged on a date
@app.route('/weight-entry')
def weight_entry():
    try:
        date = request.args.get("date")
        endpoint = f"/api/bodyweights?date={date}"
        headers = { "Authorization": f"Bearer {token}"}

        response = requests.get(API_URL + endpoint, headers=headers)

        if response.status_code == 200:
            rows = response.json()
            return jsonify(rows[0] if rows else {}), 200
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({}), 200

# User saves their weight
@app.route('/submit-weight', methods=["POST"])
def submit_weight():
    try:
        headers = { "Authorization": f"Bearer {token}"}

        weight_id = request.form.get("weight_id")
        data = {"RecordedDate": request.form.get("date"), "Weight": request.form.get("weight"), "Unit": request.form.get("weight_unit")}

        if weight_id:
            response = requests.put(API_URL + f"/api/bodyweights/{weight_id}", json=data, headers=headers)
        else:
            response = requests.post(API_URL + "/api/bodyweights", json=data, headers=headers)

        if response.status_code == 200 or response.status_code == 201:
            print("Saved weight")
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

    return redirect(url_for("weight"))

# ----------- Sleep ------------------
# Look up the sleep already logged on a date (for prefill)
@app.route('/sleep-entry')
def sleep_entry():
    try:
        date = request.args.get("date")
        endpoint = f"/api/sleeps?date={date}"
        headers = { "Authorization": f"Bearer {token}"}

        response = requests.get(API_URL + endpoint, headers=headers)

        if response.status_code == 200:
            rows = response.json()
            return jsonify(rows[0] if rows else {}), 200
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
    return jsonify({}), 200


# User saves their sleep (updates the day's entry if it exists, else adds one)
@app.route('/submit-sleep', methods=["POST"])
def submit_sleep():
    try:
        headers = { "Authorization": f"Bearer {token}"}

        sleep_id = request.form.get("sleep_id")
        parts = request.form.get("sleep_time", "").split(":")
        hours = int(parts[0]) if parts[0] else 0
        minutes = int(parts[1]) if len(parts) > 1 and parts[1] else 0
        duration = hours * 60 + minutes

        data = {"SleepDate": request.form.get("date"), "Duration": duration}

        if sleep_id:
            response = requests.put(API_URL + f"/api/sleeps/{sleep_id}", json=data, headers=headers)
        else:
            response = requests.post(API_URL + "/api/sleeps", json=data, headers=headers)

        if response.status_code == 200 or response.status_code == 201:
            print("Saved sleep")
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

    return redirect(url_for("sleep"))
