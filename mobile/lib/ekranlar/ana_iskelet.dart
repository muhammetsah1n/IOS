import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bilesenler/alt_menu.dart';
import '../bilesenler/yakinda_sayfasi.dart';
import '../servisler/oturum.dart';
import 'profil_ekrani.dart';

// Giriş yapıldıktan sonra açılan ana yapı: üstte seçili sekmenin sayfası, altta alt menü
class AnaIskelet extends StatefulWidget {
  const AnaIskelet({super.key});

  @override
  State<AnaIskelet> createState() => _AnaIskeletState();
}

class _AnaIskeletState extends State<AnaIskelet> {
  int _seciliSekme = 0;

  void _artiBasildi() {
    // Plan ekleme 4. haftada (gün planı düzenleme modu) eklenecek
    setState(() => _seciliSekme = 0);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Plan ekleme 4. haftada eklenecek.')));
  }

  @override
  Widget build(BuildContext context) {
    final ad = context.watch<Oturum>().kullanici?.ad ?? '';

    // Sırası alt menüdeki sekmelerle aynı: Bugün, Takvim, Alışkanlıklar, Profil
    final sayfalar = [
      YakindaSayfasi(
        baslik: 'Merhaba, $ad',
        aciklama: 'Gün planı ve yapılacaklar\n3. haftada eklenecek.',
        ikon: Icons.today_outlined,
      ),
      const YakindaSayfasi(
        baslik: 'Takvim',
        aciklama: 'Aylık takvim 6. haftada eklenecek.',
        ikon: Icons.calendar_month_outlined,
      ),
      const YakindaSayfasi(
        baslik: 'Alışkanlıklar',
        aciklama: 'Alışkanlıklar 8. haftada eklenecek.',
        ikon: Icons.autorenew_rounded,
      ),
      const ProfilEkrani(),
    ];

    // Bugün dışındaki bir sekmedeyken geri tuşu önce Bugün'e döner
    return PopScope(
      canPop: _seciliSekme == 0,
      onPopInvokedWithResult: (geriGidildi, _) {
        if (!geriGidildi) setState(() => _seciliSekme = 0);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // IndexedStack, sekme değişince diğer sayfaların durumunu kaybetmez
              Expanded(child: IndexedStack(index: _seciliSekme, children: sayfalar)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: AltMenu(
                  seciliSekme: _seciliSekme,
                  sekmeSecildi: (sira) => setState(() => _seciliSekme = sira),
                  artiBasildi: _artiBasildi,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
