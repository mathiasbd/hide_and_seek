// user.dart
import 'dart:math';

class User {
  String name;
  String? id;

  // Constructor
  User(this.name) {
    this.id = generateUniqueId();
  }


  String generateUniqueId() {
    var random = Random();
    var randomNumber = 1000 + random.nextInt(8999);
    return '$name$randomNumber';
  }

  // Method to print user details
  void printDetails() {
    print('Name: $name, id: $id');
  }
}
