// Form alanlarında kullanılan doğrulama fonksiyonları.
// Hata yoksa null, hata varsa ekranda gösterilecek mesajı döndürürler.
class Dogrulayicilar {
  static final _ePostaKalibi = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static String? ad(String? deger) {
    if (deger == null || deger.trim().isEmpty) return 'Adını yaz.';
    return null;
  }

  static String? ePosta(String? deger) {
    if (deger == null || !_ePostaKalibi.hasMatch(deger.trim())) {
      return 'Geçerli bir e-posta adresi gir.';
    }
    return null;
  }

  static String? girisSifresi(String? deger) {
    if (deger == null || deger.isEmpty) return 'Şifreni gir.';
    return null;
  }

  static String? yeniSifre(String? deger) {
    if (deger == null || deger.length < 8) return 'En az 8 karakter olmalı.';
    return null;
  }

  static String? sifreTekrar(String? deger, String sifre) {
    if (deger == null || deger.isEmpty || deger != sifre) return 'Şifreler eşleşmiyor.';
    return null;
  }
}
