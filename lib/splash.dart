import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:grain_and_gain_student/utils/constants/image_strings.dart';
import 'package:grain_and_gain_student/utils/helpers/helper_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<void> _navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null && session.user != null) {
      final authController = Get.find<AuthController>();
      await authController.loadProfile(session.user.id);

      final user = authController.currentUser.value;

      if (user != null) {
        if (user.role == 'student') {
          Get.offNamed(FkRoutes.studentDashboard); // student dashboard
        } else if (user.role == 'restaurant') {
          Get.offNamed(FkRoutes.restaurantDashboard); // restaurant dashboard
        } else {
          // fallback → maybe later add "admin"
          Get.offNamed(FkRoutes.studentDashboard);
        }
      } else {
        Get.offNamed(FkRoutes.logIn);
      }
    } else {
      Get.offNamed(FkRoutes.logIn);
    }
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
