from fastapi import APIRouter, HTTPException
from database import users_collection
from schemas.user_schema import RegisterRequest, LoginRequest
from utils.token import create_token

router = APIRouter()

# ----------------------------
# REGISTER
# ----------------------------
@router.post("/register")
def register(data: RegisterRequest):

    if data.role not in ["doctor", "patient"]:
        raise HTTPException(status_code=400, detail="Role must be doctor or patient")

    existing_user = users_collection.find_one({"username": data.username})
    if existing_user:
        raise HTTPException(status_code=400, detail="User already exists")

    users_collection.insert_one({
        "username": data.username,
        "password": data.password,  # hashing next step
        "role": data.role
    })

    return {
        "message": "User registered successfully",
        "user": data.username,
        "role": data.role
    }

# ----------------------------
# LOGIN
# ----------------------------
@router.post("/login")
def login(data: LoginRequest):

    user = users_collection.find_one({"username": data.username})

    if not user or user["password"] != data.password:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_token({
        "sub": data.username,
        "role": user["role"]
    })

    return {
        "access_token": token,
        "token_type": "bearer",
        "role": user["role"]
    }