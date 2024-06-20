import 'package:flutter/material.dart';
import 'package:hide_and_seek/pages/create_match.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:hide_and_seek/pages/hider_page.dart';
import 'package:hide_and_seek/pages/home_screen.dart';
import 'package:hide_and_seek/pages/join_match.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase/firebase_options.dart';
import 'classes/User.dart';
import 'pages/home_screen.dart';
import 'pages/join_match.dart';
import 'pages/lobby.dart';

void main() async {
  //Find ud af om det stateless eller andet
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(
    Provider.value(
      value: FirebaseFirestore.instance,
      child: const MyApp(),
    ),
  );
}

@override
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'lobby':
            final args = settings.arguments as Map<String, dynamic>;
            final matchName = args['matchName'];
            final user = args['user'] as User;

            return MaterialPageRoute(
              builder: (context) => Lobby(matchName: matchName, user: user),
            );
          case 'create_match':
            final args = settings.arguments as Map<String, dynamic>;
            final user = args['user'] as User;

            return MaterialPageRoute(
              builder: (context) => CreateMatch(user: user),
            );
          case 'join_match':
            final args = settings.arguments as Map<String, dynamic>;
            final user = args['user'] as User;

            return MaterialPageRoute(
              builder: (context) => JoinMatch(user: user),
            );
          case 'hider_page':
            final args = settings.arguments as Map<String, dynamic>;
            final user = args['user'] as User;

            return MaterialPageRoute(
              builder: (context) => HiderPage(user: user),
            );
          default:
            return null;
        }
      }
    );
  }
}
