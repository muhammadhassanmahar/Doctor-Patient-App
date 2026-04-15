from bson import ObjectId

# ----------------------------
# RECORD MODEL
# ----------------------------
def record_model(record) -> dict:
    return {
        "id": str(record["_id"]),
        "patient": record["patient"],
        "doctor": record["doctor"],
        "diagnosis": record["diagnosis"],
        "prescription": record["prescription"],
        "created_at": record.get("created_at")
    }

# ----------------------------
# HELPER (LIST OF RECORDS)
# ----------------------------
def records_model(records) -> list:
    return [record_model(record) for record in records]