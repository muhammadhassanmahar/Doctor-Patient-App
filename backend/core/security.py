from jose import jwt
from datetime import datetime, timedelta

SECRET_KEY = "mysecretkey"

def create_token(data: dict):
    payload = data.copy()
    payload["exp"] = datetime.utcnow() + timedelta(minutes=30)
    return jwt.encode(payload, SECRET_KEY, algorithm="HS256")