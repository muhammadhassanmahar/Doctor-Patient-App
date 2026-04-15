from pydantic import BaseModel, Field
from typing import Optional

# ----------------------------
# REGISTER SCHEMA
# ----------------------------
class RegisterRequest(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    password: str = Field(..., min_length=5)
    role: str

# ----------------------------
# LOGIN SCHEMA
# ----------------------------
class LoginRequest(BaseModel):
    username: str
    password: str

# ----------------------------
# USER RESPONSE SCHEMA
# ----------------------------
class UserResponse(BaseModel):
    id: Optional[str]
    username: str
    role: str

# ----------------------------
# TOKEN RESPONSE SCHEMA
# ----------------------------
class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    role: str