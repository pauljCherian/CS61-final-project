from flask import request, jsonify, current_app
from functools import wraps
import mysql.connector
import json
import jwt

# Load credentials once
with open('db.json') as config_file:
    credentials = json.load(config_file)['localhost']

def get_db_connection():
    return mysql.connector.connect(
        host=credentials['host'], user=credentials['user'], 
        password=credentials['password'], database=credentials['database']
    )

def get_token():
    token = None
    if 'Authorization' in request.headers:
        auth_header = request.headers['Authorization']
        parts = auth_header.split()
        if len(parts) == 2 and parts[0] == 'Bearer':
            token = parts[1]
    return token

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = get_token()
        if not token:
            return jsonify({"error": "Token is missing. Please log in"}), 401
        
        try:
            # USE current_app here!
            data = jwt.decode(token, current_app.config.get('SECRET_KEY', "SECRET_KEY"), algorithms=["HS256"])
            current_user_id = data['UserID']
        except Exception as e:
            return jsonify({'error': str(e)}), 401

        return f(current_user_id, *args, **kwargs)
    return decorated

def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = get_token()

        if not token:
            return jsonify({"error": "Token is missing. Please log in"}), 401
        
        try:
            data = jwt.decode(token, current_app.config.get('SECRET_KEY', 'SECRET_KEY'), algorithms=["HS256"])
            current_user_id = data['UserID']
            current_user_is_admin = data['Admin']
        except jwt.ExpiredSignatureError:
            return jsonify({'error': 'Token has expired. Please log in again'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'error': 'Token is invalid.'}), 401

        if not current_user_is_admin:
            return jsonify({'error': 'Admin access required'}), 403

        return f(current_user_id, *args, **kwargs)

    return decorated
