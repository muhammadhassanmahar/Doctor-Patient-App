from bson import ObjectId
from datetime import datetime

# ----------------------------
# SINGLE USER MODEL
# ----------------------------
def user_model(user) -> dict:
    return {
        "id": str(user.get("_id", "")),
        "username": user.get("username", ""),
        "role": user.get("role", ""),
        "created_at": user.get("created_at"),
    }

# ----------------------------
# LIST OF USERS
# ----------------------------
def users_model(users) -> list:
    return [user_model(user) for user in users]