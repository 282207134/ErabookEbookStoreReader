import 'dart:async';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/app_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1600), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppState.instance.dark ? C.dark1 : Colors.white,
    body: SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset('assets/logo.png', width: 160, height: 160),
          const SizedBox(height: 24),
          Text(
            'Erabook',
            style: ts(
              40,
              weight: FontWeight.w800,
              color: AppState.instance.dark ? Colors.white : C.g900,
            ),
          ),
          const Spacer(),
          const SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(strokeWidth: 4),
          ),
          const SizedBox(height: 64),
        ],
      ),
    ),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = AppState.instance.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/welcome_bookshelf.png',
                  width: double.infinity,
                  height: (MediaQuery.sizeOf(context).height * .50).clamp(
                    280.0,
                    480.0,
                  ),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 120,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          dark ? C.dark1 : Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: ts(
                        32,
                        weight: FontWeight.w800,
                        color: dark ? Colors.white : C.g900,
                      ),
                      children: const [
                        TextSpan(text: 'Welcome to '),
                        TextSpan(
                          text: 'Erabook',
                          style: TextStyle(color: C.primary),
                        ),
                        TextSpan(text: ' 📙'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'The Number One Best Ebook Store & Reader Application in this Century',
                    textAlign: TextAlign.center,
                    style: ts(18, color: dark ? C.g400 : C.g800, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 8,
                        decoration: BoxDecoration(
                          color: C.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      for (var i = 0; i < 4; i++) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: C.g300,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/shell'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: dark ? Colors.white : C.g900,
                      side: BorderSide(color: dark ? C.dark4 : C.g300),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      textStyle: ts(16, weight: FontWeight.w700),
                    ),
                    icon: const Text(
                      'G',
                      style: TextStyle(
                        color: C.info,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    label: const Text('Continue with Google'),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    'Get Started',
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                  ),
                  const SizedBox(height: 16),
                  SoftButton(
                    'I Already Have an Account',
                    onTap: () => Navigator.pushNamed(context, '/signin'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
