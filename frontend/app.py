from flask import Flask, render_template, request, redirect, url_for
import requests

app = Flask(__name__)

API_URL = "http://127.0.0.1:8080"

# Once you log in, the token lives here. None means "not logged in".
token = None


# Runs before every request: if you're not logged in, send you to /login.
# Written by Claude Code Opus 4.8 - was not sure how to gate pages
@app.before_request
def require_login():
    allowed = {"login", "login_page", "static"}
    if request.endpoint not in allowed and not token:
        return redirect(url_for("login_page"))


# ----- pages -----

@app.route('/')
def hello():
    return render_template("index.html")

@app.route('/workout')
def workout():
    return render_template("workout.html")

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
        return redirect(url_for("hello"))

    return render_template("login.html", error="Login failed. Check your username and password.")
