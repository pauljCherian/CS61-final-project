# app.py
from flask import Flask

# Import your blueprints
from routes.bodyweights import bodyweights_bp
from routes.cardio_sessions import cardio_sessions_bp
from routes.exercises import exercises_bp
from routes.sleeps import sleeps_bp
from routes.supplements import supplements_bp
from routes.users import users_bp
from routes.workout_exercises import workout_exercises_bp
from routes.workouts import workouts_bp

app = Flask(__name__)
# TODO remove
app.config['SECRET_KEY'] = "YOUR_SUPER_SECRET_KEY"

# Register the blueprints with the main app
app.register_blueprint(bodyweights_bp)
app.register_blueprint(cardio_sessions_bp)
app.register_blueprint(exercises_bp)
app.register_blueprint(sleeps_bp)
app.register_blueprint(supplements_bp)
app.register_blueprint(users_bp)
app.register_blueprint(workout_exercises_bp)
app.register_blueprint(workouts_bp)

@app.route('/api')
def home():
    return "API is running!"

if __name__ == '__main__':
    # Start flask running
    app.run(debug=True, port=8080)
