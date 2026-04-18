from fastapi import APIRouter, Depends
from utils.dependencies import verify_token
from database import users_collection, patients_collection, doctors_collection

router = APIRouter()

# ====================================================
# GET CURRENT USER
# ====================================================
@router.get("/me")
def get_current_user(account=Depends(verify_token)):

    user = users_collection.find_one({"username": account.get("sub")})

    return {
        "username": account.get("sub"),
        "role": account.get("role"),
        "user": {
            "username": user["username"],
            "role": user["role"],
            "created_at": user.get("created_at")
        }
    }


# ====================================================
# DASHBOARD (ROLE BASED)
# ====================================================
@router.get("/dashboard")
def dashboard(account=Depends(verify_token)):

    role = account.get("role")
    username = account.get("sub")

    # ----------------------------
    # DOCTOR DASHBOARD
    # ----------------------------
    if role == "doctor":
        patients = list(
            patients_collection.find(
                {"doctor_id": username}
            )
        )

        return {
            "message": f"Welcome Dr. {username}",
            "total_patients": len(patients),
            "patients": [
                {
                    "name": p.get("name"),
                    "disease": p.get("disease"),
                    "status": p.get("status")
                }
                for p in patients
            ]
        }

    # ----------------------------
    # PATIENT DASHBOARD
    # ----------------------------
    else:
        patient = patients_collection.find_one(
            {"user_id": username}
        )

        doctor = None
        if patient and patient.get("doctor_id"):
            doctor = doctors_collection.find_one(
                {"user_id": patient["doctor_id"]}
            )

        return {
            "message": f"Welcome {username}",
            "disease": patient.get("disease") if patient else None,
            "doctor": doctor.get("name") if doctor else None,
            "status": patient.get("status") if patient else None
        }