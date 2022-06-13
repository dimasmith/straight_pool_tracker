import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Authentication extends ChangeNotifier {
  User? _user;

  Authentication() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = user;
        notifyListeners();
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  bool authenticated() {
    return _user != null;
  }
}
