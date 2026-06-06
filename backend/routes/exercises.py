from flask import Blueprint, jsonify, request
import bcrypt
from utils import get_db_connection, token_required

# 1. Create the Blueprint
exercises_bp = Blueprint('exercises', __name__)

@exercises_bp.route('/api/exercises', methods=["GET"])
@token_required
def get_exercises(current_user_id):
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        query = "SELECT * FROM Exercises"
        cursor.execute(query)
        rows = cursor.fetchall()

        return jsonify(rows), 200
    except Exception as e:
        print(f"Database error: {e}")

        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500
    
    finally:
        cursor.close()
        db.close()

@exercises_bp.route('/api/exercises/<int:id>', methods=["GET"])
@token_required
def get_exercise(current_user_id, id):
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        query = "SELECT * FROM Exercises WHERE ExerciseID = %s"
        values = (id, )
        cursor.execute(query, values)
        rows = cursor.fetchall()

        return jsonify(rows), 200
    except Exception as e:
        print(f"Database error: {e}")

        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500
    
    finally:
        cursor.close()
        db.close()

# TODO: Do we want users to be able to add their own custom excersise?
@exercises_bp.route('/api/exercises', methods=["POST"])
@token_required
def add_exercise(current_user_id):
    try:
        data = request.get_json() #data provided by client
        # Basic validation
        if not data:
            return jsonify({"error": "No data provided"}), 400 # status 400 = Bad Request
                
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 
        query = ("INSERT INTO Exercises (ExerciseName, MuscleGroup) "
            "VALUES (%s, %s)")
        values = (data["ExerciseName"], data["MuscleGroup"])
        cursor.execute(query, values)
        db.commit()
        new_id = cursor.lastrowid
        
        return jsonify({"id": new_id, "message": "Exercise added"}), 201 #status 201 = Created
    except Exception as e:
        # Log the error (optional, but recommended for debugging)
        print(f"Database error: {e}")
        
        # Return a JSON error message and a 500 status code
        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500 #status 500 = Server Error
        
    finally:
        # Ensure the connection is closed even if an error occurs
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()