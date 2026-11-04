from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.guvenlik import mevcut_kullanici
from app.models import Kullanici, Plan
from app.schemas.plan import PlanIstegi, PlanYaniti

# Tüm plan uç noktaları giriş yapmış kullanıcı ister; herkes yalnızca kendi planlarını görür
router = APIRouter(prefix="/plans", tags=["Planlar"])


def _plani_bul(plan_id: int, kullanici: Kullanici, db: Session) -> Plan:
    plan = db.get(Plan, plan_id)
    # Başkasının planı da "bulunamadı" sayılır; böylece başka kullanıcıların plan numaraları açığa çıkmaz
    if plan is None or plan.kullanici_id != kullanici.id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Plan bulunamadı.")
    return plan


@router.get("", response_model=list[PlanYaniti])
def planlari_listele(
    tarih: date | None = None,
    kullanici: Kullanici = Depends(mevcut_kullanici),
    db: Session = Depends(get_db),
):
    # ?tarih=2026-11-03 verilirse yalnızca o günün planları, verilmezse tüm planlar döner
    sorgu = select(Plan).where(Plan.kullanici_id == kullanici.id)
    if tarih is not None:
        sorgu = sorgu.where(Plan.tarih == tarih)
    sorgu = sorgu.order_by(Plan.tarih, Plan.baslangic_saati, Plan.id)
    return db.scalars(sorgu).all()


@router.get("/{plan_id}", response_model=PlanYaniti)
def plan_getir(plan_id: int, kullanici: Kullanici = Depends(mevcut_kullanici), db: Session = Depends(get_db)):
    return _plani_bul(plan_id, kullanici, db)


@router.post("", response_model=PlanYaniti, status_code=status.HTTP_201_CREATED)
def plan_ekle(istek: PlanIstegi, kullanici: Kullanici = Depends(mevcut_kullanici), db: Session = Depends(get_db)):
    plan = Plan(kullanici_id=kullanici.id, **istek.model_dump())
    db.add(plan)
    db.commit()
    db.refresh(plan)
    return plan


@router.put("/{plan_id}", response_model=PlanYaniti)
def plan_guncelle(
    plan_id: int,
    istek: PlanIstegi,
    kullanici: Kullanici = Depends(mevcut_kullanici),
    db: Session = Depends(get_db),
):
    plan = _plani_bul(plan_id, kullanici, db)
    for alan, deger in istek.model_dump().items():
        setattr(plan, alan, deger)
    db.commit()
    db.refresh(plan)
    return plan


@router.delete("/{plan_id}", status_code=status.HTTP_204_NO_CONTENT)
def plan_sil(plan_id: int, kullanici: Kullanici = Depends(mevcut_kullanici), db: Session = Depends(get_db)):
    plan = _plani_bul(plan_id, kullanici, db)
    db.delete(plan)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
