import 'package:flutter/material.dart';

import '../tema/renkler.dart';

// Bakır renkli, tam genişlikte ana buton (Giriş yap, Kayıt ol ...)
class AnaButon extends StatelessWidget {
  final String yazi;
  final VoidCallback onPressed;

  const AnaButon({super.key, required this.yazi, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Renkler.bakir,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        child: Text(yazi),
      ),
    );
  }
}

// Altı çizili lacivert yazı bağlantısı (Şifremi unuttum, Kayıt ol ...)
class YaziBaglantisi extends StatelessWidget {
  final String yazi;
  final VoidCallback onTap;
  final FontWeight kalinlik;

  const YaziBaglantisi({super.key, required this.yazi, required this.onTap, this.kalinlik = FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        // widthFactor: 1 → yalnızca yazı kadar yer kaplar, satırın tamamını değil
        child: Align(
          widthFactor: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              yazi,
              style: TextStyle(
                fontSize: 14,
                fontWeight: kalinlik,
                color: Renkler.lacivert,
                decoration: TextDecoration.underline,
                decorationColor: Renkler.lacivert,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// "Hesabın yok mu? Kayıt ol" gibi alt satır
class AltBaglantiSatiri extends StatelessWidget {
  final String soru;
  final String baglanti;
  final VoidCallback onTap;

  const AltBaglantiSatiri({super.key, required this.soru, required this.baglanti, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Dar ekranda sığmazsa bağlantı alt satıra geçer
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(soru, style: const TextStyle(fontSize: 14, color: Renkler.griMetin)),
        const SizedBox(width: 2),
        YaziBaglantisi(yazi: baglanti, onTap: onTap, kalinlik: FontWeight.w700),
      ],
    );
  }
}
