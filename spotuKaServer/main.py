from fastapi import FastAPI, Depends
from database import engine
from models.base import Base
from route import auth, song
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


Base.metadata.create_all(engine)

app.include_router(auth.router, prefix='/auth')
app.include_router(song.router, prefix='/song')
