// Türkçe gün/ay adları ve API'nin beklediği tarih biçimi
class Tarih {
  // DateTime.weekday: 1 = Pazartesi ... 7 = Pazar
  static const _gunler = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
  static const _aylar = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  static String gunAdi(DateTime tarih) => _gunler[tarih.weekday - 1];

  // Ör. "Kasım 2026"
  static String ayYil(DateTime tarih) => '${_aylar[tarih.month - 1]} ${tarih.year}';

  // API tarihleri "2026-11-03" biçiminde ister
  static String apiBicimi(DateTime tarih) {
    final ay = tarih.month.toString().padLeft(2, '0');
    final gun = tarih.day.toString().padLeft(2, '0');
    return '${tarih.year}-$ay-$gun';
  }

  static String selamlama(DateTime simdi) {
    final saat = simdi.hour;
    if (saat >= 5 && saat < 12) return 'Günaydın';
    if (saat >= 12 && saat < 18) return 'İyi günler';
    if (saat >= 18 && saat < 22) return 'İyi akşamlar';
    return 'İyi geceler';
  }
}
