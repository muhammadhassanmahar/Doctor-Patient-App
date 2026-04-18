from jose import jwt, JWTError
from datetime import datetime, timedelta
from config import settings

# ----------------------------
# CREATE ACCESS TOKEN
# ----------------------------
def create_token(data: dict):
    to_encode = data.copy()

    expire = datetime.utcnow() + timedelta(
        minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
    )

    to_encode.update({
        "exp": expire,
        "iat": datetime.utcnow(),  # issued at (extra security)
        "type": "access"
    })

    return jwt.encode(
        to_encode,
        settings.SECRET_KEY,
        algorithm="HS256"
    )


# ----------------------------
# DECODE TOKEN (OPTIONAL BUT USEFUL)
# ----------------------------
def decode_token(token: str):
    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=["HS256"]
        )
        return payload

    except JWTError:
        return None