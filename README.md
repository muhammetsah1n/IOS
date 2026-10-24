# Quick-TicK

Günlük planları, yapılacakları ve alışkanlıkları tek yerde toplayan dijital ajanda uygulaması.
BLM4587 IOS İle Mobil Uygulama Geliştirme I (Flutter) dönem projesi, 2026–2027 Güz.

> Bu README taslaktır; 9. haftada tamamlanacaktır.

## Depo yapısı

| Klasör | İçerik |
|---|---|
| `api/` | Web API — Python, FastAPI, SQLAlchemy, Alembic, PostgreSQL |
| `mobile/` | Mobil uygulama — Flutter (Android) |
| `design/` | Arayüz tasarımı ve tasarım rehberi (`design/TASARIM.md`) |

## Gereksinimler

- Python 3.12 veya üzeri
- PostgreSQL 16 veya üzeri
- Flutter 3.47 (Dart 3.13) — `flutter --version` ile kontrol edin
- Android emülatörü ya da gerçek Android cihaz

## Web API (`api/`)

### 1. Veritabanını oluşturma

> **Türkçe Windows'ta kurulum:** PostgreSQL kurulumu `locale name "Turkish_Türkiye.1254" contains non-ASCII characters`
> hatasıyla yarıda kalırsa kurulumda bölge (locale) olarak `tr-TR` seçin. Komut satırından:
> `winget install --id PostgreSQL.PostgreSQL.18 --override "--mode unattended --superpassword SIFRE --locale tr-TR"`

PostgreSQL kurulduktan sonra boş bir veritabanı açın:

```bash
psql -U postgres -c "CREATE DATABASE quicktick;"
```

### 2. Sanal ortam ve paketler

```bash
cd api
python -m venv .venv
# Windows:
.venv\Scripts\activate
# macOS / Linux:
source .venv/bin/activate

pip install -r requirements.txt
```

### 3. `.env` dosyası

`api/.env.example` dosyasını `api/.env` adıyla kopyalayın ve kendi veritabanı bilgilerinizi yazın:

```
DATABASE_URL=postgresql+psycopg2://postgres:SIFRENIZ@localhost:5432/quicktick
```

`.env` dosyası `.gitignore` içindedir; şifreler depoya gönderilmez.

### 4. Migration (tabloları oluşturma)

```bash
alembic upgrade head
```

Model değişikliğinden sonra yeni migration üretmek için:

```bash
alembic revision --autogenerate -m "aciklama"
alembic upgrade head
```

### 5. API'yi çalıştırma

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

- Swagger arayüzü: <http://localhost:8000/docs>
- Veritabanı bağlantı testi: <http://localhost:8000/saglik>

## Mobil uygulama (`mobile/`)

```bash
cd mobile
flutter pub get
flutter run
```

### API adresi

API bağlantısı 2. haftada eklenecek. Android emülatöründen bilgisayardaki API'ye
`http://10.0.2.2:8000` adresiyle ulaşılır; gerçek cihazda bilgisayarın yerel IP adresi kullanılır.

## Veritabanı tabloları

| Tablo | Durum |
|---|---|
| `kullanicilar` | ✅ 1. hafta |
| `planlar` | 3. hafta |
| `gorev_gruplari`, `gorevler` | 5. hafta |
| `listeler`, `liste_ogeleri` | 6. hafta |
| `aliskanliklar`, `aliskanlik_kayitlari` | 8. hafta |

## Haftalık ilerleme

- **1. hafta:** Depo ve klasör yapısı, README taslağı; Flutter projesi, renkler ve yazı tipleri;
  Giriş ve Kayıt ol ekranları (form doğrulama); FastAPI iskeleti ve `.env` ile bağlantı ayarı;
  SQLAlchemy + Alembic kurulumu, `kullanicilar` tablosu ve ilk migration.
