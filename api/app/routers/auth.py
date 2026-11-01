from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.guvenlik import mevcut_kullanici, sifre_dogrula, sifre_hashle, token_olustur
from app.models import Kullanici
from app.schemas.kullanici import GirisIstegi, KayitIstegi, KullaniciYaniti, TokenYaniti

router = APIRouter(prefix="/auth", tags=["Kimlik doğrulama"])


@router.post("/kayit", response_model=TokenYaniti, status_code=status.HTTP_201_CREATED)
def kayit_ol(istek: KayitIstegi, db: Session = Depends(get_db)):
    mevcut = db.scalar(select(Kullanici).where(Kullanici.e_posta == istek.e_posta))
    if mevcut is not None:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Bu e-posta adresiyle zaten bir hesap var.")

    # Kayıt olan herkes "kullanici" rolüyle başlar; yönetici rolü sonradan verilir
    kullanici = Kullanici(ad=istek.ad, e_posta=istek.e_posta, sifre_hash=sifre_hashle(istek.sifre), rol="kullanici")
    db.add(kullanici)
    db.commit()
    db.refresh(kullanici)

    # Kayıttan sonra tekrar giriş yapmaya gerek kalmasın diye token da döndürülür
    return TokenYaniti(access_token=token_olustur(kullanici), kullanici=kullanici)


@router.post("/giris", response_model=TokenYaniti)
def giris_yap(istek: GirisIstegi, db: Session = Depends(get_db)):
    kullanici = db.scalar(select(Kullanici).where(Kullanici.e_posta == istek.e_posta))

    # E-postanın mı şifrenin mi yanlış olduğu bilerek söylenmez
    if kullanici is None or not sifre_dogrula(istek.sifre, kullanici.sifre_hash):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="E-posta veya şifre hatalı.")

    return TokenYaniti(access_token=token_olustur(kullanici), kullanici=kullanici)


@router.get("/ben", response_model=KullaniciYaniti)
def ben(kullanici: Kullanici = Depends(mevcut_kullanici)):
    # Token'ın sahibi olan kullanıcının bilgileri ("Beni hatırla" kontrolünde kullanılır)
    return kullanici
