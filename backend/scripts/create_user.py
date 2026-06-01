import requests

# URL to your local Flask app
url = "http://127.0.0.1:8080/api/register"

# The data for the new user
user_data = {
    "Username": "testuser",
    "Email": "testuser@example.com",
    "Password": "password123",
    "FirstName": "Dylan",
    "LastName": "Thomas"
}

print(f"Sending POST request to {url}...")
response = requests.post(url, json=user_data)

# Print the results
print(f"Status Code: {response.status_code}")
print(f"Response Body: {response.json()}")
