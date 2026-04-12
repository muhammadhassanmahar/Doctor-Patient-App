from fastapi import APIRouter
from app.models.schemas import RegisterSchema, LoginSchema
from app.db.database import accounts_db
from app.core.security import create_token

router = APIRouter()

# REGISTER
@router.post("/register")
def register(data: RegisterSchema):
    if data.username in accounts_db:
        return {"error": "User exists"}

    accounts_db[data.username] = {
        "password": data.password,
        "role": data.role
    }

    return {"message": "Registered successfully"}

# LOGIN
@router.post("/login")
def login(data: LoginSchema):
    user = accounts_db.get(data.username)

    if not user or user["password"] != data.password:
        return {"error": "Invalid credentials"}

    token = create_token({
        "sub": data.username,
        "role": user["role"]
    })

    return {"access_token": token}