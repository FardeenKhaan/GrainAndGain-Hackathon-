import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/utils/constants/image_strings.dart';

// class LoginView extends StatelessWidget {
//   final AuthController _authController = Get.find<AuthController>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   LoginView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(
//           () => _authController.isLoading.value
//               ? const Center(child: CircularProgressIndicator())
//               : Column(
//                   children: [
//                     TextField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(labelText: "Email"),
//                     ),
//                     TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: const InputDecoration(labelText: "Password"),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         _authController.signIn(_emailController.text.trim(), _passwordController.text.trim());
//                       },
//                       child: const Text("Login"),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Get.toNamed(FkRoutes.signUp); // navigate to signup
//                       },
//                       child: const Text("Don't have an account? Sign Up"),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }

class LoginView extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final RxBool _obscurePassword = true.obs;

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Obx(
        () => _authController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// 🔹 Logo / Illustration
                    // Icon(Icons.vpn_key_rounded, size: 100, color: theme.colorScheme.primary),
                    Image.asset(FkImages.splashLogo, height: 120, width: double.infinity),
                    const SizedBox(height: 20),

                    /// 🔹 Title & Subtitle
                    Text(
                      "Welcome Back 👋",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to continue using Grain & Gain",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 40),

                    /// 🔹 Email Field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        labelText: "Email",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// 🔹 Password Field,
                    Obx(
                      () => TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: "Password",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
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
                    const SizedBox(height: 24),

                    /// 🔹 Login Button
                    ElevatedButton(
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text("Login", style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),

                    /// 🔹 Sign Up Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(onPressed: () => Get.toNamed(FkRoutes.signUp), child: const Text("Sign Up")),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
