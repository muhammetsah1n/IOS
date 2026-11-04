from datetime import date, time

from sqlalchemy import Boolean, CheckConstraint, Date, ForeignKey, String, Time
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Plan(Base):
    __tablename__ = "planlar"
    __table_args__ = (
        CheckConstraint("bitis_saati > baslangic_saati", name="ck_planlar_saat_sirasi"),
    )

    id: Mapped[int] = mapped_column(primary_key=True)
    # Kullanıcı silinirse planları da silinir
    kullanici_id: Mapped[int] = mapped_column(ForeignKey("kullanicilar.id", ondelete="CASCADE"), index=True)
    tarih: Mapped[date] = mapped_column(Date, index=True)
    baslangic_saati: Mapped[time] = mapped_column(Time)
    bitis_saati: Mapped[time] = mapped_column(Time)
    baslik: Mapped[str] = mapped_column(String(200))
    aciklama: Mapped[str | None] = mapped_column(String(500))
    # Kartın zemin rengi (tasarımdaki dört renkten biri)
    renk: Mapped[str] = mapped_column(String(7), default="#CFE3B4", server_default="#CFE3B4")
    tamamlandi: Mapped[bool] = mapped_column(Boolean, default=False, server_default="false")
