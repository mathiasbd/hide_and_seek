import 'package:flutter/material.dart';
import 'maps_page.dart';
import 'my_colors.dart';

class HiderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.fourthColor,
      appBar: AppBar(
        title: Text('Hiders Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Location'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
