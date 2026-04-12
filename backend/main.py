from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer
from jose import jwt
from datetime import datetime, timedelta
import requests
from time import time

app = FastAPI()

# ----------------------------
# CORS FIX (IMPORTANT FOR FLUTTER WEB)
# ----------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # development only
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

security = HTTPBearer()
SECRET_KEY = "mysecretkey"

# ----------------------------
# Fake Database (Doctors & Patients)
# ----------------------------
accounts_db = {}

# ----------------------------
# JWT Token Creation
# ----------------------------
def create_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=30)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm="HS256")

# ----------------------------
# Verify Token
# ----------------------------
def verify_token(token=Depends(security)):
    try:
        payload = jwt.decode(token.credentials, SECRET_KEY, algorithms=["HS256"])
        return payload
    except:
        raise HTTPException(status_code=401, detail="Invalid token")

# ----------------------------
# Rate Limiter
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
# Role-based Access (Doctor / Patient)
# ----------------------------
def role_required(roles: list):
    def wrapper(account=Depends(verify_token)):
        if account.get("role") not in roles:
            raise HTTPException(status_code=403, detail="Access denied")
        return account
    return wrapper

# ----------------------------
# Routes
# ----------------------------
@app.get("/")
def home():
    return {"message": "Doctor-Patient API Gateway Running"}

# ----------------------------
# Register
# ----------------------------
@app.post("/register")
def register(username: str, password: str, role: str):
    if role not in ["doctor", "patient"]:
        raise HTTPException(status_code=400, detail="Role must be doctor or patient")

    if username in accounts_db:
        raise HTTPException(status_code=400, detail="Account already exists")

    accounts_db[username] = {
        "password": password,
        "role": role
    }

    return {"message": f"{role.capitalize()} '{username}' registered successfully"}

# ----------------------------
# Login
# ----------------------------
@app.post("/login")
def login(username: str, password: str):
    account = accounts_db.get(username)

    if not account or account["password"] != password:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_token({
        "sub": username,
        "role": account["role"]
    })

    return {"access_token": token}

# ----------------------------
# Dashboard
# ----------------------------
@app.get("/dashboard")
def dashboard(account=Depends(verify_token)):
    return {"message": f"Welcome {account['role']} {account['sub']}"}

# ----------------------------
# Doctor Only
# ----------------------------
@app.get("/doctor-panel")
def doctor_panel(account=Depends(role_required(["doctor"]))):
    return {"message": f"Doctor panel accessed by Dr. {account['sub']}"}

# ----------------------------
# Patient Only
# ----------------------------
@app.get("/patient-panel")
def patient_panel(account=Depends(role_required(["patient"]))):
    return {"message": f"Patient panel accessed by {account['sub']}"}

# ----------------------------
# Medical Records
# ----------------------------
@app.get("/medical-records")
def medical_records(account=Depends(role_required(["doctor", "patient"]))):
    return {"message": f"Medical records viewed by {account['role']} {account['sub']}"}

# ----------------------------
# Rate Limited
# ----------------------------
@app.get("/limited")
def limited(account=Depends(rate_limiter)):
    return {"message": f"Request allowed for {account['role']} {account['sub']}"}

# ----------------------------
# Forward API
# ----------------------------
BACKEND_URL = "https://jsonplaceholder.typicode.com/todos/1"

@app.get("/forward")
def forward(account=Depends(rate_limiter)):
    response = requests.get(BACKEND_URL)
    return {"data": response.json()}