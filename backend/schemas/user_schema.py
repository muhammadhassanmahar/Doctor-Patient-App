from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

# ----------------------------
# REGISTER SCHEMA
# ----------------------------
class RegisterModel(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    password: str = Field(..., min_length=5)
    role: str = Field(..., pattern="^(doctor|patient)$")


# ----------------------------
# LOGIN SCHEMA
# ----------------------------
class LoginModel(BaseModel):
    username: str
    password: str


# ----------------------------
# USER RESPONSE SCHEMA
# ----------------------------
class UserResponse(BaseModel):
    id: Optional[str]
    username: str
    role: str
    created_at: Optional[datetime]


# ----------------------------
# TOKEN RESPONSE SCHEMA
# ----------------------------
class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    role: str