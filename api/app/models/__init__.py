# Alembic'in tabloları görebilmesi için tüm modeller burada içe aktarılır
from app.models.kullanici import Kullanici
from app.models.plan import Plan

__all__ = ["Kullanici", "Plan"]
