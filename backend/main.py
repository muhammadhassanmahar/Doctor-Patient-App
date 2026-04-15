from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# ----------------------------
# ROUTES IMPORT
# ----------------------------
from routes import auth_routes, user_routes, record_routes

# ----------------------------
# APP INIT
# ----------------------------
app = FastAPI()

# ----------------------------
# CORS (FLUTTER / FRONTEND FIX)
# ----------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------------------
# ROUTES CONNECT
# ----------------------------
app.include_router(auth_routes.router)
app.include_router(user_routes.router)
app.include_router(record_routes.router)

# ----------------------------
# HOME
# ----------------------------
@app.get("/")
def home():
    return {
        "message": "Doctor-Patient API Running Successfully 🚀"
    }