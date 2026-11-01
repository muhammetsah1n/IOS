import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../servisler/oturum.dart';
import '../tema/renkler.dart';
import '../tema/tema.dart';

// Şimdilik yalnızca kullanıcı bilgileri ve çıkış.
// Fotoğraf, kullanıcı adı ve şifre değiştirme 7. haftada eklenecek.
class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final kullanici = context.watch<Oturum>().kullanici;
    // Çıkış yapılırken ekran kapanmadan önce bir kez daha çizilebilir
    if (kullanici == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        Text('Profil', style: Tema.baslik()),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Renkler.kenarlik),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kullanici.ad,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Renkler.koyuMetin),
              ),
              const SizedBox(height: 4),
              Text(kullanici.ePosta, style: const TextStyle(fontSize: 14, color: Renkler.griMetin)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Renkler.acikGriZemin,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  kullanici.yoneticiMi ? 'Yönetici' : 'Kullanıcı',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Renkler.lacivert),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => context.read<Oturum>().cikisYap(),
          borderRadius: BorderRadius.circular(16),
          child: const SizedBox(
            height: 56,
            child: Row(
              children: [
                SizedBox(width: 16),
                Icon(Icons.logout_rounded, size: 22, color: Renkler.hata),
                SizedBox(width: 14),
                Text('Çıkış yap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Renkler.hata)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
