from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime
from bson import ObjectId

from database import records_collection
from schemas.record_schema import RecordCreate, RecordUpdate
from utils.dependencies import verify_token, role_required
from models.record_model import record_model, records_model

router = APIRouter()

# ====================================================
# CREATE RECORD (DOCTOR ONLY)
# ====================================================
@router.post("/records")
def create_record(
    data: RecordCreate,
    account=Depends(role_required(["doctor"]))
):

    record = {
        "patient": data.patient,
        "doctor": account["sub"],
        "diagnosis": data.diagnosis,
        "prescription": data.prescription,
        "notes": data.notes if hasattr(data, "notes") else "",
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow()
    }

    result = records_collection.insert_one(record)

    new_record = records_collection.find_one({"_id": result.inserted_id})

    return {
        "message": "Record created successfully",
        "record": record_model(new_record)
    }


# ====================================================
# GET RECORDS (DOCTOR / PATIENT)
# ====================================================
@router.get("/records")
def get_records(account=Depends(verify_token)):

    # Doctor → apne patients ke records
    if account["role"] == "doctor":
        records = records_collection.find({"doctor": account["sub"]})

    # Patient → sirf apne records
    else:
        records = records_collection.find({"patient": account["sub"]})

    return {
        "count": records_collection.count_documents(
            {"doctor": account["sub"]} if account["role"] == "doctor"
            else {"patient": account["sub"]}
        ),
        "records": records_model(records)
    }


# ====================================================
# UPDATE RECORD (DOCTOR ONLY)
# ====================================================
@router.put("/records/{record_id}")
def update_record(
    record_id: str,
    data: RecordUpdate,
    account=Depends(role_required(["doctor"]))
):

    try:
        obj_id = ObjectId(record_id)
    except:
        raise HTTPException(status_code=400, detail="Invalid record ID")

    record = records_collection.find_one({"_id": obj_id})

    if not record:
        raise HTTPException(status_code=404, detail="Record not found")

    # doctor ownership check
    if record["doctor"] != account["sub"]:
        raise HTTPException(status_code=403, detail="Not allowed")

    update_data = {
        k: v for k, v in data.dict().items()
        if v is not None
    }

    if update_data:
        update_data["updated_at"] = datetime.utcnow()

        records_collection.update_one(
            {"_id": obj_id},
            {"$set": update_data}
        )

    updated_record = records_collection.find_one({"_id": obj_id})

    return {
        "message": "Record updated successfully",
        "record": record_model(updated_record)
    }


# ====================================================
# DELETE RECORD (DOCTOR ONLY)
# ====================================================
@router.delete("/records/{record_id}")
def delete_record(
    record_id: str,
    account=Depends(role_required(["doctor"]))
):

    try:
        obj_id = ObjectId(record_id)
    except:
        raise HTTPException(status_code=400, detail="Invalid record ID")

    record = records_collection.find_one({"_id": obj_id})

    if not record:
        raise HTTPException(status_code=404, detail="Record not found")

    # doctor ownership check
    if record["doctor"] != account["sub"]:
        raise HTTPException(status_code=403, detail="Not allowed")

    records_collection.delete_one({"_id": obj_id})

    return {
        "message": "Record deleted successfully"
    }