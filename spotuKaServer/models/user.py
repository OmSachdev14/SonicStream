from sqlalchemy import LargeBinary, Column, String, TEXT, VARCHAR
from models.base import Base

class User(Base):
    __tablename__ = 'users'

    id = Column(TEXT,primary_key=True)
    name = Column(VARCHAR(100))
    email = Column(String)
    password = Column(LargeBinary)
