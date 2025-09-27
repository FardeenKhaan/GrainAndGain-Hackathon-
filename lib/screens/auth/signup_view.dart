import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain_and_gain_student/controllers/auth_controller.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/utils/constants/image_strings.dart';

class SignupView extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 👁️ For showing/hiding password
  final RxBool _obscurePassword = true.obs;

  // Role selection
  final RxString _selectedRole = 'student'.obs; // default

  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(
        () => _authController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(FkImages.splashLogo, height: 120, width: double.infinity),
                    const SizedBox(height: 20),

                    Text(
                      "Create Account 🚀",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign up to start using Grain&Gain",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),

                    /// Role selector (Student / Restaurant)
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: const Text("Student"),
                            selected: _selectedRole.value == 'student',
                            onSelected: (v) {
                              if (v) _selectedRole.value = 'student';
                            },
                          ),
                          const SizedBox(width: 12),
                          ChoiceChip(
                            label: const Text("Restaurant"),
                            selected: _selectedRole.value == 'restaurant',
                            onSelected: (v) {
                              if (v) _selectedRole.value = 'restaurant';
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Name Field
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline),
                        labelText: _selectedRole.value == 'restaurant' ? "Restaurant Name" : "Full Name",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Email Field
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

                    /// Password Field
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

                    /// Sign Up Button
                    ElevatedButton(
                      onPressed: () {
                        final name = _nameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        final role = _selectedRole.value;

                        if (name.isEmpty || email.isEmpty || password.isEmpty) {
                          Get.snackbar("Error", "All fields are required");
                          return;
                        }
                        if (password.length < 6) {
                          Get.snackbar("Error", "Password must be at least 6 characters");
                          return;
                        }

                        _authController.signUp(email, password, name, role);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),

                    /// Login Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(onPressed: () => Get.toNamed(FkRoutes.logIn), child: const Text("Login")),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
