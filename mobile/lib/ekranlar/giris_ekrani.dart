import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bilesenler/butonlar.dart';
import '../bilesenler/form_alani.dart';
import '../bilesenler/giris_iskeleti.dart';
import '../bilesenler/onay_kutusu.dart';
import '../tema/tema.dart';
import '../yardimcilar/dogrulayicilar.dart';
import 'kayit_ekrani.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _formAnahtari = GlobalKey<FormState>();
  final _ePosta = TextEditingController();
  final _sifre = TextEditingController();
  bool _sifreGorunur = false;
  bool _beniHatirla = false;

  @override
  void dispose() {
    _ePosta.dispose();
    _sifre.dispose();
    super.dispose();
  }

  void _girisYap() {
    if (!_formAnahtari.currentState!.validate()) return;

    // 2. haftada burada API'ye giriş isteği gönderilecek
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Bilgiler geçerli. API bağlantısı 2. haftada eklenecek.')));
  }

  void _sifremiUnuttum() {
    // Şifremi unuttum ekranı 7. haftada eklenecek
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Şifre sıfırlama ekranı yakında eklenecek.')));
  }

  @override
  Widget build(BuildContext context) {
    return GirisIskeleti(
      arkaPlan: 'assets/images/arkaplan_giris.svg',
      child: Form(
        key: _formAnahtari,
        child: Column(
          children: [
            SvgPicture.asset('assets/images/logo.svg', width: 94, height: 80),
            const SizedBox(height: 14),
            Text('Quick-TicK', style: Tema.girisBaslik(32)),
            const SizedBox(height: 24),
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
              ipucu: '••••••••',
              controller: _sifre,
              dogrulayici: Dogrulayicilar.girisSifresi,
              gizli: !_sifreGorunur,
              islem: TextInputAction.done,
              otomatikDoldurma: const [AutofillHints.password],
              sagIkon: SifreGozButonu(
                gorunur: _sifreGorunur,
                onPressed: () => setState(() => _sifreGorunur = !_sifreGorunur),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OnayKutusu(
                    yazi: 'Beni hatırla',
                    secili: _beniHatirla,
                    onChanged: (deger) => setState(() => _beniHatirla = deger),
                  ),
                  YaziBaglantisi(yazi: 'Şifremi unuttum', onTap: _sifremiUnuttum),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AnaButon(yazi: 'Giriş yap', onPressed: _girisYap),
            const SizedBox(height: 12),
            AltBaglantiSatiri(
              soru: 'Hesabın yok mu?',
              baglanti: 'Kayıt ol',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const KayitEkrani())),
            ),
          ],
        ),
      ),
    );
  }
}
