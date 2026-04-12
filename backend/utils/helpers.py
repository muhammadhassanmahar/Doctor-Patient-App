def success(msg, data=None):
    return {"success": True, "message": msg, "data": data}

def error(msg):
    return {"success": False, "message": msg}