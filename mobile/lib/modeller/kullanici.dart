// API'den gelen kullanıcı bilgisi
class Kullanici {
  final int id;
  final String ad;
  final String? kullaniciAdi;
  final String ePosta;
  final String rol;

  const Kullanici({
    required this.id,
    required this.ad,
    required this.kullaniciAdi,
    required this.ePosta,
    required this.rol,
  });

  bool get yoneticiMi => rol == 'admin';

  factory Kullanici.fromJson(Map<String, dynamic> json) {
    return Kullanici(
      id: json['id'] as int,
      ad: json['ad'] as String,
      kullaniciAdi: json['kullanici_adi'] as String?,
      ePosta: json['e_posta'] as String,
      rol: json['rol'] as String,
    );
  }
}
