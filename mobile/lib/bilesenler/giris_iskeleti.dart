import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Giriş, Kayıt ol ve şifre ekranlarının ortak düzeni:
// altta silikleşen çizim deseni ve ortada kaydırılabilir içerik.
class GirisIskeleti extends StatelessWidget {
  final String arkaPlan;
  final Widget child;

  const GirisIskeleti({super.key, required this.arkaPlan, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.9,
                child: ShaderMask(
                  // Desen aşağıda belirgin, yukarı doğru kayboluyor
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (alan) => const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xF2000000), Color(0x99000000), Color(0x2E000000), Color(0x00000000)],
                    stops: [0, 0.22, 0.5, 0.78],
                  ).createShader(alan),
                  child: SvgPicture.asset(arkaPlan, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, olcu) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: olcu.maxHeight - 80),
                  child: Center(
                    child: ConstrainedBox(
                      // Tablet gibi geniş ekranlarda form çok uzamasın
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
