import requests

'''
Author: Jack Beecher
Lab 4 CS 61
Client Side
'''

url = "http://127.0.0.1:8080"

def login(username, password):
    try:
        data = {"Username": username, "Password": password}
        endpoint = url + "/api/login"
        response = requests.post(endpoint, json=data)

        if response.status_code == 201:
            resp = response.json()
            return resp["token"]
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

def view_employees(token):
    try:
        endpoint = url + "/api/employees"

        headers = { "Authorization": f"Bearer {token}"}
        response = requests.get(endpoint, headers=headers)

        if response.status_code == 200:
            employees = response.json() # Automatically parses the 'jsonify' data
            print(f"Retrieved {len(employees)} employees:")
            for r in employees:
                print(f"ID: {r[0]} | Name: {r[1]} | Username: {r[2]} | IsAdmin: {r[3]}")
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")
        
def view_profile(token):
    try:
        endpoint = url + "/api/employees/me"

        headers = { "Authorization": f"Bearer {token}"}
        response = requests.get(endpoint, headers=headers)

        if response.status_code == 200:
            employees = response.json() # Automatically parses the 'jsonify' data
            print("Retrieved account:")
            for r in employees:
                print(f"ID: {r[0]} | Name: {r[1]} | Username: {r[2]} | IsAdmin: {r[3]}")
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))

    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

def create_employee(token, username, name, password, admin):
    try:
        endpoint = url + "/api/employees"

        headers = { "Authorization": f"Bearer {token}"}


        data = {"Username": username, "Name": name, "Password": password, "IsAdmin": admin}
        response = requests.post(endpoint, json=data, headers=headers)

        if response.status_code == 201:
            resp = response.json()
            print("Created employee with ID: ", resp["id"])
            return resp["id"]
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

def update_employee(token, id, username, name, password, admin):
    try:
        endpoint = url + "/api/employees"

        headers = { "Authorization": f"Bearer {token}"}

        data = {"EmployeeID": id}
        if username != '':
            data["Username"] = username
        if password != '':
            data["Password"] = password
        if name != '':
            data["Name"] = name 
        if admin != '':
            data["IsAdmin"] = admin

        response = requests.put(endpoint, json=data, headers=headers)

        if response.status_code == 201:
            resp = response.json()
            print("Updated employee with ID: ", resp["id"])
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

def update_profile(token, username, name, password, admin):
    try:
        endpoint = url + "/api/employees/me"

        headers = { "Authorization": f"Bearer {token}"}

        data = {}
        if username != '':
            data["Username"] = username
        if password != '':
            data["Password"] = password
        if name != '':
            data["Name"] = name 
        if admin != '':
            data["IsAdmin"] = int(admin)

        response = requests.put(endpoint, json=data, headers=headers)

        if response.status_code == 201:
            resp = response.json()
            print("Updated employee with ID: ", resp["id"])
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

def delete_employee(token, id):
    try:
        endpoint = url + "/api/employees"

        headers = { "Authorization": f"Bearer {token}"}

        endpoint += (f"/{id}")

        response = requests.delete(endpoint, headers=headers)

        if response.status_code == 201:
            resp = response.json()
            print("Deleted employee with ID: ", resp["id"])
        elif response.status_code == 500:
            print("server error: ", response.status_code, response.json().get("message"))
        else:
            print(response.status_code, response.json().get("error"))
    except:
        print("Could not connect to the server. Make sure your Flask app is running!")

