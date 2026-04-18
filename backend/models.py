from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


# ----------------------------
# USER MODEL (Doctor / Patient)
# ----------------------------
class UserModel(BaseModel):
    username: str
    password: str
    role: str = Field(..., description="doctor or patient")
    created_at: datetime = Field(default_factory=datetime.utcnow)


# ----------------------------
# DOCTOR PROFILE
# ----------------------------
class DoctorModel(BaseModel):
    user_id: str
    name: str
    specialization: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    patients: List[str] = []  # patient IDs


# ----------------------------
# PATIENT PROFILE
# ----------------------------
class PatientModel(BaseModel):
    user_id: str
    name: str
    age: Optional[int] = None
    gender: Optional[str] = None
    phone: Optional[str] = None

    doctor_id: Optional[str] = None  # assigned doctor

    disease: Optional[str] = None
    status: str = "active"

    created_at: datetime = Field(default_factory=datetime.utcnow)


# ----------------------------
# MEDICAL RECORD MODEL
# ----------------------------
class MedicalRecordModel(BaseModel):
    patient_id: str
    doctor_id: str

    diagnosis: str
    symptoms: Optional[str] = None
    medicines: List[str] = []

    notes: Optional[str] = None

    created_at: datetime = Field(default_factory=datetime.utcnow)


# ----------------------------
# LOGIN MODEL
# ----------------------------
class LoginModel(BaseModel):
    username: str
    password: str


# ----------------------------
# REGISTER MODEL
# ----------------------------
class RegisterModel(BaseModel):
    username: str
    password: str
    role: str