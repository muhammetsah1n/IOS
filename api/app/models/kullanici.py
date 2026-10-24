from datetime import datetime

from sqlalchemy import CheckConstraint, DateTime, String
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Kullanici(Base):
    __tablename__ = "kullanicilar"
    __table_args__ = (CheckConstraint("rol IN ('admin', 'kullanici')", name="ck_kullanicilar_rol"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    ad: Mapped[str] = mapped_column(String(100))
    kullanici_adi: Mapped[str | None] = mapped_column(String(50), unique=True)
    e_posta: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    sifre_hash: Mapped[str] = mapped_column(String(255))
    rol: Mapped[str] = mapped_column(String(20), default="kullanici", server_default="kullanici")
    profil_foto: Mapped[str | None] = mapped_column(String(255))
    kapak_foto: Mapped[str | None] = mapped_column(String(255))
    sifirlama_kodu: Mapped[str | None] = mapped_column(String(100))
    kod_son_gecerlilik: Mapped[datetime | None] = mapped_column(DateTime)
