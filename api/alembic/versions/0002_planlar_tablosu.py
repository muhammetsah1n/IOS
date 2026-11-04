"""planlar tablosu

Revision ID: 0002
Revises: 0001
Create Date: 2026-11-03

"""
from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "0002"
down_revision: Union[str, None] = "0001"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "planlar",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("kullanici_id", sa.Integer(), nullable=False),
        sa.Column("tarih", sa.Date(), nullable=False),
        sa.Column("baslangic_saati", sa.Time(), nullable=False),
        sa.Column("bitis_saati", sa.Time(), nullable=False),
        sa.Column("baslik", sa.String(length=200), nullable=False),
        sa.Column("aciklama", sa.String(length=500), nullable=True),
        sa.Column("renk", sa.String(length=7), server_default="#CFE3B4", nullable=False),
        sa.Column("tamamlandi", sa.Boolean(), server_default="false", nullable=False),
        sa.PrimaryKeyConstraint("id"),
        sa.ForeignKeyConstraint(["kullanici_id"], ["kullanicilar.id"], ondelete="CASCADE"),
        sa.CheckConstraint("bitis_saati > baslangic_saati", name="ck_planlar_saat_sirasi"),
    )
    op.create_index("ix_planlar_kullanici_id", "planlar", ["kullanici_id"])
    op.create_index("ix_planlar_tarih", "planlar", ["tarih"])


def downgrade() -> None:
    op.drop_index("ix_planlar_tarih", table_name="planlar")
    op.drop_index("ix_planlar_kullanici_id", table_name="planlar")
    op.drop_table("planlar")
