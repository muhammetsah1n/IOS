import 'package:flutter/material.dart';

import 'ekranlar/giris_ekrani.dart';
import 'tema/tema.dart';

void main() {
  runApp(const QuickTickUygulamasi());
}

class QuickTickUygulamasi extends StatelessWidget {
  const QuickTickUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick-TicK',
      debugShowCheckedModeBanner: false,
      theme: Tema.acik,
      home: const GirisEkrani(),
    );
  }
}
