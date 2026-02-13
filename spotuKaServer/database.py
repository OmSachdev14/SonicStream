from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL= 'postgresql://postgres:OmSachdev14@localhost:5432/spotufy'
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autoflush=False,autocommit=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()