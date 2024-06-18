import 'dart:math';

enum UserType { Hider, Seeker }

class User {
  String name;
  String id = '';
  UserType? userType;

  User(this.name) {
    id = _generateUniqueId();
  }

  String _generateUniqueId() {
    var random = Random();
    var randomNumber = 1000 + random.nextInt(9000);
    return '$name$randomNumber';
  }

  void useAbility() {
    if (userType == UserType.Hider) {
      print('$name uses hiding ability!');
    } else if (userType == UserType.Seeker) {
      print('$name uses seeking ability!');
    } else {
      print('$name has no assigned role yet.');
    }
  }

  void printDetails() {
    print('Name: $name, ID: $id, Type: ${userType?.toString() ?? "None"}');
  }
}