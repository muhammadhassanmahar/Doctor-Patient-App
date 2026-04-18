from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

# ----------------------------
# CREATE RECORD (DOCTOR ONLY)
# ----------------------------
class RecordCreate(BaseModel):
    patient: str = Field(..., min_length=3, description="Patient username or ID")
    diagnosis: str = Field(..., min_length=3)
    prescription: str = Field(..., min_length=3)
    notes: Optional[str] = Field(default="", max_length=500)

# ----------------------------
# UPDATE RECORD
# ----------------------------
class RecordUpdate(BaseModel):
    diagnosis: Optional[str] = None
    prescription: Optional[str] = None
    notes: Optional[str] = None

# ----------------------------
# RECORD RESPONSE (API OUTPUT)
# ----------------------------
class RecordResponse(BaseModel):
    id: Optional[str]
    patient: str
    doctor: str
    diagnosis: str
    prescription: str
    notes: Optional[str] = ""
    created_at: Optional[datetime]
    updated_at: Optional[datetime]