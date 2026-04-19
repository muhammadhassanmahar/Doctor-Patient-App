from bson import ObjectId
from datetime import datetime

# ----------------------------
# SINGLE RECORD MODEL
# ----------------------------
def record_model(record) -> dict:
    if not record:
        return {}

    return {
        "id": str(record.get("_id")) if record.get("_id") else None,

        "doctor": record.get("doctor", ""),
        "patient": record.get("patient", ""),

        "diagnosis": record.get("diagnosis", ""),
        "prescription": record.get("prescription", ""),
        "notes": record.get("notes", ""),

        "created_at": format_date(record.get("created_at")),
        "updated_at": format_date(record.get("updated_at")),
    }


# ----------------------------
# MULTIPLE RECORDS MODEL
# ----------------------------
def records_model(records) -> list:
    return [record_model(record) for record in records]


# ----------------------------
# DATE FORMAT HELPER
# ----------------------------
def format_date(date):
    if isinstance(date, datetime):
        return date.isoformat()
    return None