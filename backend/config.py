from pydantic import BaseSettings

class Settings(BaseSettings):
    MONGO_URL: str = "mongodb://localhost:27017"
    DATABASE_NAME: str = "doctor_app"
    SECRET_KEY: str = "mysecretkey"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

settings = Settings()