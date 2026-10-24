import 'package:flutter/material.dart';

import '../tema/renkler.dart';

// Tasarımdaki yuvarlak köşeli "Beni hatırla" kutusu
class OnayKutusu extends StatelessWidget {
  final bool secili;
  final String yazi;
  final ValueChanged<bool> onChanged;

  const OnayKutusu({super.key, required this.secili, required this.yazi, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!secili),
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: secili ? Renkler.lacivert : Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Renkler.lacivert, width: 2),
              ),
              child: secili ? const Icon(Icons.check_rounded, size: 15, color: Colors.white) : null,
            ),
            const SizedBox(width: 10),
            Text(yazi, style: const TextStyle(fontSize: 14, color: Renkler.koyuMetin)),
          ],
        ),
      ),
    );
  }
}
