from fastapi import APIRouter, HTTPException
from database import users_collection
from models import RegisterModel, LoginModel
from utils.token import create_token
from utils.hashing import hash_password, verify_password
from datetime import datetime

router = APIRouter()


# ----------------------------
# REGISTER USER (DOCTOR / PATIENT)
# ----------------------------
@router.post("/register")
def register(data: RegisterModel):

    # role validation
    if data.role not in ["doctor", "patient"]:
        raise HTTPException(
            status_code=400,
            detail="Role must be doctor or patient"
        )

    # check if user exists
    existing_user = users_collection.find_one({"username": data.username})
    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="User already exists"
        )

    # create user object
    user_data = {
        "username": data.username,
        "password": hash_password(data.password),
        "role": data.role,
        "created_at": datetime.utcnow()
    }

    # insert into DB
    users_collection.insert_one(user_data)

    return {
        "status": "success",
        "message": "User registered successfully",
        "user": data.username,
        "role": data.role
    }


# ----------------------------
# LOGIN USER
# ----------------------------
@router.post("/login")
def login(data: LoginModel):

    user = users_collection.find_one({"username": data.username})

    # verify user + password
    if not user or not verify_password(data.password, user["password"]):
        raise HTTPException(
            status_code=401,
            detail="Invalid username or password"
        )

    # create JWT token
    token = create_token({
        "sub": user["username"],
        "role": user["role"]
    })

    return {
        "status": "success",
        "access_token": token,
        "token_type": "bearer",
        "role": user["role"]
    }