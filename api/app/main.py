from fastapi import Depends, FastAPI
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.database import get_db
from app.routers import auth, planlar

app = FastAPI(title="Quick-TicK API", version="0.3.0")

app.include_router(auth.router)
app.include_router(planlar.router)


@app.get("/")
def kok():
    return {"mesaj": "Quick-TicK API çalışıyor. Swagger için /docs adresine gidin."}


@app.get("/saglik")
def saglik(db: Session = Depends(get_db)):
    # Veritabanı bağlantısını test eder
    db.execute(text("SELECT 1"))
    return {"durum": "ok", "veritabani": "bağlı"}
