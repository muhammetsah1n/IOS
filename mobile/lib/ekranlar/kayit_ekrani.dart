import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bilesenler/butonlar.dart';
import '../bilesenler/form_alani.dart';
import '../bilesenler/giris_iskeleti.dart';
import '../tema/renkler.dart';
import '../tema/tema.dart';
import '../yardimcilar/dogrulayicilar.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final _formAnahtari = GlobalKey<FormState>();
  final _ad = TextEditingController();
  final _ePosta = TextEditingController();
  final _sifre = TextEditingController();
  final _sifreTekrar = TextEditingController();
  // Tasarımda iki şifre alanı da aynı göz butonuyla birlikte açılıp kapanıyor
  bool _sifreGorunur = false;

  @override
  void dispose() {
    _ad.dispose();
    _ePosta.dispose();
    _sifre.dispose();
    _sifreTekrar.dispose();
    super.dispose();
  }

  void _kayitOl() {
    if (!_formAnahtari.currentState!.validate()) return;

    // 2. haftada burada API'ye kayıt isteği gönderilecek
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Bilgiler geçerli. API bağlantısı 2. haftada eklenecek.')));
  }

  @override
  Widget build(BuildContext context) {
    final gozButonu = SifreGozButonu(
      gorunur: _sifreGorunur,
      onPressed: () => setState(() => _sifreGorunur = !_sifreGorunur),
    );

    return GirisIskeleti(
      arkaPlan: 'assets/images/arkaplan_kayit.svg',
      child: Form(
        key: _formAnahtari,
        child: Column(
          children: [
            SvgPicture.asset('assets/images/logo.svg', width: 70, height: 60),
            const SizedBox(height: 14),
            Text('Hesap oluştur', style: Tema.girisBaslik(28)),
            const SizedBox(height: 6),
            const Text(
              'Birkaç bilgiyle başlayalım.',
              style: TextStyle(fontSize: 15, height: 1.4, color: Renkler.griMetin),
            ),
            const SizedBox(height: 24),
            FormAlani(
              etiket: 'Ad',
              ipucu: 'Adın',
              controller: _ad,
              dogrulayici: Dogrulayicilar.ad,
              otomatikDoldurma: const [AutofillHints.name],
            ),
            const SizedBox(height: 12),
            FormAlani(
              etiket: 'E-posta',
              ipucu: 'ornek@eposta.com',
              controller: _ePosta,
              dogrulayici: Dogrulayicilar.ePosta,
              klavye: TextInputType.emailAddress,
              otomatikDoldurma: const [AutofillHints.email],
            ),
            const SizedBox(height: 12),
            FormAlani(
              etiket: 'Şifre',
              ipucu: 'En az 8 karakter',
              controller: _sifre,
              dogrulayici: Dogrulayicilar.yeniSifre,
              yardimMetni: 'En az 8 karakter olmalı.',
              gizli: !_sifreGorunur,
              otomatikDoldurma: const [AutofillHints.newPassword],
              sagIkon: gozButonu,
            ),
            const SizedBox(height: 12),
            FormAlani(
              etiket: 'Şifre tekrar',
              ipucu: '••••••••',
              controller: _sifreTekrar,
              dogrulayici: (deger) => Dogrulayicilar.sifreTekrar(deger, _sifre.text),
              gizli: !_sifreGorunur,
              islem: TextInputAction.done,
              otomatikDoldurma: const [AutofillHints.newPassword],
              sagIkon: gozButonu,
            ),
            const SizedBox(height: 12),
            AnaButon(yazi: 'Kayıt ol', onPressed: _kayitOl),
            const SizedBox(height: 12),
            AltBaglantiSatiri(
              soru: 'Zaten hesabın var mı?',
              baglanti: 'Giriş yap',
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
