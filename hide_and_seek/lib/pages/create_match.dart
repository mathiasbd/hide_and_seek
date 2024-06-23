import 'package:flutter/material.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/User.dart';
import 'lobby_page.dart';
import '../custom_widgets.dart';

class CreateMatch extends StatefulWidget {
  final User user;

  const CreateMatch({Key? key, required this.user}) : super(key: key);

  @override
  _CreateMatchState createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  late TextEditingController myController;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    myController = TextEditingController();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController firestoreController = FirestoreController(instance: firestore);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 188, 255),
      appBar: AppBar(
        title: const Text('Create Match'),
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
        child: isLoading
            ? CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    customTextField(
                      controller: myController,
                      hintText: 'Enter match name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a match name';
                        }
                        return null;
                      },
                    ),
                    customActionButton(
                      context: context,
                      text: 'Create',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          createAndAdd(firestoreController);
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> createAndAdd(FirestoreController firestoreController) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await firestoreController.createMatch(myController.text);
        await firestoreController.joinMatch(myController.text, widget.user.toMap());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Lobby(matchName: myController.text, user: widget.user)),
        );
      } catch (e) {
        // Handle errors if necessary, possibly with an error dialog instead of a SnackBar
      } finally {
        setState(() => isLoading = false);
      }
    }
  }
}