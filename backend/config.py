from pydantic_settings import BaseSettings
from pydantic import Field


class Settings(BaseSettings):
    # ----------------------------
    # DATABASE CONFIG
    # ----------------------------
    MONGO_URL: str = Field(
        default="mongodb://localhost:27017",
        description="MongoDB connection URL"
    )

    DATABASE_NAME: str = Field(
        default="doctor_app",
        description="Database name"
    )

    # ----------------------------
    # SECURITY CONFIG
    # ----------------------------
    SECRET_KEY: str = Field(
        default="mysecretkey",
        description="JWT Secret Key"
    )

    ACCESS_TOKEN_EXPIRE_MINUTES: int = Field(
        default=60,
        description="Token expiry time (minutes)"
    )

    # ----------------------------
    # ENV FILE SUPPORT
    # ----------------------------
    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


# Instance (global use ke liye)
settings = Settings()