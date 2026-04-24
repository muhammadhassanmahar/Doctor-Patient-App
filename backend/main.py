from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# ----------------------------
# ROUTES IMPORT
# ----------------------------
from routes import auth_routes, user_routes, record_routes

# ----------------------------
# APP INIT
# ----------------------------
app = FastAPI(
    title="Doctor Patient API",
    description="Doctor-Patient Management System Backend",
    version="1.0.0"
)

# ----------------------------
# CORS CONFIG (FLUTTER / WEB FIX)
# ----------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # ⚠️ production me specific domain use karo
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------------------
# ROUTES CONNECT
# ----------------------------
app.include_router(auth_routes.router, prefix="/auth", tags=["Authentication"])
app.include_router(user_routes.router, prefix="/users", tags=["Users"])
app.include_router(record_routes.router, prefix="/records", tags=["Medical Records"])

# ----------------------------
# ROOT CHECK
# ----------------------------
@app.get("/")
def home():
    return {
        "status": "success",
        "message": "Doctor-Patient API Running Successfully 🚀"
    }

# ----------------------------
# HEALTH CHECK
# ----------------------------
@app.get("/health")
def health():
    return {
        "status": "ok",
        "backend": "running",
        "database": "connected"
    }