import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'renkler.dart';

class Tema {
  // Başlıklar ve gün numarası için
  static TextStyle baslik({double boyut = 28, FontWeight kalinlik = FontWeight.w700}) {
    return GoogleFonts.bricolageGrotesque(fontSize: boyut, fontWeight: kalinlik, color: Renkler.lacivert);
  }

  // Giriş ekranlarındaki büyük başlıklar Inter ile yazılıyor
  static TextStyle girisBaslik(double boyut) {
    return GoogleFonts.inter(
      fontSize: boyut,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -0.02 * boyut,
      color: Renkler.koyuMetin,
    );
  }

  static ThemeData get acik {
    OutlineInputBorder kenar(Color renk, [double kalinlik = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: renk, width: kalinlik),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Renkler.arkaPlan,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Renkler.lacivert,
        primary: Renkler.lacivert,
        secondary: Renkler.bakir,
        error: Renkler.hata,
        surface: Renkler.arkaPlan,
      ),
      // Gövde metni için DM Sans
      fontFamily: GoogleFonts.dmSans().fontFamily,
      textTheme: const TextTheme().apply(bodyColor: Renkler.koyuMetin, displayColor: Renkler.koyuMetin),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Renkler.arkaPlan,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: GoogleFonts.dmSans(fontSize: 16, color: Renkler.griMetin.withValues(alpha: 0.6)),
        helperStyle: GoogleFonts.dmSans(fontSize: 12, color: Renkler.griMetin),
        errorStyle: GoogleFonts.dmSans(fontSize: 12, color: Renkler.hata),
        enabledBorder: kenar(Renkler.girisKenarlik),
        focusedBorder: kenar(Renkler.lacivert, 1.5),
        errorBorder: kenar(Renkler.hata),
        focusedErrorBorder: kenar(Renkler.hata, 1.5),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating, backgroundColor: Renkler.lacivert),
    );
  }
}
