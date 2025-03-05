import 'package:flutter/material.dart';
import 'presentation/screens/welcome_screen.dart';
import 'presentation/screens/catalog_screen.dart';
import 'presentation/screens/popular_screen.dart';

class AppRouter {
  static const String welcomeScreen = '/';
  static const String catalogScreen = '/catalog';
  static const String popularScreen = '/popular';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print("Routing to: ${settings.name}");
    switch (settings.name) {
      case welcomeScreen:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
      case catalogScreen:
        return MaterialPageRoute(
          builder: (_) => const CatalogScreen(),
        );
      case popularScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            const PopularScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
    }
  }
}