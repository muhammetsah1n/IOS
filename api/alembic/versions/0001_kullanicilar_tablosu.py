"""kullanicilar tablosu

Revision ID: 0001
Revises:
Create Date: 2026-10-24

"""
from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "0001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "kullanicilar",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("ad", sa.String(length=100), nullable=False),
        sa.Column("kullanici_adi", sa.String(length=50), nullable=True),
        sa.Column("e_posta", sa.String(length=255), nullable=False),
        sa.Column("sifre_hash", sa.String(length=255), nullable=False),
        sa.Column("rol", sa.String(length=20), server_default="kullanici", nullable=False),
        sa.Column("profil_foto", sa.String(length=255), nullable=True),
        sa.Column("kapak_foto", sa.String(length=255), nullable=True),
        sa.Column("sifirlama_kodu", sa.String(length=100), nullable=True),
        sa.Column("kod_son_gecerlilik", sa.DateTime(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("kullanici_adi"),
        sa.CheckConstraint("rol IN ('admin', 'kullanici')", name="ck_kullanicilar_rol"),
    )
    op.create_index("ix_kullanicilar_e_posta", "kullanicilar", ["e_posta"], unique=True)


def downgrade() -> None:
    op.drop_index("ix_kullanicilar_e_posta", table_name="kullanicilar")
    op.drop_table("kullanicilar")
