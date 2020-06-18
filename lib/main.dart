import 'package:flutter/material.dart';
import 'package:infection/route/home_screen.dart';
import 'package:infection/route/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infection',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.home,
     onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case Routes.home:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => HomeScreen(),
            );
            break;
          default:
            throw Exception("Unknown route name: ${settings.name}");
        }
     },
      supportedLocales: [
        const Locale("en"),
      ],
    );
  }
}