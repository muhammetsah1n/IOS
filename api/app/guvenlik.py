from datetime import datetime, timedelta, timezone

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.config import JWT_ALGORITMA, JWT_GIZLI_ANAHTAR, JWT_SURE_DAKIKA
from app.database import get_db
from app.models import Kullanici

sifre_baglami = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Swagger'daki "Authorize" butonuna token yapıştırılarak istek atılabilir
bearer = HTTPBearer(auto_error=False)


def sifre_hashle(sifre: str) -> str:
    return sifre_baglami.hash(sifre)


def sifre_dogrula(sifre: str, sifre_hash: str) -> bool:
    return sifre_baglami.verify(sifre, sifre_hash)


def token_olustur(kullanici: Kullanici) -> str:
    bitis = datetime.now(timezone.utc) + timedelta(minutes=JWT_SURE_DAKIKA)
    icerik = {"sub": str(kullanici.id), "rol": kullanici.rol, "exp": bitis}
    return jwt.encode(icerik, JWT_GIZLI_ANAHTAR, algorithm=JWT_ALGORITMA)


def mevcut_kullanici(
    kimlik: HTTPAuthorizationCredentials | None = Depends(bearer),
    db: Session = Depends(get_db),
) -> Kullanici:
    # İstekteki "Authorization: Bearer <token>" başlığından kullanıcıyı bulur
    hata = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Oturum geçersiz. Lütfen tekrar giriş yapın.",
        headers={"WWW-Authenticate": "Bearer"},
    )
    if kimlik is None:
        raise hata

    try:
        icerik = jwt.decode(kimlik.credentials, JWT_GIZLI_ANAHTAR, algorithms=[JWT_ALGORITMA])
        kullanici_id = int(icerik["sub"])
    except (JWTError, KeyError, ValueError):
        raise hata

    kullanici = db.get(Kullanici, kullanici_id)
    if kullanici is None:
        raise hata
    return kullanici


def yonetici_gerekli(kullanici: Kullanici = Depends(mevcut_kullanici)) -> Kullanici:
    # Yalnızca yönetici (admin) rolündeki kullanıcıların erişebileceği uç noktalar için
    if kullanici.rol != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Bu işlem için yönetici yetkisi gerekir.")
    return kullanici
