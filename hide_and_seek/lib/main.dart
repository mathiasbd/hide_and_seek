import 'package:flutter/material.dart';
import 'package:hide_and_seek/create_match.dart';
import 'package:hide_and_seek/firestore_controller.dart';
import 'package:hide_and_seek/hider_page.dart';
import 'package:hide_and_seek/home_screen.dart';
import 'package:hide_and_seek/join_match.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'user.dart';
import 'home_screen.dart';
import 'join_match.dart';
import 'lobby.dart';


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
      child: MyApp(),
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
        '/create_match': (context) => CreateMatch(),
        '/join_match': (context) => JoinMatch(),
        '/lobby': (context) => Lobby(),
        '/hider_page': (context) => HiderPage(),
      },
    );
      
  }
}



