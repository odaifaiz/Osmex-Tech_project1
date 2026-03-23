
import 'package:flutter/material.dart';
import '../../core/constants/route_constants.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.login:
        return MaterialPageRoute(builder: (_) =>  LoginScreen());
      case RouteConstants.signup:
        return MaterialPageRoute(builder: (_) =>  RegisterScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}