from flask import Blueprint, jsonify, request
import bcrypt
from utils import get_db_connection, token_required, admin_required

# 1. Create the Blueprint
workout_exercises_bp = Blueprint('workout_exercises', __name__)


def get_or_create_exercise(cursor, name):
    """Return the ExerciseID for `name`, creating the catalog row if it's new.

    Lookup is case-insensitive ("bench press" matches "Bench Press"), so we
    reuse an existing exercise instead of making a near-duplicate. The first
    spelling seen is the one stored. Runs on the caller's cursor/transaction.
    """
    cursor.execute(
        "SELECT ExerciseID FROM Exercises WHERE LOWER(ExerciseName) = LOWER(%s)",
        (name,),
    )
    row = cursor.fetchone()
    if row:
        return row[0]

    cursor.execute("INSERT INTO Exercises (ExerciseName) VALUES (%s)", (name,))
    return cursor.lastrowid


# Workout exercise relation

@workout_exercises_bp.route('/api/workouts/<int:workout_id>/exercises', methods=["GET"])
@token_required
def get_workout_exercises(current_user_id, current_user_is_admin, workout_id):
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)

        check_user_query = "SELECT * FROM Workouts WHERE WorkoutID = %s AND UserID = %s"
        check_user_values = (workout_id, current_user_id)

        cursor.execute(check_user_query, check_user_values)
        rows = cursor.fetchall()
        if len(rows) == 0:
            return jsonify({"error": f"Invalid workout ID for this user: {workout_id}"}), 404

        query = "SELECT * FROM WorkoutExercise WHERE WorkoutID = %s"
        values = (workout_id,)
        cursor.execute(query, values)
        rows = cursor.fetchall()

        return jsonify(rows), 200
    except Exception as e:
        print(f"Database error: {e}")

        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500
    
    finally:
        cursor.close()
        db.close()

@workout_exercises_bp.route('/api/workouts/<int:workout_id>/exercises', methods=["POST"])
@token_required
def add_workout_exercise(current_user_id, current_user_is_admin, workout_id):
    try:
        data = request.get_json() #data provided by client
        # Basic validation
        if not data:
            return jsonify({"error": "No data provided"}), 400 # status 400 = Bad Request
                
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 

        check_user_query = "SELECT WorkoutID FROM Workouts WHERE WorkoutID = %s AND UserID = %s"
        cursor.execute(check_user_query, (workout_id, current_user_id))
        if len(cursor.fetchall()) == 0:
            return jsonify({"error": f"Invalid workout ID for this user: {workout_id}"}), 404

        # Turn the typed name into an ExerciseID, creating the exercise if new.
        exercise_id = get_or_create_exercise(cursor, data["ExerciseName"])

        query = ("INSERT INTO WorkoutExercise (WorkoutID, ExerciseID, OrderNum, Notes) "
            "VALUES (%s, %s, %s, %s)")
        values = (workout_id, exercise_id, data.get("OrderNum"), data.get("Notes"))
        cursor.execute(query, values)
        db.commit()
        new_id = cursor.lastrowid
        
        return jsonify({"id": new_id, "message": "Workout Exercise added"}), 201 #status 201 = Created
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

@workout_exercises_bp.route('/api/workout-exercises/<int:id>', methods=["PUT"])
@token_required
def update_workout_exercise(current_user_id, current_user_is_admin, id):
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "No data provided"}), 400

        db = get_db_connection()
        cursor = db.cursor(prepared=True)

        check_user_query = (
            "SELECT w.UserID "
            "FROM Workouts w "
            "JOIN WorkoutExercise we ON we.WorkoutID = w.WorkoutID "
            "WHERE we.WorkoutExerciseID = %s AND w.UserID = %s"
        )
        cursor.execute(check_user_query, (id, current_user_id))
        if len(cursor.fetchall()) == 0:
            return jsonify({"error": f"Invalid workout exercise ID for this user: {id}"}), 404

        set_clauses = []
        values = []

        # Renaming re-points this lift at a (possibly new) exercise; sets stay put.
        if "ExerciseName" in data:
            exercise_id = get_or_create_exercise(cursor, data["ExerciseName"])
            set_clauses.append("ExerciseID = %s")
            values.append(exercise_id)

        if "Notes" in data:
            set_clauses.append("Notes = %s")
            values.append(data["Notes"])

        if set_clauses:
            query = f"UPDATE WorkoutExercise SET {', '.join(set_clauses)} WHERE WorkoutExerciseID = %s"
            values.append(id)
            cursor.execute(query, tuple(values))
            db.commit()

        return jsonify({"message": "Workout exercise updated successfully"}), 200

    except Exception as e:
        print(f"Database error: {e}")
        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500

    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

@workout_exercises_bp.route('/api/workout-exercises/<int:id>', methods=["DELETE"])
@token_required
def delete_workout_exercise(current_user_id, current_user_is_admin, id : int):
    try:        
        db = get_db_connection()
        cursor = db.cursor(prepared=True)

        check_user_query = (
            "SELECT w.UserID "
            "FROM Workouts w "
            "JOIN WorkoutExercise we ON we.WorkoutID = w.WorkoutID "
            "WHERE we.WorkoutExerciseID = %s AND w.UserID = %s"
          )
        check_user_values = (id, current_user_id)

        cursor.execute(check_user_query, check_user_values)
        rows = cursor.fetchall()
        if len(rows) == 0:
            return jsonify({"error": f"Invalid workout exercise ID for this user: {id}"})

        query = ("DELETE FROM WorkoutExercise WHERE WorkoutExerciseID = %s")
        values = (id,)
        cursor.execute(query, values)

        db.commit()
        
        return jsonify({"id": id, "message": "Workout Exercise Deleted"}), 200
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

