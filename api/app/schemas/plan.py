from datetime import date, time
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

# Tasarımdaki plan kartı renkleri: mavi, sarı, yeşil, somon
PlanRengi = Literal["#B9CCF5", "#FFD08A", "#CFE3B4", "#F6B79A"]


class PlanIstegi(BaseModel):
    # Hem ekleme (POST) hem güncelleme (PUT) için aynı alanlar gönderilir
    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "tarih": "2026-11-03",
                "baslangic_saati": "09:00",
                "bitis_saati": "10:30",
                "baslik": "Matematik çalış",
                "aciklama": "Türev konusu",
                "renk": "#B9CCF5",
                "tamamlandi": False,
            }
        }
    )

    tarih: date
    baslangic_saati: time
    bitis_saati: time
    baslik: str = Field(min_length=1, max_length=200)
    aciklama: str | None = Field(default=None, max_length=500)
    renk: PlanRengi = "#CFE3B4"
    tamamlandi: bool = False

    @field_validator("baslik")
    @classmethod
    def baslik_bos_olamaz(cls, deger: str) -> str:
        deger = deger.strip()
        if not deger:
            raise ValueError("Plan adı boş olamaz.")
        return deger

    @field_validator("aciklama")
    @classmethod
    def bos_aciklama_none(cls, deger: str | None) -> str | None:
        if deger is None:
            return None
        deger = deger.strip()
        return deger or None

    @field_validator("baslangic_saati", "bitis_saati")
    @classmethod
    def saniyesiz(cls, deger: time) -> time:
        # Planlar dakika hassasiyetinde tutulur
        return deger.replace(second=0, microsecond=0, tzinfo=None)

    @model_validator(mode="after")
    def saat_sirasi(self):
        if self.bitis_saati <= self.baslangic_saati:
            raise ValueError("Bitiş saati başlangıç saatinden sonra olmalı.")
        return self


class PlanYaniti(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    tarih: date
    baslangic_saati: time
    bitis_saati: time
    baslik: str
    aciklama: str | None
    renk: str
    tamamlandi: bool
