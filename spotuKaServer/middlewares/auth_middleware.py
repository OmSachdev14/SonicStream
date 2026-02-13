from fastapi import Header, HTTPException, status # Use FastAPI's HTTPException
from pydantic_schemas.user_login import settings
import jwt

def auth_middleware(x_auth_token: str = Header()):
    try:
        # 1. Check if header exists
        if not x_auth_token:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED, 
                detail='No Auth Token, access denied!'
            )
        
        # 2. Decode and verify
        # Note: jwt.decode raises PyJWTError if verification fails
        payload = jwt.decode(
            x_auth_token, 
            settings.JWT_TOKEN_SECRET, 
            algorithms=["HS256"]
        )
        
        uid = payload.get('id')
        if not uid:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED, 
                detail='Token invalid: User ID missing'
            )

        return {'uid': uid, 'token': x_auth_token}
    
    except jwt.PyJWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, 
            detail='Token is invalid, access denied!'
        )