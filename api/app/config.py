import os

from dotenv import load_dotenv

# api/.env dosyasındaki değerleri ortam değişkenlerine yükler
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL tanımlı değil. api/.env dosyasını oluşturun (.env.example'a bakın).")
