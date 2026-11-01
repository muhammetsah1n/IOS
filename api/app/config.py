import os

from dotenv import load_dotenv

# api/.env dosyasındaki değerleri ortam değişkenlerine yükler
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
JWT_GIZLI_ANAHTAR = os.getenv("JWT_GIZLI_ANAHTAR")
JWT_SURE_DAKIKA = int(os.getenv("JWT_SURE_DAKIKA", "10080"))
JWT_ALGORITMA = "HS256"

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL tanımlı değil. api/.env dosyasını oluşturun (.env.example'a bakın).")

if not JWT_GIZLI_ANAHTAR:
    raise RuntimeError("JWT_GIZLI_ANAHTAR tanımlı değil. api/.env dosyasına ekleyin (.env.example'a bakın).")
