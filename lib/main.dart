import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:grain_and_gain_student/bindings/app_bindings.dart';
import 'package:grain_and_gain_student/routers/app_routes.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/screens/auth/signup_view.dart';
import 'package:grain_and_gain_student/utils/constants/keys.dart';
import 'package:grain_and_gain_student/utils/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  /// Widgets Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Supabase
  await Supabase.initialize(
    url: FkKeys.supabaseUrl,
    anonKey: FkKeys.supabaseKey,
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 5),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      getPages: AppRoutes.pages,
      initialRoute: FkRoutes.signUp,
      themeMode: ThemeMode.system,
      theme: HkAppTheme.lightTheme,
      darkTheme: HkAppTheme.darkTheme,

      /// show loader or circular progress indicator meanwhile Authentication Repository
      /// is deciding to show relevant screen
      initialBinding: AppBindings(),
    );
  }
}
