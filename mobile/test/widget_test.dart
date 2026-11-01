import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_tick/bilesenler/alt_menu.dart';
import 'package:quick_tick/ekranlar/giris_ekrani.dart';
import 'package:quick_tick/ekranlar/kayit_ekrani.dart';
import 'package:quick_tick/servisler/oturum.dart';
import 'package:quick_tick/yardimcilar/dogrulayicilar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Testlerde yazı tipleri internetten indirilmesin
  GoogleFonts.config.allowRuntimeFetching = false;

  group('Dogrulayicilar', () {
    test('e-posta', () {
      expect(Dogrulayicilar.ePosta('ali@ornek.com'), isNull);
      expect(Dogrulayicilar.ePosta('ali@ornek'), isNotNull);
      expect(Dogrulayicilar.ePosta(''), isNotNull);
    });

    test('şifre en az 8 karakter', () {
      expect(Dogrulayicilar.yeniSifre('1234567'), isNotNull);
      expect(Dogrulayicilar.yeniSifre('12345678'), isNull);
    });

    test('şifre tekrar eşleşmeli', () {
      expect(Dogrulayicilar.sifreTekrar('abcdefgh', 'abcdefgh'), isNull);
      expect(Dogrulayicilar.sifreTekrar('abcdefgi', 'abcdefgh'), isNotNull);
    });
  });

  testWidgets('Giriş ekranı boş gönderilince hata gösterir', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GirisEkrani()));
    await tester.tap(find.text('Giriş yap'));
    await tester.pump();

    expect(find.text('Geçerli bir e-posta adresi gir.'), findsOneWidget);
    expect(find.text('Şifreni gir.'), findsOneWidget);
  });

  testWidgets('Kayıt ekranı şifre eşleşmeyince hata gösterir', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: KayitEkrani()));
    final alanlar = find.byType(TextFormField);
    await tester.enterText(alanlar.at(0), 'Ali');
    await tester.enterText(alanlar.at(1), 'ali@ornek.com');
    await tester.enterText(alanlar.at(2), '12345678');
    await tester.enterText(alanlar.at(3), '12345679');
    await tester.ensureVisible(find.text('Kayıt ol'));
    await tester.tap(find.text('Kayıt ol'));
    await tester.pump();

    expect(find.text('Şifreler eşleşmiyor.'), findsOneWidget);
    expect(find.text('Adını yaz.'), findsNothing);
  });

  test('Kayıtlı token yoksa oturum kapalı başlar', () async {
    SharedPreferences.setMockInitialValues({});
    final oturum = Oturum();
    await oturum.baslat();

    expect(oturum.hazir, isTrue);
    expect(oturum.girisYapildi, isFalse);
  });

  testWidgets('Alt menüde sekmeye dokununca sırası bildirilir', (tester) async {
    int? secilen;
    var artiSayisi = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AltMenu(
            seciliSekme: 0,
            sekmeSecildi: (sira) => secilen = sira,
            artiBasildi: () => artiSayisi++,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Alışkanlıklar'));
    expect(secilen, 2);
    await tester.tap(find.byIcon(Icons.add_rounded));
    expect(artiSayisi, 1);
  });
}
