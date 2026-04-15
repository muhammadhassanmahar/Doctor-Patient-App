from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer
from pydantic import BaseModel
from jose import jwt
from datetime import datetime, timedelta
import requests
from time import time

# ✅ NEW IMPORTS
from database import users_collection
from config import settings

# ----------------------------
# APP INIT
# ----------------------------
app = FastAPI()

# ----------------------------
# CORS (FLUTTER WEB FIX)
# ----------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

security = HTTPBearer()

# ----------------------------
# REQUEST MODELS
# ----------------------------
class RegisterRequest(BaseModel):
    username: str
    password: str
    role: str

class LoginRequest(BaseModel):
    username: str
    password: str

# ----------------------------
# JWT TOKEN CREATE
# ----------------------------
def create_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, settings.SECRET_KEY, algorithm="HS256")

# ----------------------------
# VERIFY TOKEN
# ----------------------------
def verify_token(token=Depends(security)):
    try:
        payload = jwt.decode(token.credentials, settings.SECRET_KEY, algorithms=["HS256"])
        return payload
    except:
        raise HTTPException(status_code=401, detail="Invalid token")

# ----------------------------
# RATE LIMITER
# ----------------------------
request_logs = {}
RATE_LIMIT = 10
TIME_WINDOW = 60

def rate_limiter(account=Depends(verify_token)):
    now = time()
    user = account["sub"]

    timestamps = request_logs.get(user, [])
    timestamps = [t for t in timestamps if now - t < TIME_WINDOW]

    if len(timestamps) >= RATE_LIMIT:
        raise HTTPException(status_code=429, detail="Too many requests")

    timestamps.append(now)
    request_logs[user] = timestamps

    return account

# ----------------------------
# ROLE CHECK
# ----------------------------
def role_required(roles: list):
    def wrapper(account=Depends(verify_token)):
        if account.get("role") not in roles:
            raise HTTPException(status_code=403, detail="Access denied")
        return account
    return wrapper

# ----------------------------
# HOME
# ----------------------------
@app.get("/")
def home():
    return {"message": "Doctor-Patient API Running Successfully"}

# ----------------------------
# REGISTER
# ----------------------------
@app.post("/register")
def register(data: RegisterRequest):

    if data.role not in ["doctor", "patient"]:
        raise HTTPException(status_code=400, detail="Role must be doctor or patient")

    existing_user = users_collection.find_one({"username": data.username})
    if existing_user:
        raise HTTPException(status_code=400, detail="User already exists")

    users_collection.insert_one({
        "username": data.username,
        "password": data.password,  # 🔒 hashing next step
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
@app.post("/login")
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

# ----------------------------
# DASHBOARD
# ----------------------------
@app.get("/dashboard")
def dashboard(account=Depends(verify_token)):
    return {
        "message": f"Welcome {account['role']} {account['sub']}"
    }

# ----------------------------
# DOCTOR PANEL
# ----------------------------
@app.get("/doctor-panel")
def doctor_panel(account=Depends(role_required(["doctor"]))):
    return {
        "message": f"Doctor dashboard accessed by {account['sub']}"
    }

# ----------------------------
# PATIENT PANEL
# ----------------------------
@app.get("/patient-panel")
def patient_panel(account=Depends(role_required(["patient"]))):
    return {
        "message": f"Patient dashboard accessed by {account['sub']}"
    }

# ----------------------------
# MEDICAL RECORDS
# ----------------------------
@app.get("/medical-records")
def medical_records(account=Depends(role_required(["doctor", "patient"]))):
    return {
        "message": f"Medical records viewed by {account['role']} {account['sub']}"
    }

# ----------------------------
# RATE LIMITED ENDPOINT
# ----------------------------
@app.get("/limited")
def limited(account=Depends(rate_limiter)):
    return {
        "message": f"Request allowed for {account['sub']}"
    }

# ----------------------------
# TEST API CALL
# ----------------------------
BACKEND_URL = "https://jsonplaceholder.typicode.com/todos/1"

@app.get("/forward")
def forward(account=Depends(rate_limiter)):
    response = requests.get(BACKEND_URL)
    return {
        "data": response.json()
    }