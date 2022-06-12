import 'package:flutter/material.dart';

class StartTrainingScreen extends StatelessWidget {
  const StartTrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Straight Pool Training"),
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text("Start Training"),
            onPressed: () {
              Navigator.pushNamed(context, "/training");
            },
          ),
        )
    );
  }
}

