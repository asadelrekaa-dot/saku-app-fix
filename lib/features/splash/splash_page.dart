import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.onFinished,
    this.duration = const Duration(milliseconds: 2500), // Sesuaikan dengan durasi GIF kamu
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
    // Timer tetap digunakan untuk memicu callback setelah durasi GIF selesai
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
        backgroundColor: SakuColors.blue100, // Sesuaikan dengan background GIF agar mulus
        body: SafeArea(
          child: Center(
            child: Image.asset(
              'assets/splash_animation.gif',
              width: 200, // Sesuaikan ukuran lebar GIF kamu
              height: 200, // Sesuaikan ukuran tinggi GIF kamu
              fit: BoxFit.contain,
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