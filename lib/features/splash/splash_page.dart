import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.onFinished,
    this.duration = const Duration(milliseconds: 1800),
  });

  static const routeName = '/splash';

  final VoidCallback onFinished;
  final Duration duration;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoSlide;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..forward();
    _scale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.46, curve: Curves.easeOutBack),
    ).drive(Tween<double>(begin: 0.84, end: 1));
    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.28, curve: Curves.easeOut),
    );
    _logoSlide = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.38, 0.72, curve: Curves.easeInOutCubic),
    ).drive(Tween<double>(begin: 0, end: -34));
    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.58, 0.92, curve: Curves.easeOut),
    );
    _textSlide = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.58, 1, curve: Curves.easeOutCubic),
    ).drive(
      Tween<Offset>(
        begin: const Offset(0.28, 0),
        end: Offset.zero,
      ),
    );
    _timer = Timer(widget.duration, widget.onFinished);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const BrightnessAwareOverlay(),
      child: Scaffold(
        backgroundColor: SakuColors.blue100,
        body: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: Offset(_logoSlide.value, 0),
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: ScaleTransition(
                          scale: _scale,
                          child: Image.asset(
                            'assets/splashscreen-animation.png',
                            width: 88,
                            height: 76,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(_logoSlide.value + 2, 0),
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: SlideTransition(
                          position: _textSlide,
                          child: const _SplashBrandText(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashBrandText extends StatelessWidget {
  const _SplashBrandText();

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'sa'),
          TextSpan(
            text: 'k',
            style: TextStyle(color: SakuColors.blue700),
          ),
          TextSpan(
            text: 'u',
            style: TextStyle(color: SakuColors.mango500),
          ),
        ],
      ),
      style: TextStyle(
        color: SakuColors.blue700,
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
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
