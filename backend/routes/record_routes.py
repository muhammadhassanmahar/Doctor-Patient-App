from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime
from database import records_collection
from schemas.record_schema import RecordCreate, RecordUpdate
from utils.dependencies import verify_token, role_required
from models.record_model import record_model, records_model

router = APIRouter()

# ----------------------------
# CREATE RECORD (DOCTOR ONLY)
# ----------------------------
@router.post("/records")
def create_record(data: RecordCreate, account=Depends(role_required(["doctor"]))):

    record = {
        "patient": data.patient,
        "doctor": account["sub"],
        "diagnosis": data.diagnosis,
        "prescription": data.prescription,
        "created_at": datetime.utcnow()
    }

    result = records_collection.insert_one(record)
    new_record = records_collection.find_one({"_id": result.inserted_id})

    return record_model(new_record)

# ----------------------------
# GET RECORDS
# ----------------------------
@router.get("/records")
def get_records(account=Depends(verify_token)):

    if account["role"] == "doctor":
        records = records_collection.find({"doctor": account["sub"]})
    else:
        records = records_collection.find({"patient": account["sub"]})

    return records_model(records)

# ----------------------------
# UPDATE RECORD (DOCTOR ONLY)
# ----------------------------
@router.put("/records/{record_id}")
def update_record(record_id: str, data: RecordUpdate, account=Depends(role_required(["doctor"]))):

    record = records_collection.find_one({"_id": record_id})

    if not record:
        raise HTTPException(status_code=404, detail="Record not found")

    update_data = {k: v for k, v in data.dict().items() if v is not None}

    records_collection.update_one(
        {"_id": record_id},
        {"$set": update_data}
    )

    updated_record = records_collection.find_one({"_id": record_id})

    return record_model(updated_record)