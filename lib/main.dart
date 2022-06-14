import 'package:flutter/material.dart';
import 'package:straight_pool_tracker/model/training.dart';
import 'package:straight_pool_tracker/start_training_screen.dart';
import 'package:straight_pool_tracker/training_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Trainings>(create: (context) => Trainings()),
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
        "/training": (context) => ChangeNotifierProvider<Training>.value(
          value: context.read<Trainings>().current() as Training,
          child: const TrainingScreen()),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
        scaffoldBackgroundColor: Colors.green.shade200
      ),
    );
  }
}
