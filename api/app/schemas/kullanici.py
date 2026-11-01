from pydantic import BaseModel, ConfigDict, EmailStr, Field, field_validator


class KayitIstegi(BaseModel):
    ad: str = Field(min_length=1, max_length=100)
    e_posta: EmailStr
    # bcrypt en fazla 72 baytlık şifreyi işleyebilir
    sifre: str = Field(min_length=8, max_length=72)

    @field_validator("ad")
    @classmethod
    def ad_bos_olamaz(cls, deger: str) -> str:
        deger = deger.strip()
        if not deger:
            raise ValueError("Ad boş olamaz.")
        return deger

    @field_validator("e_posta")
    @classmethod
    def e_posta_kucuk_harf(cls, deger: str) -> str:
        return deger.lower()


class GirisIstegi(BaseModel):
    e_posta: EmailStr
    sifre: str = Field(min_length=1, max_length=72)

    @field_validator("e_posta")
    @classmethod
    def e_posta_kucuk_harf(cls, deger: str) -> str:
        return deger.lower()


class KullaniciYaniti(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    ad: str
    kullanici_adi: str | None
    e_posta: str
    rol: str


class TokenYaniti(BaseModel):
    access_token: str
    token_type: str = "bearer"
    kullanici: KullaniciYaniti
