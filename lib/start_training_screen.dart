import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:straight_pool_tracker/auth/auth.dart';
import 'auth/google_auth.dart';
import 'package:provider/provider.dart';

class StartTrainingScreen extends StatelessWidget {
  const StartTrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Authentication>(builder: (context, auth, child) {
      IconButton profileButton = (auth.authenticated())
          ? IconButton(onPressed: () => {signOut()}, icon: const Icon(Icons.logout))
          : IconButton(onPressed: () => {signIn()}, icon: const Icon(Icons.login));

      return Scaffold(
          appBar: AppBar(
            title: const Text("Straight Pool Training"),
            actions: [
              profileButton
            ],
          ),
          body: Center(
            child: ElevatedButton(
              child: const Text("Start Training"),
              onPressed: () {
                Navigator.pushNamed(context, "/training");
              },
            ),
          ));
    });

  }
}
