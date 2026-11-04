import 'package:flutter/material.dart';

import '../modeller/plan.dart';
import '../tema/renkler.dart';

// "Gün planı" listesindeki tek bir plan: saatler | ad ve açıklama | tamamlandı kutusu
class PlanKarti extends StatelessWidget {
  final Plan plan;
  final ValueChanged<bool> tamamlandiDegisti;

  const PlanKarti({super.key, required this.plan, required this.tamamlandiDegisti});

  @override
  Widget build(BuildContext context) {
    final yazi = plan.yaziRengi;

    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
      decoration: BoxDecoration(color: plan.zeminRengi, borderRadius: BorderRadius.circular(16)),
      // IntrinsicHeight, aradaki ince çizginin kartın yüksekliği kadar uzamasını sağlar
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 44,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.baslangic, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: yazi)),
                  Text(plan.bitis, style: TextStyle(fontSize: 13, color: yazi.withValues(alpha: 0.75))),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: yazi.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.baslik,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Renkler.koyuMetin,
                        decoration: plan.tamamlandi ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (plan.aciklama != null) ...[
                      const SizedBox(height: 2),
                      Text(plan.aciklama!, style: TextStyle(fontSize: 13, color: yazi)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Center(
              child: Semantics(
                label: '${plan.baslik} tamamlandı',
                checked: plan.tamamlandi,
                child: InkWell(
                  onTap: () => tamamlandiDegisti(!plan.tamamlandi),
                  borderRadius: BorderRadius.circular(22),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: plan.tamamlandi ? Renkler.lacivert : Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Renkler.lacivert, width: 2),
                        ),
                        child: plan.tamamlandi
                            ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
