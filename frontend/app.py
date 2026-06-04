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


# ----- pages -----

@app.route('/')
def home():
    return render_template("index.html")

@app.route('/workout/<int:workout_id>')
def workout(workout_id):
    return render_template("workout.html", workout_id=workout_id)

@app.route('/weight')
def weight():
    return render_template("weight.html")

@app.route('/supplements')
def supplements():
    return render_template("supplements.html")

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

# User posts their workout
@app.route('/create-workout', methods=["POST"])
def create_workout():
    try:
        endpoint = "/api/workouts"
        headers = { "Authorization": f"Bearer {token}"}

        # Use the current day in our configured timezone, as an ISO string
        # ("YYYY-MM-DD") so it can be JSON-serialized.
        workout_date = datetime.now(TIMEZONE).date().isoformat()
        # TODO add description and notes to frontend - usually no notes or description
        description = ""
        notes = ""
        data = {"WorkoutDate": workout_date, "Description": description, "Notes": notes}

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

# User updates their workout
@app.route('/update-workout', methods=["POST"])
def update_workout():
    try:
        endpoint = "/api/workouts"
        headers = { "Authorization": f"Bearer {token}"}
        # TODO put workout id in
        workout_id = "/ID"

        # TODO let update description or notes
        description = ""
        notes = ""
        data = {"Description": description, "Notes": notes}

        response = requests.put(API_URL + endpoint + workout_id, json=data, headers=headers)

        if response.status_code == 200:
            print("Updated workout")
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

    return redirect(url_for("workout"))

# User deletes their workout
@app.route('/delete-workout', methods=["POST"])
def delete_workout():
    try:
        endpoint = "/api/workouts"
        headers = { "Authorization": f"Bearer {token}"}
        # TODO put workout id in
        workout_id = "/ID"

        response = requests.delete(API_URL + endpoint + workout_id, headers=headers)

        if response.status_code == 200:
            resp = response.json()
            print("Deleted workout with ID: ", resp["id"])
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

    return redirect(url_for("workout"))

# ------ lift / set proxy routes (called by workout.html via fetch) -------
# The browser can't reach the API directly (it has no token), so these
# same-origin routes attach the token, forward to the API, and return JSON
# instead of redirecting. The JS speaks a small vocabulary (name/notes,
# we_id/set_id); the translation to the backend's column names happens here.

def auth_headers():
    return {"Authorization": f"Bearer {token}"}

# CREATE a lift. Backend get-or-creates the Exercise from the name.
@app.route('/workout/<int:workout_id>/lifts', methods=["POST"])
def create_lift(workout_id):
    body = request.get_json()
    data = {
        "ExerciseName": body["name"],
        "Notes": body.get("notes", ""),
        "OrderNum": body["order"],
    }
    try:
        r = requests.post(f"{API_URL}/api/workouts/{workout_id}/exercises",
                          json=data, headers=auth_headers())
    except requests.exceptions.RequestException:
        return jsonify({"error": "Could not reach the API"}), 502

    if r.status_code != 201:
        return jsonify(r.json()), r.status_code
    return jsonify({"we_id": r.json()["id"]}), 201

# UPDATE a lift's name and/or notes (name re-runs get-or-create on the backend).
@app.route('/lifts/<int:we_id>', methods=["PUT"])
def update_lift(we_id):
    body = request.get_json()
    data = {}
    if "name" in body:
        data["ExerciseName"] = body["name"]
    if "notes" in body:
        data["Notes"] = body["notes"]
    try:
        r = requests.put(f"{API_URL}/api/workout-exercises/{we_id}",
                         json=data, headers=auth_headers())
    except requests.exceptions.RequestException:
        return jsonify({"error": "Could not reach the API"}), 502

    if not r.ok:
        return jsonify(r.json()), r.status_code
    return "", 204

# DELETE a lift (its sets go with it via ON DELETE CASCADE).
@app.route('/lifts/<int:we_id>', methods=["DELETE"])
def remove_lift(we_id):
    try:
        r = requests.delete(f"{API_URL}/api/workout-exercises/{we_id}",
                            headers=auth_headers())
    except requests.exceptions.RequestException:
        return jsonify({"error": "Could not reach the API"}), 502

    if not r.ok:
        return jsonify(r.json()), r.status_code
    return "", 204

# CREATE a (blank) set under a lift.
@app.route('/lifts/<int:we_id>/sets', methods=["POST"])
def create_set(we_id):
    body = request.get_json()
    data = {
        "SetNum": body["set_num"],
        "Weight": body.get("weight"),
        "Reps": body.get("reps"),
        "RPE": body.get("rpe"),
    }
    try:
        r = requests.post(f"{API_URL}/api/workout-exercises/{we_id}/sets",
                          json=data, headers=auth_headers())
    except requests.exceptions.RequestException:
        return jsonify({"error": "Could not reach the API"}), 502

    if r.status_code != 201:
        return jsonify(r.json()), r.status_code
    return jsonify({"set_id": r.json()["id"]}), 201

# UPDATE one set's weight/reps/rpe.
@app.route('/sets/<int:set_id>', methods=["PUT"])
def edit_set(set_id):
    body = request.get_json()
    data = {}
    if "weight" in body:
        data["Weight"] = body["weight"]
    if "reps" in body:
        data["Reps"] = body["reps"]
    if "rpe" in body:
        data["RPE"] = body["rpe"]
    try:
        r = requests.put(f"{API_URL}/api/sets/{set_id}",
                         json=data, headers=auth_headers())
    except requests.exceptions.RequestException:
        return jsonify({"error": "Could not reach the API"}), 502

    if not r.ok:
        return jsonify(r.json()), r.status_code
    return "", 204

# DELETE one set.
@app.route('/sets/<int:set_id>', methods=["DELETE"])
def remove_set(set_id):
    try:
        r = requests.delete(f"{API_URL}/api/sets/{set_id}", headers=auth_headers())
    except requests.exceptions.RequestException:
        return jsonify({"error": "Could not reach the API"}), 502

    if not r.ok:
        return jsonify(r.json()), r.status_code
    return "", 204
