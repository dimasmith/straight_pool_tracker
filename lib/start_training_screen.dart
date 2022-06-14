import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straight_pool_tracker/model/training.dart';

class StartTrainingScreen extends StatelessWidget {
  const StartTrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Trainings>(
      builder: (context, trainings, _) => Scaffold(
          appBar: AppBar(
            title: const Text("Straight Pool Training"),
          ),
          body: Center(
            child: buildActions(trainings, context),
          )
      ),
    );
  }

  ElevatedButton buildActions(Trainings trainings, BuildContext context) {
    if (trainings.isRunning()) {
      return ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/training");
          },
          child: const Text("Resume Training"));
    }
    return ElevatedButton(
            child: const Text("Start Training"),
            onPressed: () {
              trainings.start();
              Navigator.pushNamed(context, "/training");
            },
          );
  }
}

