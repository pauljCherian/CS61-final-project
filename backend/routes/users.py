from flask import Blueprint, jsonify, request, current_app
import bcrypt
from utils import get_db_connection, token_required, admin_required
import jwt

# 1. Create the Blueprint
users_bp = Blueprint('users', __name__)

@users_bp.route('/api/register', methods=["POST"])
def register():
    try:
        data = request.get_json()
        
        # 1. Basic validation
        if not data or 'Username' not in data or 'Email' not in data or 'Password' not in data:
            return jsonify({"error": "Username, Email, and Password are required"}), 400
        
        # 2. Hash the password securely
        salt = bcrypt.gensalt()
        hashed_password = bcrypt.hashpw(data['Password'].encode('utf-8'), salt)
        
        # 3. Connect to DB
        db = get_db_connection()
        cursor = db.cursor(prepared=True)
        
        # 4. Insert into the Users table
        # We use data.get() for the optional fields so they default to None (NULL in SQL) if missing
        query = """
            INSERT INTO Users (Username, Email, HashedPassword, FirstName, LastName, City, State) 
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        values = (
            data['Username'], 
            data['Email'], 
            hashed_password.decode('utf-8'),
            data.get('FirstName'),
            data.get('LastName'),
            data.get('City'),
            data.get('State')
        )
        
        cursor.execute(query, values)
        db.commit()
        new_user_id = cursor.lastrowid
        
        return jsonify({"id": new_user_id, "message": "User registered successfully"}), 201

    except Exception as e:
        # If the Username or Email already exists, MySQL will throw an IntegrityError.
        # We catch it here to prevent the server from crashing.
        if "Duplicate entry" in str(e):
            return jsonify({"error": "Username or Email already exists"}), 409
        
        print(f"Database error: {e}")
        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500
        
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

@users_bp.route('/api/login', methods=["POST"])
def login():
    user = None
    data = request.get_json()

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)
    query = "SELECT HashedPassword FROM Users WHERE Username = %s"
    values = (data["Username"],)
    cursor.execute(query, values)
    row = cursor.fetchone()
    if not row:
        cursor.close()
        db.close()
        return jsonify({"error": "Invalid credentials"}), 401
    hashed = row["HashedPassword"]
    if bcrypt.checkpw(data['Password'].encode('utf-8'), hashed.encode('utf-8')):
        query = "SELECT * FROM Users WHERE Username = %s"
        values = (data["Username"],)
        cursor.execute(query, values)

        user = cursor.fetchone()
    cursor.close()
    db.close()

    if not user:
        return jsonify({"error": "Invalid credentials"}), 401
    
    payload = {
        "UserID": user["UserID"],
        "Admin": bool(user["IsAdmin"])
    }

    token = jwt.encode(payload, current_app.config['SECRET_KEY'] or "SECRET_KEY", algorithm="HS256")
    return jsonify({"token": token, "message": "Logged in"}), 200

@users_bp.route('/api/users/me', methods=["GET"])
@token_required
def get_self(current_user_id):
    try:
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        query = "SELECT * FROM Users WHERE UserID = %s"
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

@users_bp.route('/api/users/me', methods=["PUT"])
@token_required
def update_self(current_user_id):
    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "No data provided"}), 400

        db = get_db_connection()
        cursor = db.cursor(prepared=True) 

        allowed_fields = ["FirstName", "LastName", "City", "State"]
        set_clauses = []
        values = []

        for field in allowed_fields:
            if field in data:
                set_clauses.append(f"{field} = %s")
                values.append(data[field])

        if 'Password' in data:
            salt = bcrypt.gensalt()
            hash_password = bcrypt.hashpw(data["Password"].encode('utf-8'), salt)
            set_clauses.append("HashedPassword = %s")
            values.append(hash_password.decode('utf-8'))

        if set_clauses:
            query = f"UPDATE Users SET {', '.join(set_clauses)} WHERE UserID = %s"

            values.append(current_user_id)

            cursor.execute(query, tuple(values))
            db.commit()

        cursor.close()
        db.close()

        return jsonify({"message": "User updated successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@users_bp.route('/api/users/<int:id>', methods=["DELETE"])
@admin_required
def delete_user(current_user_id, id : int):
    try:        
        db = get_db_connection()
        cursor = db.cursor(prepared=True) 
        query = ("DELETE FROM Users WHERE UserID = %s")
        values = (id,)
        cursor.execute(query, values)

        db.commit()
        
        return jsonify({"id": id, "message": "User Deletes"}), 200
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
