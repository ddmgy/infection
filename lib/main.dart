import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:infection/route/fade_transition_page_route.dart';
import 'package:infection/route/game_arguments.dart';
import 'package:infection/route/game_screen.dart';
import 'package:infection/route/home_screen.dart';
import 'package:infection/route/routes.dart';
import 'package:infection/route/setup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
            return FadeTransitionPageRoute(
              settings: settings,
              builder: (_) => HomeScreen(),
            );
            break;
          case Routes.setup:
            return FadeTransitionPageRoute(
              settings: settings,
              builder: (_) => SetupScreen(),
            );
            break;
          case Routes.game:
            GameArguments argument = settings.arguments;
            return FadeTransitionPageRoute(
              settings: settings,
              builder: (_) => GameScreen(
                columns: argument.columns,
                rows: argument.rows,
                players: argument.players,
              ),
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