from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError
from config import settings
from time import time

security = HTTPBearer()

# ----------------------------
# VERIFY JWT TOKEN
# ----------------------------
def verify_token(token: HTTPAuthorizationCredentials = Depends(security)):
    try:
        payload = jwt.decode(
            token.credentials,
            settings.SECRET_KEY,
            algorithms=["HS256"]
        )
        return payload

    except JWTError:
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired token"
        )


# ----------------------------
# ROLE BASED ACCESS CONTROL
# ----------------------------
def role_required(roles: list):
    def wrapper(account=Depends(verify_token)):
        if account.get("role") not in roles:
            raise HTTPException(
                status_code=403,
                detail="Access denied: insufficient permissions"
            )
        return account
    return wrapper


# ----------------------------
# RATE LIMITER (PER USER)
# ----------------------------
request_logs = {}
RATE_LIMIT = 10
TIME_WINDOW = 60  # seconds

def rate_limiter(account=Depends(verify_token)):
    now = time()
    user = account.get("sub")

    if not user:
        raise HTTPException(
            status_code=401,
            detail="Invalid user token"
        )

    timestamps = request_logs.get(user, [])

    # keep only recent requests
    timestamps = [t for t in timestamps if now - t < TIME_WINDOW]

    if len(timestamps) >= RATE_LIMIT:
        raise HTTPException(
            status_code=429,
            detail="Too many requests. Try again later."
        )

    timestamps.append(now)
    request_logs[user] = timestamps

    return account