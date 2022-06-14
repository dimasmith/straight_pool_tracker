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
          body: ButtonMenu(children: [
            buildActions(trainings, context),
          ])),
    );
  }

  Widget buildActions(Trainings trainings, BuildContext context) {
    return trainings.isRunning()
        ? MenuButton(
            onPressed: () {
              Navigator.pushNamed(context, '/training');
            },
            child: const Text('Resume Training'),
          )
        : MenuButton(
            onPressed: () {
              trainings.start();
              Navigator.pushNamed(context, '/training');
            },
            child: const Text('Start Training'),
          );
  }
}

class ButtonMenu extends StatelessWidget {
  final List<Widget> children;

  const ButtonMenu({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;

  const MenuButton({Key? key, this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
