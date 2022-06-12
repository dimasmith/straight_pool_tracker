import 'package:flutter/material.dart';
import 'package:straight_pool_tracker/model/training.dart';
import 'package:straight_pool_tracker/start_training_screen.dart';
import 'package:straight_pool_tracker/training_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Training()),
    ],
    child: const StraightPoolTrainingApp(),
  ));
}

class StraightPoolTrainingApp extends StatelessWidget {
  const StraightPoolTrainingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Straight Pool Training',
      initialRoute: "/",
      routes: {
        "/": (context) => const StartTrainingScreen(),
        "/training": (context) => const TrainingScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
