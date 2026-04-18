from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


# ====================================================
# USER MODEL (Doctor / Patient LOGIN SYSTEM)
# ====================================================
class UserModel(BaseModel):
    username: str = Field(..., min_length=3)
    password: str = Field(..., min_length=6)
    role: str = Field(..., description="doctor or patient")

    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)


# ====================================================
# DOCTOR PROFILE
# ====================================================
class DoctorModel(BaseModel):
    user_id: str
    name: str
    specialization: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None

    # linked patients
    patients: List[str] = Field(default_factory=list)

    created_at: datetime = Field(default_factory=datetime.utcnow)


# ====================================================
# PATIENT PROFILE
# ====================================================
class PatientModel(BaseModel):
    user_id: str
    name: str

    age: Optional[int] = None
    gender: Optional[str] = None
    phone: Optional[str] = None

    # doctor relation
    doctor_id: Optional[str] = None

    disease: Optional[str] = None
    status: str = "active"

    created_at: datetime = Field(default_factory=datetime.utcnow)


# ====================================================
# MEDICAL RECORD MODEL (CORE FEATURE)
# ====================================================
class MedicalRecordModel(BaseModel):
    patient_id: str
    doctor_id: str

    diagnosis: str
    symptoms: Optional[str] = None

    medicines: List[str] = Field(default_factory=list)

    notes: Optional[str] = None

    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)


# ====================================================
# AUTH MODELS
# ====================================================
class LoginModel(BaseModel):
    username: str
    password: str


class RegisterModel(BaseModel):
    username: str = Field(..., min_length=3)
    password: str = Field(..., min_length=6)
    role: str = Field(..., description="doctor or patient")