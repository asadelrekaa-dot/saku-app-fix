import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.onFinished,
    this.duration = const Duration(milliseconds: 5800), // Sesuaikan dengan durasi GIF kamu
  });

  static const routeName = '/splash';

  final VoidCallback onFinished;
  final Duration duration;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, widget.onFinished);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const BrightnessAwareOverlay(),
      child: Scaffold(
        backgroundColor: SakuColors.blue100, // Pastikan warna ini sama persis dengan background GIF kamu
        body: SizedBox.expand( // Membantu memastikan child mengisi seluruh ruang yang tersedia
          child: Center(
            child: Image.asset(
              'assets/animation.gif',
              width: double.infinity, // Mengikuti lebar layar atau container
              height: double.infinity, // Mengikuti tinggi layar atau container
              fit: BoxFit.contain, // Gunakan BoxFit.cover jika ingin GIF memenuhi layar penuh tanpa border warna background
            ),
          ),
        ),
      ),
    );
  }
}

class BrightnessAwareOverlay extends SystemUiOverlayStyle {
  const BrightnessAwareOverlay()
      : super(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        );
}