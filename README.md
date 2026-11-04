# Quick-TicK

Günlük planları, yapılacakları ve alışkanlıkları tek yerde toplayan dijital ajanda uygulaması.
BLM4587 IOS İle Mobil Uygulama Geliştirme I (Flutter) dönem projesi, 2026–2027 Güz.

> Bu README taslaktır; 9. haftada tamamlanacaktır.

## Depo yapısı

| Klasör | İçerik |
|---|---|
| `api/` | Web API — Python, FastAPI, SQLAlchemy, Alembic, PostgreSQL |
| `mobile/` | Mobil uygulama — Flutter (Android) |

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
JWT_GIZLI_ANAHTAR=uzun_rastgele_bir_anahtar
JWT_SURE_DAKIKA=10080
```

JWT anahtarı üretmek için: `python -c "import secrets; print(secrets.token_hex(32))"`

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

### Uç noktalar

| Yöntem | Adres | Açıklama |
|---|---|---|
| POST | `/auth/kayit` | Kayıt olur (`ad`, `e_posta`, `sifre` en az 8 karakter); token ve kullanıcıyı döndürür |
| POST | `/auth/giris` | Giriş yapar (`e_posta`, `sifre`); token ve kullanıcıyı döndürür |
| GET | `/auth/ben` | Token sahibinin bilgileri (`Authorization: Bearer <token>`) |
| GET | `/plans` | Kullanıcının planları; `?tarih=2026-11-03` ile yalnızca o gün |
| GET | `/plans/{id}` | Tek plan |
| POST | `/plans` | Plan ekler (`tarih`, `baslangic_saati`, `bitis_saati`, `baslik`, `aciklama`, `renk`, `tamamlandi`) |
| PUT | `/plans/{id}` | Planı günceller (tüm alanlar gönderilir; "Bitti" işareti de bununla) |
| DELETE | `/plans/{id}` | Planı siler |

`/plans` uç noktaları giriş yapmış kullanıcı ister; herkes yalnızca kendi planlarını görür
(başkasının planına istek atılırsa 404 döner). Bitiş saati başlangıçtan sonra olmalı,
`renk` tasarımdaki dört renkten biri olmalıdır: `#B9CCF5`, `#FFD08A`, `#CFE3B4`, `#F6B79A`.

Swagger'da korumalı uç noktaları denemek için girişte dönen `access_token` değerini
sağ üstteki **Authorize** butonuna yapıştırın.

**Roller:** Kayıt olan herkes `kullanici` rolüyle başlar. Bir hesabı yönetici yapmak için:

```bash
psql -U postgres -d quicktick -c "UPDATE kullanicilar SET rol = 'admin' WHERE e_posta = 'ornek@eposta.com';"
```

## Mobil uygulama (`mobile/`)

```bash
cd mobile
flutter pub get
flutter run
```

### API adresi

Uygulama varsayılan olarak `http://10.0.2.2:8000` adresini kullanır; Android emülatörü bu adresle
bilgisayardaki API'ye ulaşır. Gerçek cihazda bilgisayarın yerel IP adresi verilir
(telefon ve bilgisayar aynı ağda olmalı, API `--host 0.0.0.0` ile çalışmalı):

```bash
flutter run --dart-define=API_ADRESI=http://192.168.1.20:8000
```

## Veritabanı tabloları

| Tablo | Durum |
|---|---|
| `kullanicilar` | ✅ 1. hafta |
| `planlar` | ✅ 3. hafta |
| `gorev_gruplari`, `gorevler` | 5. hafta |
| `listeler`, `liste_ogeleri` | 6. hafta |
| `aliskanliklar`, `aliskanlik_kayitlari` | 8. hafta |

## Haftalık ilerleme

- **1. hafta:** Depo ve klasör yapısı, README taslağı; Flutter projesi, renkler ve yazı tipleri;
  Giriş ve Kayıt ol ekranları (form doğrulama); FastAPI iskeleti ve `.env` ile bağlantı ayarı;
  SQLAlchemy + Alembic kurulumu, `kullanicilar` tablosu ve ilk migration.
- **2. hafta:** Kayıt ve giriş uç noktaları (bcrypt ile şifre özeti, JWT, roller); Giriş ve Kayıt ol
  ekranlarının API'ye bağlanması, "Beni hatırla" ile token'ın saklanması; alt menü
  (Bugün, Takvim, +, Alışkanlıklar, Profil) ve ekranlar arası gezinme, Profil'den çıkış.
- **3. hafta:** `planlar` tablosu ve migration; Plan için tam CRUD uç noktaları (Pydantic doğrulama,
  kullanıcıya göre yetki); Ana sayfa: selamlama, gün kartı, API'den gelen "Gün planı" listesi,
  aşağı çekerek yenileme ve planı "Bitti" olarak işaretleme.
