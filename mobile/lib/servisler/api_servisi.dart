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

  static Future<Map<String, dynamic>> get(String yol, {String? token}) async {
    return await _istek(() => http.get(Uri.parse('$apiAdresi$yol'), headers: _basliklar(token)))
        as Map<String, dynamic>;
  }

  // Liste döndüren uç noktalar için (ör. GET /plans)
  static Future<List<dynamic>> getListe(String yol, {String? token}) async {
    return await _istek(() => http.get(Uri.parse('$apiAdresi$yol'), headers: _basliklar(token)))
        as List<dynamic>;
  }

  static Future<Map<String, dynamic>> post(String yol, Map<String, dynamic> govde, {String? token}) async {
    return await _istek(
      () => http.post(Uri.parse('$apiAdresi$yol'), headers: _basliklar(token), body: jsonEncode(govde)),
    ) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> put(String yol, Map<String, dynamic> govde, {String? token}) async {
    return await _istek(
      () => http.put(Uri.parse('$apiAdresi$yol'), headers: _basliklar(token), body: jsonEncode(govde)),
    ) as Map<String, dynamic>;
  }

  static Future<void> delete(String yol, {String? token}) async {
    await _istek(() => http.delete(Uri.parse('$apiAdresi$yol'), headers: _basliklar(token)));
  }

  static Map<String, String> _basliklar(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Yanıt gövdesini çözer: nesne için Map, liste için List döner (204'te boş Map)
  static Future<Object> _istek(Future<http.Response> Function() gonder) async {
    final http.Response yanit;
    try {
      yanit = await gonder().timeout(_zamanAsimi);
    } on TimeoutException {
      throw const ApiHatasi('Sunucu yanıt vermedi. Biraz sonra tekrar dene.');
    } on http.ClientException {
      throw const ApiHatasi('Sunucuya bağlanılamadı. İnternet bağlantını kontrol et.');
    }

    final Object veri;
    try {
      final govde = utf8.decode(yanit.bodyBytes);
      veri = govde.isEmpty ? <String, dynamic>{} : jsonDecode(govde) as Object;
    } on FormatException {
      // Ör. sunucu hatasında (500) JSON yerine düz metin dönebilir
      throw ApiHatasi('Sunucuda bir hata oluştu.', durumKodu: yanit.statusCode);
    }

    if (yanit.statusCode >= 200 && yanit.statusCode < 300) return veri;
    throw ApiHatasi(_hataMesaji(veri), durumKodu: yanit.statusCode);
  }

  // FastAPI hataları {"detail": "..."} biçiminde gelir.
  // Doğrulama (422) hatalarında detail bir liste olur; o durumda genel bir mesaj gösterilir.
  static String _hataMesaji(Object veri) {
    final detay = veri is Map<String, dynamic> ? veri['detail'] : null;
    if (detay is String) return detay;
    return 'Girilen bilgiler geçersiz.';
  }
}
