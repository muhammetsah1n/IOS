import 'package:flutter/material.dart';

import '../tema/renkler.dart';

// Üstünde etiket bulunan metin alanı (tasarımdaki input + label)
class FormAlani extends StatelessWidget {
  final String etiket;
  final String ipucu;
  final TextEditingController controller;
  final String? Function(String?) dogrulayici;
  final TextInputType klavye;
  final bool gizli;
  final Widget? sagIkon;
  final String? yardimMetni;
  final TextInputAction islem;
  final List<String> otomatikDoldurma;

  const FormAlani({
    super.key,
    required this.etiket,
    required this.ipucu,
    required this.controller,
    required this.dogrulayici,
    this.klavye = TextInputType.text,
    this.gizli = false,
    this.sagIkon,
    this.yardimMetni,
    this.islem = TextInputAction.next,
    this.otomatikDoldurma = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiket,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Renkler.griMetin),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: dogrulayici,
          keyboardType: klavye,
          obscureText: gizli,
          textInputAction: islem,
          autofillHints: otomatikDoldurma,
          style: const TextStyle(fontSize: 16, color: Renkler.koyuMetin),
          decoration: InputDecoration(hintText: ipucu, helperText: yardimMetni, suffixIcon: sagIkon),
        ),
      ],
    );
  }
}

// Şifreyi göster / gizle butonu
class SifreGozButonu extends StatelessWidget {
  final bool gorunur;
  final VoidCallback onPressed;

  const SifreGozButonu({super.key, required this.gorunur, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: gorunur ? 'Şifreyi gizle' : 'Şifreyi göster',
      color: Renkler.griMetin,
      icon: Icon(gorunur ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 22),
    );
  }
}
