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
    headers = {"Authorization": f"Bearer {token}"}

    # THE REST OF THIS FUNCTION WAS WRITTEN BY CLAUDE CODE OPUS 4.8
    # Fetch the saved lifts (with exercise names) so the page renders full on load.
    resp = requests.get(f"{API_URL}/api/workouts/{workout_id}/exercises", headers=headers)
    lifts = resp.json() if resp.ok else []

    # Attach each lift's sets.
    for lift in lifts:
        we_id = lift["WorkoutExerciseID"]
        sets_resp = requests.get(f"{API_URL}/api/workout-exercises/{we_id}/sets", headers=headers)
        lift["sets"] = sets_resp.json() if sets_resp.ok else []

    return render_template("workout.html", workout_id=workout_id, lifts=lifts)

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