# Sets related

@workout_exercises_bp.route('/api/workout-exercises/<int:we_id>/sets', methods=["GET"])
@token_required
def get_sets(current_user_id, current_user_is_admin, we_id):
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)

        check_user_query = (
            "SELECT w.UserID "
            "FROM Workouts w "
            "JOIN WorkoutExercise we ON we.WorkoutID = w.WorkoutID "
            "WHERE we.WorkoutExerciseID = %s AND w.UserID = %s"
          )
        check_user_values = (we_id, current_user_id)

        cursor.execute(check_user_query, check_user_values)
        rows = cursor.fetchall()
        if len(rows) == 0:
            return jsonify({"error": f"Invalid workout exercise ID for this user: {id}"})

        query = "SELECT * FROM WorkoutSets WHERE WorkoutExerciseID = %s"
        values = (we_id,)
        cursor.execute(query, values)
        rows = cursor.fetchall()

        return jsonify(rows), 200
    except Exception as e:
        print(f"Database error: {e}")

        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500
    
    finally:
        cursor.close()
        db.close()

@workout_exercises_bp.route('/api/workout-exercises/<int:we_id>/sets', methods=["POST"])
@token_required
def add_set(current_user_id, current_user_is_admin, we_id):
    try:
        data = request.get_json() #data provided by client
        # Basic validation
        if not data:
            return jsonify({"error": "No data provided"}), 400 # status 400 = Bad Request
                
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 

        check_user_query = (
            "SELECT w.UserID "
            "FROM Workouts w "
            "JOIN WorkoutExercise we ON we.WorkoutID = w.WorkoutID "
            "WHERE we.WorkoutExerciseID = %s AND w.UserID = %s"
          )
        check_user_values = (we_id, current_user_id)

        cursor.execute(check_user_query, check_user_values)
        rows = cursor.fetchall()
        if len(rows) == 0:
            return jsonify({"error": f"Invalid workout exercise ID for this user: {id}"})

        query = ("INSERT INTO WorkoutSets (WorkoutExerciseID, SetNum, Weight, Reps, RPE) "
            "VALUES (%s, %s, %s, %s, %s)")
        values = (we_id, data["SetNum"], data['Weight'], data["Reps"], data["RPE"])
        cursor.execute(query, values)
        db.commit()
        new_id = cursor.lastrowid
        
        return jsonify({"id": new_id, "message": "Set added"}), 201 #status 201 = Created
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

@workout_exercises_bp.route('/api/sets/<int:id>', methods=["PUT"])
@token_required
def update_set(current_user_id, current_user_is_admin, id):
    try:
        data = request.get_json() #data provided by client
        # Basic validation
        if not data:
            return jsonify({"error": "No data provided"}), 400 # status 400 = Bad Request
        
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 

        check_user_query = (
            "SELECT w.UserID "
            "FROM Workouts w "
            "JOIN WorkoutExercise we ON we.WorkoutID = w.WorkoutID "
            "JOIN WorkoutSets ws ON ws.WorkoutExerciseID = we.WorkoutExerciseID "
            "WHERE ws.SetID = %s AND w.UserID = %s"
          )
        check_user_values = (id, current_user_id)

        cursor.execute(check_user_query, check_user_values)
        rows = cursor.fetchall()
        if len(rows) == 0:
            return jsonify({"error": f"Invalid workout set ID for this user: {id}"})

        allowed_fields = ["SetNum", "Weight", "Reps", "RPE"]
        set_clauses = []
        values = []

        for field in allowed_fields:
            if field in data:
                set_clauses.append(f"{field} = %s")
                values.append(data[field])

        if set_clauses:
            query = f"UPDATE WorkoutSets SET {', '.join(set_clauses)} WHERE SetID = %s"
            
            values.append(id)
            
            cursor.execute(query, tuple(values))
            db.commit()

        cursor.close()
        db.close()

        return jsonify({"message": "Set updated successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    finally:
        # Ensure the connection is closed even if an error occurs
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

@workout_exercises_bp.route('/api/sets/<int:id>', methods=["DELETE"])
@token_required
def delete_weight(current_user_id, current_user_is_admin, id : int):
    try:        
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 

        check_user_query = (
            "SELECT w.UserID "
            "FROM Workouts w "
            "JOIN WorkoutExercise we ON we.WorkoutID = w.WorkoutID "
            "JOIN WorkoutSets ws ON ws.WorkoutExerciseID = we.WorkoutExerciseID "
            "WHERE ws.SetID = %s AND w.UserID = %s"
          )
        check_user_values = (id, current_user_id)

        cursor.execute(check_user_query, check_user_values)
        rows = cursor.fetchall()
        if len(rows) == 0:
            return jsonify({"error": f"Invalid workout set ID for this user: {id}"})

        query = ("DELETE FROM WorkoutSets WHERE SetID = %s")
        values = (id,)
        cursor.execute(query, values)

        db.commit()
        
        return jsonify({"id": id, "message": "Set Deleted"}), 200
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