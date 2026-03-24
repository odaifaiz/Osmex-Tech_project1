import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/otp_verification_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CityFixApp());
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      name: 'otp',
      builder: (_, __) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (_, __) => const RegisterScreen(),
    ),
  ],
);

class CityFixApp extends StatelessWidget {
  const CityFixApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp.router(
  debugShowCheckedModeBanner: false,
  title: 'CityFix',
  theme: AppTheme.darkTheme,
  
  locale: const Locale('ar'), 
  supportedLocales: const [Locale('ar')],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],

  
  builder: (context, child) {
   
    return Directionality(
      textDirection: TextDirection.rtl,
      child: child!,
    );
  },

  routerConfig: _router,
);
  }
}
