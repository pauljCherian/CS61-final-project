import requests

BASE_URL = "http://127.0.0.1:8080/api"

# IMPORTANT: You must have a user already in your database, 
# or implement the /api/register route first!
TEST_USER = {
    "Username": "testuser",
    "Password": "password123"
}

def run_tests():
    print("--- Starting API Tests ---\n")

    # 1. TEST LOGIN
    print("1. Testing /api/login...")
    response = requests.post(f"{BASE_URL}/login", json=TEST_USER)
    if response.status_code != 200:
        print(f"FAILED LOGIN: {response.text}")
        return
    
    token = response.json().get("token")
    headers = {"Authorization": f"Bearer {token}"}
    print("SUCCESS: Logged in and received token.\n")

    # 2. TEST GET PROFILE
    print("2. Testing /api/users/me...")
    response = requests.get(f"{BASE_URL}/users/me", headers=headers)
    print(f"Status: {response.status_code}, Data: {response.json()}\n")

    # 3. TEST LOGGING BODYWEIGHT
    print("3. Testing POST /api/bodyweights...")
    weight_data = {
        "RecordedDate": "2026-05-30",
        "Weight": 165.5,
        "Unit": "lb"
    }
    response = requests.post(f"{BASE_URL}/bodyweights", json=weight_data, headers=headers)
    print(f"Status: {response.status_code}, Data: {response.json()}\n")

    # 4. TEST CREATING A WORKOUT
    print("4. Testing POST /api/workouts...")
    workout_data = {
        "WorkoutDate": "2026-05-30",
        "Description": "Morning Cardio & Core",
        "Notes": "Felt great today."
    }
    response = requests.post(f"{BASE_URL}/workouts", json=workout_data, headers=headers)
    print(f"Status: {response.status_code}, Data: {response.json()}")
    
    if response.status_code == 201:
        workout_id = response.json().get("id")
        
        # 5. TEST ADDING CARDIO TO WORKOUT
        print(f"\n5. Testing POST /api/workouts/{workout_id}/cardio...")
        cardio_data = {
            "ActivityType": "Running",
            "Duration": 30,
            "Distance": 3.1,
            "Units": "mi",
            "Intensity": "Moderate",
            "AvgHeartRate": 150,
            "Notes": "Treadmill run"
        }
        response = requests.post(f"{BASE_URL}/workouts/{workout_id}/cardio", json=cardio_data, headers=headers)
        print(f"Status: {response.status_code}, Data: {response.json()}\n")

        # 6. TEST DELETING THE WORKOUT (Cleanup)
        print(f"6. Testing DELETE /api/workouts/{workout_id}...")
        response = requests.delete(f"{BASE_URL}/workouts/{workout_id}", headers=headers)
        print(f"Status: {response.status_code}, Data: {response.json()}\n")
        # NOTE: Due to ON DELETE CASCADE in your SQL, deleting the workout 
        # should automatically delete the cardio session you just added!

    print("--- Tests Complete ---")

if __name__ == "__main__":
    run_tests()