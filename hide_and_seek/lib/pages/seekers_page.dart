import 'package:flutter/material.dart';
import 'maps_page.dart';
import '../my_colors.dart';
import '../classes/abillity.dart';

class SeekerPage extends StatelessWidget {

  final Ability getHiderLocationsAbility = Ability('Get Hider Locations');
  final Ability catchHiderAbility = Ability('Catch Hider');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 95, 188, 255),
      appBar: AppBar(
        title: const Text('Seeker'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
          fontFamily: 'Oswald',
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}
