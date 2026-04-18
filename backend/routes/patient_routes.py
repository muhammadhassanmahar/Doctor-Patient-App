from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime
from bson import ObjectId

from database import users_collection, records_collection, patients_collection
from utils.dependencies import verify_token, role_required

router = APIRouter()


# ====================================================
# ADD / ASSIGN PATIENT (DOCTOR ONLY)
# ====================================================
@router.post("/patients/assign")
def assign_patient(data: dict, account=Depends(role_required(["doctor"]))):
    """
    data = {
        "patient_username": "ali123",
        "disease": "flu"
    }
    """

    patient = users_collection.find_one({"username": data["patient_username"]})

    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")

    if patient["role"] != "patient":
        raise HTTPException(status_code=400, detail="User is not a patient")

    # update / assign doctor
    users_collection.update_one(
        {"username": data["patient_username"]},
        {
            "$set": {
                "doctor": account["sub"],
                "disease": data.get("disease", ""),
                "updated_at": datetime.utcnow()
            }
        }
    )

    return {
        "message": "Patient assigned to doctor successfully"
    }


# ====================================================
# GET MY PATIENTS (DOCTOR)
# ====================================================
@router.get("/patients")
def get_patients(account=Depends(role_required(["doctor"]))):

    patients = users_collection.find({"doctor": account["sub"], "role": "patient"})

    result = []
    for p in patients:
        result.append({
            "username": p["username"],
            "disease": p.get("disease", ""),
            "doctor": p.get("doctor", "")
        })

    return {
        "count": len(result),
        "patients": result
    }


# ====================================================
# GET MY DOCTOR (PATIENT)
# ====================================================
@router.get("/my-doctor")
def get_my_doctor(account=Depends(role_required(["patient"]))):

    patient = users_collection.find_one({"username": account["sub"]})

    if not patient or "doctor" not in patient:
        return {
            "message": "No doctor assigned yet"
        }

    doctor = users_collection.find_one({"username": patient["doctor"]})

    return {
        "doctor": {
            "username": doctor["username"],
            "role": doctor["role"]
        }
    }


# ====================================================
# GET MY RECORDS (PATIENT)
# ====================================================
@router.get("/my-records")
def my_records(account=Depends(role_required(["patient"]))):

    records = records_collection.find({"patient": account["sub"]})

    result = []
    for r in records:
        result.append({
            "id": str(r["_id"]),
            "doctor": r["doctor"],
            "diagnosis": r["diagnosis"],
            "prescription": r["prescription"],
            "created_at": r.get("created_at")
        })

    return {
        "count": len(result),
        "records": result
    }