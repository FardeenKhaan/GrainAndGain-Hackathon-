import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:grain_and_gain_student/routers/routes.dart';
import 'package:grain_and_gain_student/screens/auth/login_view.dart';
import 'package:grain_and_gain_student/screens/auth/signup_view.dart';
import 'package:grain_and_gain_student/screens/dashboards/restaurant_owner_dashboard.dart';
import 'package:grain_and_gain_student/screens/dashboards/student_dashboard.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: FkRoutes.logIn, page: () => LoginView()),
    GetPage(name: FkRoutes.signUp, page: () => SignupView()),
    GetPage(name: FkRoutes.dashboard, page: () => DashboardView()),
    GetPage(name: FkRoutes.restaurantDashboard, page: () => RestaurantDashboardView()),
  ];
}
