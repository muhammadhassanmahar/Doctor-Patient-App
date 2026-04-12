from fastapi import APIRouter, Depends
from app.core.auth import role_required

router = APIRouter()

@router.get("/doctor")
def doctor(user=Depends(role_required(["doctor"]))):
    return {"message": "Doctor panel"}