from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

# ----------------------------
# CREATE RECORD
# ----------------------------
class RecordCreate(BaseModel):
    patient: str = Field(..., min_length=3)
    diagnosis: str = Field(..., min_length=3)
    prescription: str = Field(..., min_length=3)

# ----------------------------
# UPDATE RECORD
# ----------------------------
class RecordUpdate(BaseModel):
    diagnosis: Optional[str]
    prescription: Optional[str]

# ----------------------------
# RECORD RESPONSE
# ----------------------------
class RecordResponse(BaseModel):
    id: Optional[str]
    patient: str
    doctor: str
    diagnosis: str
    prescription: str
    created_at: Optional[datetime]