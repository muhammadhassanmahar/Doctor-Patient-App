from fastapi import APIRouter, Depends
from utils.dependencies import verify_token

router = APIRouter()

# ----------------------------
# GET CURRENT USER
# ----------------------------
@router.get("/me")
def get_current_user(account=Depends(verify_token)):
    return {
        "username": account["sub"],
        "role": account["role"]
    }

# ----------------------------
# DASHBOARD
# ----------------------------
@router.get("/dashboard")
def dashboard(account=Depends(verify_token)):
    return {
        "message": f"Welcome {account['role']} {account['sub']}"
    }