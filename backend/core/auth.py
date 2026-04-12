from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer
from jose import jwt
from time import time

from app.db.database import accounts_db
from app.core.security import SECRET_KEY

security = HTTPBearer()

# VERIFY TOKEN
def verify_token(token=Depends(security)):
    try:
        return jwt.decode(token.credentials, SECRET_KEY, algorithms=["HS256"])
    except:
        raise HTTPException(status_code=401, detail="Invalid token")


# ROLE CHECK
def role_required(roles: list):
    def wrapper(user=Depends(verify_token)):
        if user.get("role") not in roles:
            raise HTTPException(status_code=403, detail="Access denied")
        return user
    return wrapper


# RATE LIMIT
request_logs = {}

def rate_limiter(user=Depends(verify_token)):
    now = time()
    logs = request_logs.get(user["sub"], [])

    logs = [t for t in logs if now - t < 60]

    if len(logs) >= 5:
        raise HTTPException(status_code=429, detail="Too many requests")

    logs.append(now)
    request_logs[user["sub"]] = logs

    return user