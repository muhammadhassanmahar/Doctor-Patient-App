from bson import ObjectId

# ----------------------------
# USER MODEL (MongoDB Document)
# ----------------------------
def user_model(user) -> dict:
    return {
        "id": str(user["_id"]),
        "username": user["username"],
        "password": user["password"],
        "role": user["role"]
    }

# ----------------------------
# HELPER (LIST OF USERS)
# ----------------------------
def users_model(users) -> list:
    return [user_model(user) for user in users]