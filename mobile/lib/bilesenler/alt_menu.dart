import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../tema/renkler.dart';

// Tasarımdaki alt menü ikonları (Gun.dc.html)
const _bugunIkonu = '<path d="M4 11l8-7 8 7v9h-5v-6h-6v6H4z"/>';
const _takvimIkonu = '<rect x="3.5" y="5" width="17" height="15.5" rx="2.5"/><path d="M3.5 10h17M8 3v4M16 3v4"/>';
const _aliskanlikIkonu =
    '<path d="M4.5 12a7.5 7.5 0 0 1 13-5.1M19.5 12a7.5 7.5 0 0 1-13 5.1"/><path d="M18 3.5v3.8h-3.8M6 20.5v-3.8h3.8"/>';
const _profilIkonu = '<circle cx="12" cy="8" r="4"/><path d="M4.5 20.5c1.4-3.6 4.4-5.5 7.5-5.5s6.1 1.9 7.5 5.5"/>';

// Bugün · Takvim · ( + ) · Alışkanlıklar · Profil
// seciliSekme: 0 Bugün, 1 Takvim, 2 Alışkanlıklar, 3 Profil
class AltMenu extends StatelessWidget {
  final int seciliSekme;
  final ValueChanged<int> sekmeSecildi;
  final VoidCallback artiBasildi;

  const AltMenu({super.key, required this.seciliSekme, required this.sekmeSecildi, required this.artiBasildi});

  @override
  Widget build(BuildContext context) {
    // Ortadaki 84 px'lik buton 68 px'lik menüden taşar; ikisi de Stack içinde ortalanır
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: Renkler.kenarlik),
            boxShadow: const [BoxShadow(color: Color(0x120E1424), blurRadius: 30, offset: Offset(0, 10))],
          ),
          child: Row(
            children: [
              _sekme(0, 'Bugün', _bugunIkonu),
              _sekme(1, 'Takvim', _takvimIkonu),
              const SizedBox(width: 92),
              _sekme(2, 'Alışkanlıklar', _aliskanlikIkonu),
              _sekme(3, 'Profil', _profilIkonu),
            ],
          ),
        ),
        _ArtiButonu(onPressed: artiBasildi),
      ],
    );
  }

  Widget _sekme(int sira, String yazi, String ikon) {
    return Expanded(
      child: _MenuSekmesi(
        yazi: yazi,
        ikon: ikon,
        secili: sira == seciliSekme,
        onTap: () => sekmeSecildi(sira),
      ),
    );
  }
}

class _MenuSekmesi extends StatelessWidget {
  final String yazi;
  final String ikon;
  final bool secili;
  final VoidCallback onTap;

  const _MenuSekmesi({required this.yazi, required this.ikon, required this.secili, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final renk = secili ? Renkler.lacivert : Renkler.griMetin;

    return Semantics(
      selected: secili,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.string(
                '<svg viewBox="0 0 24 24" fill="none" stroke="#000" stroke-width="1.8" '
                'stroke-linecap="round" stroke-linejoin="round">$ikon</svg>',
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(renk, BlendMode.srcIn),
              ),
              const SizedBox(height: 3),
              Text(
                yazi,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, fontWeight: secili ? FontWeight.w700 : FontWeight.w500, color: renk),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Yeni plan eklemek için ortadaki büyük bakır buton
class _ArtiButonu extends StatelessWidget {
  final VoidCallback onPressed;

  const _ArtiButonu({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 5),
      ),
      child: Material(
        color: Renkler.bakir,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const Tooltip(
            message: 'Yeni plan ekle',
            child: Icon(Icons.add_rounded, size: 38, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
