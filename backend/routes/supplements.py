from flask import Blueprint, jsonify, request
import bcrypt
from utils import get_db_connection, token_required

# 1. Create the Blueprint
supplements_bp = Blueprint('supplements', __name__)

@supplements_bp.route('/api/supplements', methods=["GET"])
@token_required
def get_supplements(current_user_id):
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        query = "SELECT * FROM Supplements WHERE UserID = %s"
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

@supplements_bp.route('/api/supplements', methods=["POST"])
@token_required
def add_supplement(current_user_id):
    try:
        data = request.get_json() #data provided by client
        # Basic validation
        if not data:
            return jsonify({"error": "No data provided"}), 400 # status 400 = Bad Request
                
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 
        query = ("INSERT INTO Supplements (UserID, SupplementName, Dosage, Units, ValidFrom, ValidTo) "
            "VALUES (%s, %s, %s, %s, %s, %s)")
        values = (current_user_id, data["SupplementName"], data['Dosage'], data["Units"], data["ValidFrom"], data["ValidTo"])
        cursor.execute(query, values)
        db.commit()
        new_id = cursor.lastrowid
        
        return jsonify({"id": new_id, "message": "Supplement added"}), 201 #status 201 = Created
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

@supplements_bp.route('/api/supplements/<int:id>', methods=["PUT"])
@token_required
def update_supplement(current_user_id, id):
    try:
        data = request.get_json() #data provided by client
        # Basic validation
        if not data:
            return jsonify({"error": "No data provided"}), 400 # status 400 = Bad Request
        
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 

        allowed_fields = ['SupplementName', 'Dosage', 'Units', 'ValidFrom', 'ValidTo']
        set_clauses = []
        values = []

        for field in allowed_fields:
            if field in data:
                set_clauses.append(f"{field} = %s")
                values.append(data[field])

        if set_clauses:
            query = f"UPDATE Supplements SET {', '.join(set_clauses)} WHERE UserID = %s AND SupplementID = %s"
            
            values.append(current_user_id) 
            values.append(id)
            
            cursor.execute(query, tuple(values))
            db.commit()

        cursor.close()
        db.close()

        return jsonify({"message": "Supplement updated successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    finally:
        # Ensure the connection is closed even if an error occurs
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

@supplements_bp.route('/api/supplements/<int:id>', methods=["DELETE"])
@token_required
def delete_supplement(current_user_id, id : int):
    try:        
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 
        query = ("DELETE FROM Supplements WHERE UserID = %s AND SupplementID = %s")
        values = (current_user_id, id)
        cursor.execute(query, values)

        db.commit()
        
        return jsonify({"id": id, "message": "Supplement Deleted"}), 200
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