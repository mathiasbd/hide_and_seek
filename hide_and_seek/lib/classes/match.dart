import 'user.dart';
import 'dart:math';

class Match {
  List<User> users = [];

  void addUser(User user) {
    users.add(user);
  }

  void assignRoles() {
    var random = Random();
    int index = random.nextInt(users.length);

    for (int i = 0; i < users.length; i++) {
      if (i == index) {
        users[i].userType = UserType.Seeker;
      } else {
        users[i].userType = UserType.Hider;
      }
    }
  }

  void startMatch() {
    assignRoles();
  }
}