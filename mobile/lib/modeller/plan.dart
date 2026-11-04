import 'package:flutter/material.dart';

import '../tema/renkler.dart';
import '../yardimcilar/tarih.dart';

class Plan {
  final int id;
  final DateTime tarih;
  // "09:00" biçiminde; API saniyeli ("09:00:00") gönderir, ilk 5 karakter alınır
  final String baslangic;
  final String bitis;
  final String baslik;
  final String? aciklama;
  final String renk;
  final bool tamamlandi;

  const Plan({
    required this.id,
    required this.tarih,
    required this.baslangic,
    required this.bitis,
    required this.baslik,
    required this.aciklama,
    required this.renk,
    required this.tamamlandi,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as int,
      tarih: DateTime.parse(json['tarih'] as String),
      baslangic: (json['baslangic_saati'] as String).substring(0, 5),
      bitis: (json['bitis_saati'] as String).substring(0, 5),
      baslik: json['baslik'] as String,
      aciklama: json['aciklama'] as String?,
      renk: json['renk'] as String,
      tamamlandi: json['tamamlandi'] as bool,
    );
  }

  // PUT isteğinde tüm alanlar gönderilir
  Map<String, dynamic> toJson() {
    return {
      'tarih': Tarih.apiBicimi(tarih),
      'baslangic_saati': baslangic,
      'bitis_saati': bitis,
      'baslik': baslik,
      'aciklama': aciklama,
      'renk': renk,
      'tamamlandi': tamamlandi,
    };
  }

  Plan copyWith({bool? tamamlandi}) {
    return Plan(
      id: id,
      tarih: tarih,
      baslangic: baslangic,
      bitis: bitis,
      baslik: baslik,
      aciklama: aciklama,
      renk: renk,
      tamamlandi: tamamlandi ?? this.tamamlandi,
    );
  }

  Color get zeminRengi => Renkler.planZemin(renk);
  Color get yaziRengi => Renkler.planYazi(renk);
}
