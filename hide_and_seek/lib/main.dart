import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase/firebase_options.dart';
import 'classes/User.dart';

import 'package:hide_and_seek/pages/create_match.dart';
import 'package:hide_and_seek/pages/hider_page.dart';
import 'package:hide_and_seek/pages/home_screen.dart';
import 'package:hide_and_seek/pages/join_match.dart';
import 'pages/lobby_page.dart';
import 'pages/seekers_page.dart';

// Define route names as constants
class Routes {
  static const home = '/';
  static const lobbyPage = 'lobby_page';
  static const createMatch = 'create_match';
  static const joinMatch = 'join_match';
  static const hiderPage = 'hider_page';
  static const seekerPage = 'seeker_page';
}


// initialize Firebase and Firestore and then run the app

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
  runApp(
    Provider.value(
      value: FirebaseFirestore.instance,
      child: const MyApp(),
    ),
  );
}

// Define the main app widget

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => HomeScreen(),
      },
      onGenerateRoute: _generateRoute,
    );
  }

  // Generate routes based on route name and arguments

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    if (settings.arguments is! Map<String, dynamic>) {
      debugPrint('Invalid route arguments');
      return null;
    }
    final args = settings.arguments as Map<String, dynamic>;

    switch (settings.name) {
      case Routes.lobbyPage:
        final user = args['user'] as User;
        return MaterialPageRoute(
          builder: (context) => Lobby(matchName: args['matchName'], user: user),
        );
      case Routes.createMatch:
      case Routes.joinMatch:
      case Routes.hiderPage:
      case Routes.seekerPage:
        final user = args['user'] as User;
        return MaterialPageRoute(
          builder: (context) => _getPageForRoute(settings.name!, user, args['matchName']),
        );
      default:
        return null;
    }
  }

  // Helper function to return the correct page based on the route name

  Widget _getPageForRoute(String routeName, User user, String? matchName) {
    switch (routeName) {
      case Routes.createMatch:
        return CreateMatch(user: user);
      case Routes.joinMatch:
        return JoinMatch(user: user);
      case Routes.hiderPage:
        return HiderPage(user: user, matchName: matchName!);
      case Routes.seekerPage:
        return SeekerPage(user: user, matchName: matchName!);
      default:
        throw Exception('Invalid route: $routeName');
    }
  }
}