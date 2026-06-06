from flask import Blueprint, jsonify, request
import bcrypt
from utils import get_db_connection, token_required

# 1. Create the Blueprint
workouts_bp = Blueprint('workouts', __name__)

@workouts_bp.route('/api/workouts', methods=["GET"])
@token_required
def get_workouts(current_user_id):
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        query = "SELECT * FROM Workouts WHERE UserID = %s"
        values = (current_user_id,)
        cursor.execute(query, values)
        rows = cursor.fetchall()

        return jsonify(rows), 200
    except Exception as e:
        print(f"Database error: {e}")

        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500
    
    finally:
        cursor.close()
        db.close()

@workouts_bp.route('/api/workouts/<int:id>', methods=["GET"])
@token_required
def get_workout(current_user_id, id):
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        query = "SELECT * FROM Workouts WHERE UserID = %s AND WorkoutID = %s"
        values = (current_user_id, id)
        cursor.execute(query, values)
        rows = cursor.fetchall()

        return jsonify(rows), 200
    except Exception as e:
        print(f"Database error: {e}")

        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500
    
    finally:
        cursor.close()
        db.close()

@workouts_bp.route('/api/workouts', methods=["POST"])
@token_required
def add_workout(current_user_id):
    try:
        data = request.get_json() #data provided by client
        # Basic validation
        if not data:
            return jsonify({"error": "No data provided"}), 400 # status 400 = Bad Request
                
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 
        query = ("INSERT INTO Workouts (UserID, WorkoutDate, Description, Notes) "
            "VALUES (%s, %s, %s, %s)")
        values = (current_user_id, data["WorkoutDate"], data['Description'], data["Notes"])
        cursor.execute(query, values)
        db.commit()
        new_id = cursor.lastrowid
        
        return jsonify({"id": new_id, "message": "Workout added"}), 201 #status 201 = Created
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

@workouts_bp.route('/api/workouts/<int:id>', methods=["PUT"])
@token_required
def update_workout(current_user_id, id):
    try:
        data = request.get_json() #data provided by client
        # Basic validation
        if not data:
            return jsonify({"error": "No data provided"}), 400 # status 400 = Bad Request
        
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 

        allowed_fields = ["WorkoutDate", "Description", "Notes"]
        set_clauses = []
        values = []

        for field in allowed_fields:
            if field in data:
                set_clauses.append(f"{field} = %s")
                values.append(data[field])

        if set_clauses:
            query = f"UPDATE Workouts SET {', '.join(set_clauses)} WHERE UserID = %s AND WorkoutID = %s"
            
            values.append(current_user_id) 
            values.append(id)
            
            cursor.execute(query, tuple(values))
            db.commit()

        cursor.close()
        db.close()

        return jsonify({"message": "Workout updated successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    finally:
        # Ensure the connection is closed even if an error occurs
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

@workouts_bp.route('/api/workouts/<int:id>', methods=["DELETE"])
@token_required
def delete_workout(current_user_id, id : int):
    try:        
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 
        query = ("DELETE FROM Workouts WHERE UserID = %s AND WorkoutID = %s")
        values = (current_user_id, id)
        cursor.execute(query, values)

        db.commit()
        
        return jsonify({"id": id, "message": "Workout Deleted"}), 200
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
