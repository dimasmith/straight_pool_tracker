import 'package:flutter/material.dart';
import 'package:straight_pool_tracker/auth/auth.dart';
import 'package:straight_pool_tracker/model/training.dart';
import 'package:straight_pool_tracker/start_training_screen.dart';
import 'package:straight_pool_tracker/training_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Training()),
      ChangeNotifierProvider(create: (context) => Authentication()),
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
