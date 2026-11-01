import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

// API adresi çalıştırırken değiştirilebilir:
// flutter run --dart-define=API_ADRESI=http://192.168.1.20:8000
// Varsayılan 10.0.2.2, Android emülatöründen bilgisayardaki localhost'a ulaşır.
const String apiAdresi = String.fromEnvironment('API_ADRESI', defaultValue: 'http://10.0.2.2:8000');

// API'den hata döndüğünde ekranda gösterilecek mesajı taşır
class ApiHatasi implements Exception {
  final String mesaj;
  final int? durumKodu;

  const ApiHatasi(this.mesaj, {this.durumKodu});

  @override
  String toString() => mesaj;
}

class ApiServisi {
  static const _zamanAsimi = Duration(seconds: 10);

  static Future<Map<String, dynamic>> get(String yol, {String? token}) {
    return _istek(() => http.get(Uri.parse('$apiAdresi$yol'), headers: _basliklar(token)));
  }

  static Future<Map<String, dynamic>> post(String yol, Map<String, dynamic> govde, {String? token}) {
    return _istek(
      () => http.post(Uri.parse('$apiAdresi$yol'), headers: _basliklar(token), body: jsonEncode(govde)),
    );
  }

  static Map<String, String> _basliklar(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> _istek(Future<http.Response> Function() gonder) async {
    final http.Response yanit;
    try {
      yanit = await gonder().timeout(_zamanAsimi);
    } on TimeoutException {
      throw const ApiHatasi('Sunucu yanıt vermedi. Biraz sonra tekrar dene.');
    } on http.ClientException {
      throw const ApiHatasi('Sunucuya bağlanılamadı. İnternet bağlantını kontrol et.');
    }

    final Map<String, dynamic> veri;
    try {
      final govde = utf8.decode(yanit.bodyBytes);
      veri = govde.isEmpty ? <String, dynamic>{} : jsonDecode(govde) as Map<String, dynamic>;
    } on FormatException {
      // Ör. sunucu hatasında (500) JSON yerine düz metin dönebilir
      throw ApiHatasi('Sunucuda bir hata oluştu.', durumKodu: yanit.statusCode);
    }

    if (yanit.statusCode >= 200 && yanit.statusCode < 300) return veri;
    throw ApiHatasi(_hataMesaji(veri), durumKodu: yanit.statusCode);
  }

  // FastAPI hataları {"detail": "..."} biçiminde gelir.
  // Doğrulama (422) hatalarında detail bir liste olur; o durumda genel bir mesaj gösterilir.
  static String _hataMesaji(Map<String, dynamic> veri) {
    final detay = veri['detail'];
    if (detay is String) return detay;
    return 'Girilen bilgiler geçersiz.';
  }
}
