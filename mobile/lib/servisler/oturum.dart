import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modeller/kullanici.dart';
import 'api_servisi.dart';

// Giriş yapan kullanıcıyı ve JWT token'ı tutar.
// Değiştiğinde (giriş, çıkış) dinleyen ekranlar yeniden çizilir.
class Oturum extends ChangeNotifier {
  static const _tokenAnahtari = 'token';

  String? _token;
  Kullanici? _kullanici;
  bool _hazir = false;

  String? get token => _token;
  Kullanici? get kullanici => _kullanici;
  bool get girisYapildi => _kullanici != null;
  // Uygulama açılırken kayıtlı token kontrol edilene kadar false
  bool get hazir => _hazir;

  // "Beni hatırla" seçildiyse kayıtlı token ile oturumu geri açar
  Future<void> baslat() async {
    final tercihler = await SharedPreferences.getInstance();
    final kayitliToken = tercihler.getString(_tokenAnahtari);

    if (kayitliToken != null) {
      try {
        final veri = await ApiServisi.get('/auth/ben', token: kayitliToken);
        _token = kayitliToken;
        _kullanici = Kullanici.fromJson(veri);
      } on ApiHatasi catch (hata) {
        // Token süresi dolmuşsa siliyoruz; sunucuya ulaşılamadıysa bir sonraki açılışta tekrar denenir
        if (hata.durumKodu == 401) await tercihler.remove(_tokenAnahtari);
      }
    }

    _hazir = true;
    notifyListeners();
  }

  Future<void> girisYap({required String ePosta, required String sifre, required bool beniHatirla}) async {
    final veri = await ApiServisi.post('/auth/giris', {'e_posta': ePosta, 'sifre': sifre});
    await _oturumuAc(veri, kaydet: beniHatirla);
  }

  Future<void> kayitOl({required String ad, required String ePosta, required String sifre}) async {
    final veri = await ApiServisi.post('/auth/kayit', {'ad': ad, 'e_posta': ePosta, 'sifre': sifre});
    // Kayıt ekranında "Beni hatırla" olmadığı için token yalnızca uygulama açıkken tutulur
    await _oturumuAc(veri, kaydet: false);
  }

  Future<void> cikisYap() async {
    final tercihler = await SharedPreferences.getInstance();
    await tercihler.remove(_tokenAnahtari);
    _token = null;
    _kullanici = null;
    notifyListeners();
  }

  Future<void> _oturumuAc(Map<String, dynamic> veri, {required bool kaydet}) async {
    final tercihler = await SharedPreferences.getInstance();
    _token = veri['access_token'] as String;
    _kullanici = Kullanici.fromJson(veri['kullanici'] as Map<String, dynamic>);

    if (kaydet) {
      await tercihler.setString(_tokenAnahtari, _token!);
    } else {
      await tercihler.remove(_tokenAnahtari);
    }
    notifyListeners();
  }
}
