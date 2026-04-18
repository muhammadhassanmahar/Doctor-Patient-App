from pymongo import MongoClient, ASCENDING
from config import settings

# ----------------------------
# MONGODB CONNECTION
# ----------------------------
try:
    client = MongoClient(
        settings.MONGO_URL,
        serverSelectionTimeoutMS=5000
    )

    # Test connection
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
users_collection = db["users"] if db else None
patients_collection = db["patients"] if db else None
doctors_collection = db["doctors"] if db else None
records_collection = db["records"] if db else None

# ----------------------------
# INDEX CREATION (PERFORMANCE + UNIQUE RULES)
# ----------------------------
def create_indexes():
    if not db:
        return

    try:
        # USERS (unique username)
        users_collection.create_index(
            [("username", ASCENDING)],
            unique=True
        )

        # PATIENTS (fast search by phone)
        patients_collection.create_index(
            [("phone", ASCENDING)]
        )

        # RECORDS (fast fetch by patient & doctor)
        records_collection.create_index(
            [("patient", ASCENDING)]
        )

        records_collection.create_index(
            [("doctor", ASCENDING)]
        )

        print("✅ MongoDB Indexes Created")

    except Exception as e:
        print("⚠️ Index creation failed:", e)


# ----------------------------
# AUTO RUN INDEXES
# ----------------------------
create_indexes()