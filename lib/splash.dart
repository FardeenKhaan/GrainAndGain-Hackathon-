import 'dart:async';

import 'package:code_cheat_app/routes/routes.dart';
import 'package:code_cheat_app/utils/constants/colors.dart';
import 'package:code_cheat_app/utils/constants/image_strings.dart';
import 'package:code_cheat_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the blinking effect
    _startBlinking();
    // Navigate to HomeScreen after 5 seconds
    _navigateToHomeScreen();
  }

  void _startBlinking() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (timer.tick <= 10) {
        // Blink for 2 seconds (4 ticks of 500ms)
        setState(() {
          _visible = !_visible;
        });
      } else {
        timer.cancel();
        setState(() {
          _visible = true; // Ensure logo is visible after blinking
        });
      }
    });
  }

  void _navigateToHomeScreen() {
    Future.delayed(const Duration(seconds: 1), () {
      Get.offNamed(FkRoutes.navigation);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = FkHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: darkMode ? FkColors.black : FkColors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Image.asset(FkImages.splashLogo, height: 256, width: 256),
        ),
      ),
    );
  }
}
