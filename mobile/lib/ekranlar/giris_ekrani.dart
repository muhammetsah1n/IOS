import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../bilesenler/butonlar.dart';
import '../bilesenler/form_alani.dart';
import '../bilesenler/giris_iskeleti.dart';
import '../bilesenler/onay_kutusu.dart';
import '../servisler/api_servisi.dart';
import '../servisler/oturum.dart';
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
  bool _yukleniyor = false;

  @override
  void dispose() {
    _ePosta.dispose();
    _sifre.dispose();
    super.dispose();
  }

  Future<void> _girisYap() async {
    if (!_formAnahtari.currentState!.validate()) return;

    setState(() => _yukleniyor = true);
    try {
      // Başarılı olursa Oturum değişir ve main.dart ana sayfayı açar
      await context.read<Oturum>().girisYap(
        ePosta: _ePosta.text.trim(),
        sifre: _sifre.text,
        beniHatirla: _beniHatirla,
      );
    } on ApiHatasi catch (hata) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hata.mesaj)));
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
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
            AnaButon(yazi: 'Giriş yap', onPressed: _girisYap, yukleniyor: _yukleniyor),
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
