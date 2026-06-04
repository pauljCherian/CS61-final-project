from flask import Blueprint, jsonify, request
import bcrypt
from utils import get_db_connection, token_required, admin_required

# 1. Create the Blueprint
cardio_sessions_bp = Blueprint('cardio_sessions', __name__)

@cardio_sessions_bp.route('/api/workouts/<int:workout_id>/cardio', methods=["GET"])
@token_required
def get_workout_cardio(current_user_id, current_user_is_admin, workout_id):
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)

        check_user_query = "SELECT WorkoutID FROM Workouts WHERE WorkoutID = %s AND UserID = %s"
        cursor.execute(check_user_query, (workout_id, current_user_id))
        if len(cursor.fetchall()) == 0:
            return jsonify({"error": f"Invalid workout ID for this user: {workout_id}"}), 404

        query = "SELECT * FROM CardioSessions WHERE WorkoutID = %s ORDER BY CardioID"
        cursor.execute(query, (workout_id,))
        rows = cursor.fetchall()

        return jsonify(rows), 200
    except Exception as e:
        print(f"Database error: {e}")

        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500
    
    finally:
        cursor.close()
        db.close()

@cardio_sessions_bp.route('/api/workouts/<int:workout_id>/cardio', methods=["POST"])
@token_required
def add_workout_cardio(current_user_id, current_user_is_admin, workout_id):
    try:
        data = request.get_json(silent=True) or {}

        db = get_db_connection()
        cursor = db.cursor(prepared=True)

        check_user_query = "SELECT WorkoutID FROM Workouts WHERE WorkoutID = %s AND UserID = %s"
        cursor.execute(check_user_query, (workout_id, current_user_id))
        if len(cursor.fetchall()) == 0:
            return jsonify({"error": f"Invalid workout ID for this user: {workout_id}"}), 404

        query = ("INSERT INTO CardioSessions (WorkoutID, ActivityType, Duration, Distance, Units, Intensity, Notes) "
            "VALUES (%s, %s, %s, %s, %s, %s, %s)")
        values = (workout_id, data.get("ActivityType"), data.get("Duration"), data.get("Distance"),
                  data.get("Units"), data.get("Intensity"), data.get("Notes"))
        cursor.execute(query, values)
        db.commit()
        new_id = cursor.lastrowid
        
        return jsonify({"id": new_id, "message": "Cardio added"}), 201 #status 201 = Created
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

@cardio_sessions_bp.route('/api/cardio/<int:id>', methods=["PUT"])
@token_required
def update_cardio(current_user_id, current_user_is_admin, id):
    try:
        data = request.get_json() #data provided by client
        # Basic validation
        if not data:
            return jsonify({"error": "No data provided"}), 400 # status 400 = Bad Request
        
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 

        check_user_query = (
            "SELECT c.CardioID "
            "FROM Workouts w "
            "JOIN CardioSessions c ON c.WorkoutID = w.WorkoutID "
            "WHERE w.UserID = %s AND c.CardioID = %s"
            )
        
        check_user_values = (current_user_id, id)

        cursor.execute(check_user_query, check_user_values)
        rows = cursor.fetchall()
        if len(rows) == 0:
          return jsonify({"error": f"Couldn't find cardio session for this user with id {id}"}), 400
        
        allowed_fields = ["ActivityType", "Duration", "Distance", "Units", "Intensity", "Notes"]
        set_clauses = []
        values = []

        for field in allowed_fields:
            if field in data:
                set_clauses.append(f"{field} = %s")
                values.append(data[field])

        if set_clauses:
            query = f"UPDATE CardioSessions SET {', '.join(set_clauses)} WHERE CardioID = %s"

            values.append(id)
            
            cursor.execute(query, tuple(values))
            db.commit()

        cursor.close()
        db.close()

        return jsonify({"message": "Cardio updated successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    finally:
        # Ensure the connection is closed even if an error occurs
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

@cardio_sessions_bp.route('/api/cardio/<int:id>', methods=["DELETE"])
@token_required
def delete_cardio(current_user_id, current_user_is_admin, id : int):
    try:     

        db = get_db_connection()
        cursor = db.cursor(prepared=True) 

        check_user_query = (
            "SELECT c.CardioID "
            "FROM Workouts w "
            "JOIN CardioSessions c ON c.WorkoutID = w.WorkoutID "
            "WHERE w.UserID = %s AND c.CardioID = %s"
            )
        
        check_user_values = (current_user_id, id)

        cursor.execute(check_user_query, check_user_values)
        rows = cursor.fetchall()

        if len(rows) == 0:
          return jsonify({"error": f"Couldn't find cardio session for this user with id {id}"}), 404

        query = ("DELETE FROM CardioSessions WHERE CardioID = %s")
        values = (id,)
        cursor.execute(query, values)

        db.commit()
        
        return jsonify({"id": id, "message": "Cardio Deleted"}), 200
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