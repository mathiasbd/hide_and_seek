import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:hide_and_seek/pages/create_match.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:hide_and_seek/pages/join_match.dart';
import '../classes/User.dart';
import '../custom_widgets.dart'; // Ensure this import is correct

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController firestoreController = FirestoreController(instance: firestore);

    void handleNavigation(String role) {
      if (_formKey.currentState!.validate()) {
        String name = myController.text;
        User user = User(name, context, role);
        myController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => role == 'Admin'
                  ? CreateMatch(user: user)
                  : JoinMatch(user: user)),
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _backgroundImage(),
          _title(),
          _mainContent(context, myController, handleNavigation),
        ],
      ),
    );
  }

  Widget _backgroundImage() => Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/GeoChaser.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      );

  Widget _title() => const Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Text(
            'GeoChaser',
            style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Oswald'),
          ),
        ),
      );

  Widget _mainContent(BuildContext context, TextEditingController myController, Function(String) handleNavigation) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: customTextField(
                controller: myController,
                hintText: 'Player Name',
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
            ),
            SizedBox(height: 100.0),
            customActionButton(
              context: context,
              text: 'Create Match',
              onPressed: () => handleNavigation('Admin'),
            ),
            SizedBox(height: 30.0),
            customActionButton(
              context: context,
              text: 'Join Match',
              onPressed: () => handleNavigation('Standard'),
            ),
          ],
        ),
      );
}