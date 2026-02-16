import os
import uuid
import bcrypt
from fastapi import Depends, HTTPException,APIRouter, routing, Header
import jwt
from database import get_db
from middlewares import auth_middleware 
from pydantic_schemas.user_create import UserCreate
from models.user import User
from sqlalchemy.orm import Session
from pydantic_schemas.user_login import UserLogin
from pydantic_schemas.user_login import settings
from sqlalchemy.orm import joinedload


router = routing.APIRouter()
@router.post('/signup', status_code=201)
def signup_User(user: UserCreate, db: Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(status_code=400, detail='User with the same email already exists!')
    
    hashed_pw = bcrypt.hashpw(user.password.encode('utf-8'), bcrypt.gensalt())

    user_db = User(id = str(uuid.uuid4()), email = user.email, password= hashed_pw, name = user.name)

    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db

@router.post('/login', status_code=200)
def login_User(user: UserLogin, db: Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db:
        raise HTTPException(status_code=400, detail='User with this email does not exist!')
    
    is_match = bcrypt.checkpw(user.password.encode('utf-8'), user_db.password)
    if not is_match:
        raise HTTPException(status_code=400, detail='Incorrect password!')
    
    token = jwt.encode({'id': user_db.id}, settings.JWT_TOKEN_SECRET, )

    return {"token": token, "user": user_db}

@router.get('/')
def currentUserData(db: Session = Depends(get_db), user_dict = Depends(auth_middleware.auth_middleware)):
    user_db = db.query(User).filter(User.id == user_dict['uid']).options(joinedload(User.favorites)).first()
    if not user_db:
        raise HTTPException(status_code=404, detail='User not found!')
    return user_db
    
    
    