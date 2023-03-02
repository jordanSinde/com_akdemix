import 'package:com_akdemix/main.dart';
import 'package:com_akdemix/src/features/authentication/screens/sign_in_countries_page.dart';
import 'package:com_akdemix/src/features/authentication/screens/sign_in_phone_page.dart';
import 'package:com_akdemix/src/features/authentication/screens/sign_in_verification_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const startupPage = '/startup-page';
  static const countriesPage = '/countries-page';
  static const signInPhonePage = '/sign-in-phone-page';
  static const signInVerificationPage = '/sign-in-verification-page';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.startupPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const StartupPage(),
          settings: settings,
        );
      case AppRoutes.countriesPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const CountriesPage(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.signInPhonePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SignInPhonePageBuilder(),
          settings: settings,
        );
      case AppRoutes.signInVerificationPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SignInVerificationPageBuilder(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
