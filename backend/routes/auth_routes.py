from fastapi import APIRouter, HTTPException
from database import users_collection
from schemas.user_schema import RegisterRequest, LoginRequest
from utils.token import create_token
from utils.hashing import hash_password, verify_password

router = APIRouter()

# ----------------------------
# REGISTER
# ----------------------------
@router.post("/register")
def register(data: RegisterRequest):

    # role validation
    if data.role not in ["doctor", "patient"]:
        raise HTTPException(status_code=400, detail="Role must be doctor or patient")

    # check user exists
    existing_user = users_collection.find_one({"username": data.username})
    if existing_user:
        raise HTTPException(status_code=400, detail="User already exists")

    # 🔒 HASH PASSWORD (IMPORTANT FIX)
    users_collection.insert_one({
        "username": data.username,
        "password": hash_password(data.password),
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

    # 🔒 VERIFY HASHED PASSWORD
    if not user or not verify_password(data.password, user["password"]):
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