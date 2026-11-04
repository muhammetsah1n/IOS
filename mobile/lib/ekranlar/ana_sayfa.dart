import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bilesenler/plan_karti.dart';
import '../modeller/plan.dart';
import '../servisler/api_servisi.dart';
import '../servisler/oturum.dart';
import '../servisler/plan_servisi.dart';
import '../tema/renkler.dart';
import '../tema/tema.dart';
import '../yardimcilar/tarih.dart';

// Bugün sekmesi: selamlama, gün kartı ve API'den gelen "Gün planı".
// Plan ekleme/düzenleme 4. haftada, Yapılacaklar 5. haftada eklenecek.
class AnaSayfa extends StatefulWidget {
  // Profil fotoğrafına dokununca Profil sekmesine geçmek için
  final VoidCallback profilAc;

  const AnaSayfa({super.key, required this.profilAc});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final DateTime _gun = DateTime.now();
  List<Plan> _planlar = [];
  bool _yukleniyor = true;
  String? _hata;

  @override
  void initState() {
    super.initState();
    _planlariYukle();
  }

  Future<void> _planlariYukle() async {
    final oturum = context.read<Oturum>();
    setState(() {
      _yukleniyor = _planlar.isEmpty;
      _hata = null;
    });

    try {
      final planlar = await PlanServisi.gunPlanlari(oturum.token!, _gun);
      if (!mounted) return;
      setState(() => _planlar = planlar);
    } on ApiHatasi catch (hata) {
      if (!mounted) return;
      // Token süresi dolduysa giriş ekranına dönülür
      if (hata.durumKodu == 401) {
        await oturum.cikisYap();
        return;
      }
      setState(() => _hata = hata.mesaj);
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  Future<void> _tamamlandiDegistir(Plan plan, bool deger) async {
    final token = context.read<Oturum>().token!;
    final mesajlar = ScaffoldMessenger.of(context);

    // Kutu hemen işaretlenir; API hata verirse eski haline döner
    _planiDegistir(plan.copyWith(tamamlandi: deger));
    try {
      final guncel = await PlanServisi.guncelle(token, plan.copyWith(tamamlandi: deger));
      if (mounted) _planiDegistir(guncel);
    } on ApiHatasi catch (hata) {
      if (!mounted) return;
      _planiDegistir(plan);
      mesajlar.showSnackBar(SnackBar(content: Text(hata.mesaj)));
    }
  }

  void _planiDegistir(Plan yeni) {
    setState(() {
      _planlar = [for (final p in _planlar) p.id == yeni.id ? yeni : p];
    });
  }

  @override
  Widget build(BuildContext context) {
    final ad = context.watch<Oturum>().kullanici?.ad ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        children: [
          _UstSatir(ad: ad, profilAc: widget.profilAc),
          const SizedBox(height: 16),
          Expanded(child: _gunKarti()),
        ],
      ),
    );
  }

  Widget _gunKarti() {
    return Container(
      decoration: BoxDecoration(
        color: Renkler.arkaPlan,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Renkler.kenarlik),
        boxShadow: const [BoxShadow(color: Color(0x120E1424), blurRadius: 30, offset: Offset(0, 10))],
      ),
      clipBehavior: Clip.antiAlias,
      // Aşağı çekince planlar yeniden yüklenir
      child: RefreshIndicator(
        color: Renkler.lacivert,
        onRefresh: _planlariYukle,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 18, 14, 14),
          children: [
            _GunBasligi(gun: _gun),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 36),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gün planı',
                  style: Tema.baslik(boyut: 18, kalinlik: FontWeight.w600).copyWith(color: Renkler.koyuMetin),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ..._planListesi(),
          ],
        ),
      ),
    );
  }

  List<Widget> _planListesi() {
    if (_yukleniyor) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator(color: Renkler.lacivert)),
        ),
      ];
    }

    if (_hata != null) {
      return [
        _BilgiMesaji(
          ikon: Icons.cloud_off_rounded,
          mesaj: _hata!,
          buton: TextButton(onPressed: _planlariYukle, child: const Text('Tekrar dene')),
        ),
      ];
    }

    if (_planlar.isEmpty) {
      return const [_BilgiMesaji(ikon: Icons.event_available_outlined, mesaj: 'Bugün için plan yok.')];
    }

    return [
      for (final plan in _planlar)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: PlanKarti(
            plan: plan,
            tamamlandiDegisti: (deger) => _tamamlandiDegistir(plan, deger),
          ),
        ),
    ];
  }
}

// Profil fotoğrafı (şimdilik adın baş harfi) ve selamlama
class _UstSatir extends StatelessWidget {
  final String ad;
  final VoidCallback profilAc;

  const _UstSatir({required this.ad, required this.profilAc});

  @override
  Widget build(BuildContext context) {
    final basHarf = ad.isEmpty ? '?' : ad.characters.first.toUpperCase();

    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Profil ayarları',
          child: InkWell(
            onTap: profilAc,
            customBorder: const CircleBorder(),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Renkler.lacivert,
              child: Text(
                basHarf,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '${Tarih.selamlama(DateTime.now())}, $ad',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Renkler.griMetin),
          ),
        ),
      ],
    );
  }
}

// Gün kartının üstü: solda büyük gün numarası, sağda gün adı ve ay
class _GunBasligi extends StatelessWidget {
  final DateTime gun;

  const _GunBasligi({required this.gun});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Renkler.koyuMetin, width: 2))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${gun.day}',
            style: Tema.baslik(boyut: 40).copyWith(height: 0.85, letterSpacing: -1.6),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Tarih.gunAdi(gun),
                  style: Tema.baslik(boyut: 17).copyWith(height: 1.1, color: Renkler.koyuMetin),
                ),
                const SizedBox(height: 2),
                Text(Tarih.ayYil(gun), style: const TextStyle(fontSize: 13, color: Renkler.griMetin)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Boş liste ve hata durumlarında gösterilen ortalanmış mesaj
class _BilgiMesaji extends StatelessWidget {
  final IconData ikon;
  final String mesaj;
  final Widget? buton;

  const _BilgiMesaji({required this.ikon, required this.mesaj, this.buton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(ikon, size: 40, color: Renkler.kenarlik),
          const SizedBox(height: 10),
          Text(mesaj, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Renkler.griMetin)),
          // buton null ise listeye eklenmez
          ?buton,
        ],
      ),
    );
  }
}
