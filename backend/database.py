from pymongo import MongoClient
from config import settings

# MongoDB Client
client = MongoClient(settings.MONGO_URL)

# Database
db = client[settings.DATABASE_NAME]

# Collections
users_collection = db["users"]
records_collection = db["records"]