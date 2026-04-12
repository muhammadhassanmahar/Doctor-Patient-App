from fastapi import APIRouter, Depends
from app.core.auth import role_required

router = APIRouter()

@router.get("/patient")
def patient(user=Depends(role_required(["patient"]))):
    return {"message": "Patient panel"}