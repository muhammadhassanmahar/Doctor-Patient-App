from pymongo import MongoClient
from config import settings

# ----------------------------
# MONGODB CONNECTION
# ----------------------------
try:
    client = MongoClient(settings.MONGO_URL)

    # Test connection (important)
    client.admin.command("ping")
    print("✅ MongoDB Connected Successfully")

except Exception as e:
    print("❌ MongoDB Connection Failed:", e)
    client = None

# ----------------------------
# DATABASE
# ----------------------------
db = client[settings.DATABASE_NAME] if client else None

# ----------------------------
# COLLECTIONS
# ----------------------------
users_collection = db["users"] if db is not None else None
patients_collection = db["patients"] if db is not None else None
doctors_collection = db["doctors"] if db is not None else None
records_collection = db["records"] if db is not None else None

# ----------------------------
# OPTIONAL: INDEXING (PERFORMANCE BOOST)
# ----------------------------
def create_indexes():
    if users_collection is not None:
        users_collection.create_index("username", unique=True)

    if patients_collection is not None:
        patients_collection.create_index("phone")

    if records_collection is not None:
        records_collection.create_index("patient_id")

# Auto-run indexes
try:
    create_indexes()
except Exception as e:
    print("⚠️ Index creation skipped:", e)