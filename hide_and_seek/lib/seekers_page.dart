import 'package:flutter/material.dart';
import 'maps_page.dart';
import 'my_colors.dart';

class SeekersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.fourthColor,
      appBar: AppBar(
        title: Text('Seekers Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Catch Sound'),
              onPressed: () {
                // Add your functionality here
              },
            ),
            ElevatedButton(
              child: Text('Location'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapsPage()),
                );
              },
            ),
            ElevatedButton(
              child: Text('kill'),
              onPressed: () {
                // Add your functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}
