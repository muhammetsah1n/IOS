import 'package:flutter/material.dart';

import '../tema/renkler.dart';
import '../tema/tema.dart';

// İçeriği sonraki haftalarda yapılacak sekmeler için geçici sayfa
class YakindaSayfasi extends StatelessWidget {
  final String baslik;
  final String aciklama;
  final IconData ikon;

  const YakindaSayfasi({super.key, required this.baslik, required this.aciklama, required this.ikon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(baslik, style: Tema.baslik()),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(ikon, size: 48, color: Renkler.kenarlik),
                  const SizedBox(height: 12),
                  Text(
                    aciklama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Renkler.griMetin),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
