from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer
from pydantic import BaseModel
from jose import jwt
from datetime import datetime, timedelta
import requests
from time import time

# ----------------------------
# APP INIT
# ----------------------------
app = FastAPI()

# ----------------------------
# CORS FIX (FLUTTER WEB)
# ----------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

security = HTTPBearer()
SECRET_KEY = "mysecretkey"

# ----------------------------
# FAKE DATABASE
# ----------------------------
accounts_db = {}

# ----------------------------
# REQUEST MODELS (FIX 422 ERROR)
# ----------------------------
class RegisterRequest(BaseModel):
    username: str
    password: str
    role: str

class LoginRequest(BaseModel):
    username: str
    password: str

# ----------------------------
# JWT TOKEN
# ----------------------------
def create_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=30)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm="HS256")

# ----------------------------
# VERIFY TOKEN
# ----------------------------
def verify_token(token=Depends(security)):
    try:
        payload = jwt.decode(token.credentials, SECRET_KEY, algorithms=["HS256"])
        return payload
    except:
        raise HTTPException(status_code=401, detail="Invalid token")

# ----------------------------
# RATE LIMITER
# ----------------------------
request_logs = {}
RATE_LIMIT = 5
TIME_WINDOW = 60

def rate_limiter(account=Depends(verify_token)):
    now = time()
    timestamps = request_logs.get(account["sub"], [])
    timestamps = [t for t in timestamps if now - t < TIME_WINDOW]

    if len(timestamps) >= RATE_LIMIT:
        raise HTTPException(status_code=429, detail="Too many requests")

    timestamps.append(now)
    request_logs[account["sub"]] = timestamps
    return account

# ----------------------------
# ROLE BASED ACCESS
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
    return {"message": "Doctor-Patient API Gateway Running"}

# ----------------------------
# REGISTER (FIXED)
# ----------------------------
@app.post("/register")
def register(data: RegisterRequest):
    if data.role not in ["doctor", "patient"]:
        raise HTTPException(status_code=400, detail="Role must be doctor or patient")

    if data.username in accounts_db:
        raise HTTPException(status_code=400, detail="Account already exists")

    accounts_db[data.username] = {
        "password": data.password,
        "role": data.role
    }

    return {"message": f"{data.role.capitalize()} '{data.username}' registered successfully"}

# ----------------------------
# LOGIN (FIXED)
# ----------------------------
@app.post("/login")
def login(data: LoginRequest):
    account = accounts_db.get(data.username)

    if not account or account["password"] != data.password:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_token({
        "sub": data.username,
        "role": account["role"]
    })

    return {"access_token": token}

# ----------------------------
# DASHBOARD
# ----------------------------
@app.get("/dashboard")
def dashboard(account=Depends(verify_token)):
    return {"message": f"Welcome {account['role']} {account['sub']}"}

# ----------------------------
# DOCTOR PANEL
# ----------------------------
@app.get("/doctor-panel")
def doctor_panel(account=Depends(role_required(["doctor"]))):
    return {"message": f"Doctor panel accessed by Dr. {account['sub']}"}

# ----------------------------
# PATIENT PANEL
# ----------------------------
@app.get("/patient-panel")
def patient_panel(account=Depends(role_required(["patient"]))):
    return {"message": f"Patient panel accessed by {account['sub']}"}

# ----------------------------
# MEDICAL RECORDS
# ----------------------------
@app.get("/medical-records")
def medical_records(account=Depends(role_required(["doctor", "patient"]))):
    return {"message": f"Medical records viewed by {account['role']} {account['sub']}"}

# ----------------------------
# RATE LIMITED
# ----------------------------
@app.get("/limited")
def limited(account=Depends(rate_limiter)):
    return {"message": f"Request allowed for {account['role']} {account['sub']}"}

# ----------------------------
# FORWARD API
# ----------------------------
BACKEND_URL = "https://jsonplaceholder.typicode.com/todos/1"

@app.get("/forward")
def forward(account=Depends(rate_limiter)):
    response = requests.get(BACKEND_URL)
    return {"data": response.json()}