def main():
    token = "" 
    while True:
        print()
        print("Type the number to perform each action")
        print("1. Log in")
        print("2. View all inspectors")
        print("3. View your employee profile")
        print("4. Create new employee")
        print("5. Update an employee")
        print("6. Update your employee profile")
        print("7. Delete an employee")
        print("8. Run full tests (tries admin vs non admin, then not logged in)")
        print("9. Quit")

        choice = input("Choose an option: ")

        if choice == "1":
            print()
            print("-- LOGGING IN --")
            print()
            username = input("What is your username: ")
            password = input("What is your password: ")

            token = login(username, password)

        elif choice == "2":
            print()
            print("-- VIEW EMPLOYEES --")
            print()

            view_employees(token)

        elif choice == "3":
            print()
            print("-- VIEW PROFILE --")
            print()

            view_profile(token)

        elif choice == "4":
            print()
            print("-- CREATE EMPLOYEE --")
            print()

            username = input("Set the Username to: ")
            name = input("Set the Name to: ")
            password = input("Set the Password to: ")
            admin = input("Set the IsAdmin to 1/0: ")

            create_employee(token, username, name, password, admin)

        elif choice == "5":
            print()
            print("-- UPDATE EMPLOYEE --")
            print()

            id = input("What is the ID of the employee you'd like to update: ")
            username = input("Update the Username to (press enter for no change): ")
            name = input("Update the Name to (press enter for no change): ")
            password = input("Update the Password to (press enter for no change): ")
            admin = input("Update the IsAdmin to 1/0 (press enter for no change): ")

            update_employee(token, id, username, name, password, admin)

        elif choice == "6":
            print()
            print("-- UPDATE PROFILE --")
            print()

            username = input("Update the Username to (press enter for no change): ")
            name = input("Update the Name to (press enter for no change): ")
            password = input("Update the Password to (press enter for no change): ")
            admin = input("Update the IsAdmin to 1/0 (press enter for no change): ")

            update_profile(token, username, name, password, admin)

        elif choice == "7":
            print()
            print("-- DELETE EMPLOYEE --")
            print()
            id = input("What is the EmployeeID of the employee to delete: ")
            delete_employee(token, id)
        elif choice == "8":
            temp = token
            print("------- TESTING ----------")
            print("------- TESTING ----------")
            print("------- TESTING ----------")

            print("Logging in with Admin Credentials")

            token = login('jbeecher', 'security')
            
            print("View Employees")
            view_employees(token)
            print("View Profile")
            view_profile(token)
            
            userc = "test1"
            namec = "test1"
            passc = "test1"
            adminc = "1"

            print("Create test1 employee")
            idu = create_employee(token, userc, namec, passc, adminc)

            view_employees(token)

            useru = "test2"
            nameu = "test2"
            passu = "test2"
            adminu = 0
            update_employee(token, idu, useru, nameu, passu, adminu)

            view_employees(token)

            print("Updating personal profile")
            userme = 'jbeecher'
            nameme = 'Jack Beecher'
            passme = 'security'
            adminme = '1'
            update_profile(token, userme, nameme, passme, adminme)

            view_profile(token)

            print("Deleting Test2")

            delete_employee(token, idu)
            print("Viewing employees")
            view_employees(token)

            token = login('nonadmin', 'password')
            
            print("View Employees")
            view_employees(token)

            print("View Profile")
            view_profile(token)
            
            userc = "test1"
            namec = "test1"
            passc = "test1"
            adminc = "1"

            print("Create test1 employee")
            idu = create_employee(token, userc, namec, passc, adminc)

            print("Viewing employees")
            view_employees(token)

            print("Update test1 employee")
            useru = "test2"
            nameu = "test2"
            passu = "test2"
            adminu = 0
            update_employee(token, idu, useru, nameu, passu, adminu)

            print("Viewing employees")
            view_employees(token)

            print("Updating personal profile (try to set admin = 1)")
            userme = 'nonadmin'
            nameme = 'Admin'
            passme = 'password'
            adminme = '1'
            update_profile(token, userme, nameme, passme, adminme)

            print("Updating personal profile (don't set admin)")
            userme = 'nonadmin'
            nameme = 'Admin'
            passme = 'password'
            update_profile(token, userme, nameme, passme, '')

            print("Viewing profile")
            view_profile(token)

            print("Deleting Test2")
            idu = 1
            delete_employee(token, idu)

            print("Viewing employees")
            view_employees(token)

            token = ""

            print("--test endpoints w/o logging in--")
            print("View Employees")
            view_employees(token)

            print("View Profile")
            view_profile(token)
            
            userc = "test1"
            namec = "test1"
            passc = "test1"
            adminc = "1"

            print("Create test1 employee")
            idu = create_employee(token, userc, namec, passc, adminc)
            idu = 1

            print("Viewing employees")
            view_employees(token)

            print("Update test1 employee")
            useru = "test2"
            nameu = "test2"
            passu = "test2"
            adminu = 0
            update_employee(token, idu, useru, nameu, passu, adminu)

            print("Viewing employees")
            view_employees(token)

            print("Updating personal profile (try to set admin = 1)")
            userme = 'nonadmin'
            nameme = 'Admin'
            passme = 'password'
            adminme = '1'
            update_profile(token, userme, nameme, passme, adminme)

            print("Updating personal profile (don't set admin)")
            userme = 'nonadmin'
            nameme = 'Admin'
            passme = 'password'
            update_profile(token, userme, nameme, passme, '')

            print("Viewing profile")
            view_profile(token)

            print("Deleting Test2")
            idu = 1
            delete_employee(token, idu)

            print("Viewing employees")
            view_employees(token)

            print("------- DONE TESTING ----------")
            print("------- DONE TESTING ----------")
            print("------- DONE TESTING ----------")

            token = temp

        elif choice == "9":
            break
        else:
            print("invalid option")

if __name__ == "__main__":
    main()
