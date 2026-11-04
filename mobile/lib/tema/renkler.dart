import 'package:flutter/material.dart';

// Tasarımdaki renkler
class Renkler {
  static const lacivert = Color(0xFF1B2A4A);
  static const koyuMetin = Color(0xFF0E1424);
  static const bakir = Color(0xFFB8673A);
  static const griMetin = Color(0xFF5F5C5A);
  static const kenarlik = Color(0xFFE3DACB);
  static const girisKenarlik = Color(0xFFD8CCBA);
  static const acikGriZemin = Color(0xFFF3F5F8);
  static const hata = Color(0xFFB3261E);
  static const arkaPlan = Color(0xFFFFFFFF);

  // Plan kartı renkleri
  static const planMavi = Color(0xFFB9CCF5);
  static const planSari = Color(0xFFFFD08A);
  static const planYesil = Color(0xFFCFE3B4);
  static const planYesilYazi = Color(0xFF25401A);
  static const planSomon = Color(0xFFF6B79A);

  // API'de saklanan renk koduna göre kartın zemin ve yazı rengi
  static const _planRenkleri = {
    '#B9CCF5': (planMavi, lacivert),
    '#FFD08A': (planSari, Color(0xFF3F2A05)),
    '#CFE3B4': (planYesil, planYesilYazi),
    '#F6B79A': (planSomon, Color(0xFF4D220E)),
  };

  static Color planZemin(String kod) => (_planRenkleri[kod] ?? _planRenkleri['#CFE3B4']!).$1;
  static Color planYazi(String kod) => (_planRenkleri[kod] ?? _planRenkleri['#CFE3B4']!).$2;
}
