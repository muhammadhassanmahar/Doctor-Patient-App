from bson import ObjectId

# ----------------------------
# SINGLE RECORD MODEL
# ----------------------------
def record_model(record) -> dict:
    return {
        "id": str(record["_id"]),
        "doctor": record.get("doctor"),
        "patient": record.get("patient"),
        "diagnosis": record.get("diagnosis"),
        "prescription": record.get("prescription"),
        "notes": record.get("notes", ""),
        "created_at": record.get("created_at"),
        "updated_at": record.get("updated_at")
    }

# ----------------------------
# MULTIPLE RECORDS MODEL
# ----------------------------
def records_model(records) -> list:
    return [record_model(record) for record in records]