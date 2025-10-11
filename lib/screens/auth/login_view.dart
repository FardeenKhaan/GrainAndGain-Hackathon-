import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/utils/constants/colors.dart';
import 'package:grain_and_gain_student/utils/constants/image_strings.dart';
import 'package:grain_and_gain_student/utils/constants/sizes.dart';
import 'package:grain_and_gain_student/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class LoginView extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final RxBool _obscurePassword = true.obs;
  LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final isDarkMode = FkHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Logo / Illustration
            Image.asset(
              FkImages.splashLogo,
              height: FkSizes.imageThumbSize * 1.5,
              width: double.infinity,
              alignment: Alignment.bottomLeft,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FkSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --- Title & Subtitle
                  Text(
                    "Welcome Back 👋",
                    textAlign: TextAlign.center,
                    style: TextTheme.of(context).headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: FkSizes.sm),
                  Text(
                    "Login to continue using Grain & Gain",
                    textAlign: TextAlign.center,
                    style: TextTheme.of(context).bodyMedium?.copyWith(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: FkSizes.spaceBtwSections),

                  /// --- Email Field
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.sms),
                      labelText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(FkSizes.borderRadiusLg)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// --- Password Field,
                  Obx(
                    () => TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(FkSizes.borderRadiusLg)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            _obscurePassword.value = !_obscurePassword.value;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: FkSizes.lg),

                  /// --- Login Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar("Error", "Email & Password are required");
                          return;
                        }

                        _authController.signIn(email, password);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: FkSizes.md, horizontal: FkSizes.buttonWidth),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Obx(
                        () => SizedBox(
                          width: FkSizes.buttonWidth, //  keep width fixed
                          height: FkSizes.buttonHeight * 1.5, // match indicator height
                          child: Center(
                            child: _authController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: FkColors.white),
                                  )
                                : const Text("Login", style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: FkSizes.md),

                  /// --- Sign Up Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: TextTheme.of(context).titleSmall),
                      TextButton(
                        onPressed: () => Get.toNamed(FkRoutes.signUp),
                        child: Text(
                          "Sign Up",
                          style: TextTheme.of(context).titleSmall!.copyWith(color: FkColors.primary),
                        ),
                      ),
                    ],
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
