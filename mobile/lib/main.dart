import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ekranlar/ana_iskelet.dart';
import 'ekranlar/giris_ekrani.dart';
import 'servisler/oturum.dart';
import 'tema/renkler.dart';
import 'tema/tema.dart';

void main() {
  runApp(
    // Oturum tüm ekranlardan erişilebilsin diye uygulamanın en üstüne konur
    ChangeNotifierProvider(
      create: (_) => Oturum()..baslat(),
      child: const QuickTickUygulamasi(),
    ),
  );
}

class QuickTickUygulamasi extends StatelessWidget {
  const QuickTickUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    final oturum = context.watch<Oturum>();

    // Giriş yapılınca ya da çıkış yapılınca açılan ekran kendiliğinden değişir
    final Widget acilisEkrani;
    if (!oturum.hazir) {
      acilisEkrani = const Scaffold(body: Center(child: CircularProgressIndicator(color: Renkler.lacivert)));
    } else if (oturum.girisYapildi) {
      acilisEkrani = const AnaIskelet();
    } else {
      acilisEkrani = const GirisEkrani();
    }

    return MaterialApp(
      title: 'Quick-TicK',
      debugShowCheckedModeBanner: false,
      theme: Tema.acik,
      home: acilisEkrani,
    );
  }
}
