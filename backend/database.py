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
db = client[settings.DATABASE_NAME] if client is not None else None

# ----------------------------
# COLLECTIONS (FIXED)
# ----------------------------
users_collection = db["users"] if db is not None else None
patients_collection = db["patients"] if db is not None else None
doctors_collection = db["doctors"] if db is not None else None
records_collection = db["records"] if db is not None else None

# ----------------------------
# INDEX CREATION (PERFORMANCE + UNIQUE RULES)
# ----------------------------
def create_indexes():
    if db is None:
        return

    try:
        # USERS (unique username)
        if users_collection is not None:
            users_collection.create_index(
                [("username", ASCENDING)],
                unique=True
            )

        # PATIENTS (fast search by phone)
        if patients_collection is not None:
            patients_collection.create_index(
                [("phone", ASCENDING)]
            )

        # RECORDS (fast fetch by patient & doctor)
        if records_collection is not None:
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