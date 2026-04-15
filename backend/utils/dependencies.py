from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer
from jose import jwt, JWTError
from config import settings
from time import time

security = HTTPBearer()

# ----------------------------
# VERIFY TOKEN
# ----------------------------
def verify_token(token=Depends(security)):
    try:
        payload = jwt.decode(token.credentials, settings.SECRET_KEY, algorithms=["HS256"])
        return payload
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

# ----------------------------
# ROLE CHECK
# ----------------------------
def role_required(roles: list):
    def wrapper(account=Depends(verify_token)):
        if account.get("role") not in roles:
            raise HTTPException(status_code=403, detail="Access denied")
        return account
    return wrapper

# ----------------------------
# RATE LIMITER
# ----------------------------
request_logs = {}
RATE_LIMIT = 10
TIME_WINDOW = 60

def rate_limiter(account=Depends(verify_token)):
    now = time()
    user = account["sub"]

    timestamps = request_logs.get(user, [])
    timestamps = [t for t in timestamps if now - t < TIME_WINDOW]

    if len(timestamps) >= RATE_LIMIT:
        raise HTTPException(status_code=429, detail="Too many requests")

    timestamps.append(now)
    request_logs[user] = timestamps

    return account