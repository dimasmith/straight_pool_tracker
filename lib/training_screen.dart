import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straight_pool_tracker/start_training_screen.dart';

import 'model/training.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Straight Pool Training"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return const ConfirmFinishTrainingDialog();
                    }).then((finish) {
                  if (finish != null && finish) {
                    Provider.of<Trainings>(context, listen: false).finish();
                    Navigator.pop(context);
                  }
                });
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Column(
        children: const [
          TrainingStats(),
          InningsGrid(),
          CurrentInning(),
        ],
      ),
    );
  }
}

class ConfirmFinishTrainingDialog extends StatelessWidget {
  const ConfirmFinishTrainingDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        ButtonMenu(children: [
          Text(
            "Finish Training?",
            style: Theme.of(context).textTheme.headline6,
          ),
          MenuButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Finish"),
          ),
          MenuButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Continue"),
          ),
        ])
      ],
    );
  }
}

class TrainingStats extends StatelessWidget {
  const TrainingStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Training>(builder: (context, training, child) {
      return Card(
        child: Column(
          children: [
            const CardTitle(title: "Stats", icon: Icons.scoreboard),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Score",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Score(score: training.score()),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Innings",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Score(score: training.countInnings() - 1),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Fouls",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Score(score: training.countFouls()),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class Score extends StatelessWidget {
  const Score({
    Key? key,
    required this.score,
  }) : super(key: key);
  final int score;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${score}",
      style: Theme.of(context).textTheme.headline2,
    );
  }
}

class InningsGrid extends StatelessWidget {
  const InningsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Training>(builder: (context, training, child) {
      return Expanded(
        child: Card(
          child: Column(
            children: [
              const CardTitle(title: "Innings", icon: Icons.add_chart),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 6,
                  children: training
                      .innings()
                      .map((inning) => InningGridTile(inning: inning))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class InningGridTile extends StatelessWidget {
  final Inning inning;

  const InningGridTile({super.key, required this.inning});

  @override
  Widget build(BuildContext context) {
    Color tileColor =
        (inning.hasFoul()) ? Colors.red.shade50 : Colors.green.shade50;
    if (inning.pending()) {
      tileColor = Colors.transparent;
    }
    String text = (inning.pending()) ? "" : inning.score().toString();

    return Container(
      color: tileColor,
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}

class CurrentInning extends StatelessWidget {
  const CurrentInning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Training>(builder: (context, training, child) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CardTitle(
              title: "Current Inning",
              icon: Icons.scoreboard_outlined,
            ),
            Center(
              child: Score(score: training.currentInning().score()),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                InningActionButton(
                    onPressed: () => {training.undo()},
                    child: const Icon(Icons.undo)),
                InningActionButton(
                    onPressed: () => {training.foul()},
                    error: true,
                    child: const Text("Foul")),
                InningActionButton(
                    onPressed: () => {training.miss()},
                    child: const Text("Miss")),
                InningActionButton(
                    onPressed: () => {training.pot()},
                    child: const Text("Pot")),
              ],
            )
          ],
        ),
      );
    });
  }
}

class CardTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const CardTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 40.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }
}

class InningActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final bool error;

  const InningActionButton({Key? key, this.onPressed, this.child, this.error = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialStateProperty<Color?>? color =
        Theme.of(context).elevatedButtonTheme.style?.backgroundColor;
    if (error) {
      color = MaterialStateProperty.all<Color>(Colors.red.shade100);
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(backgroundColor: color),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
