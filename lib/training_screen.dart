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
      // bottomNavigationBar: const CurrentInningBottomBar(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {Provider.of<Training>(context, listen: false).pot()},
      //   child: const Icon(Icons.plus_one_outlined),
      // ),
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
            const CardTitle(title: "Score", icon: Icons.scoreboard),
            Center(
              child: Score(score: training.score()),
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
                  crossAxisCount: 5,
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
    Color textColor = inning.hasFoul() ? Colors.red : Colors.black;
    return Center(
      child: Text(
        "${inning.score()}",
        style: TextStyle(fontSize: 32.0, color: textColor),
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
                ElevatedButton(
                    onPressed: () => {training.undo()},
                    child: const Icon(Icons.undo)),
                ElevatedButton(
                    onPressed: () => {training.foul()},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red.shade100)),
                    child: const Text("Foul")),
                ElevatedButton(
                    onPressed: () => {training.miss()},
                    child: const Text("Miss")),
                ElevatedButton(
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

class CurrentInningBottomBar extends StatelessWidget {
  const CurrentInningBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Training>(builder: (context, training, child) {
      return BottomAppBar(
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            children: [
              IconButton(
                  onPressed: () => {training.undo()},
                  icon: const Icon(Icons.undo_outlined)),
              IconButton(
                  onPressed: () => {training.pot()},
                  icon: const Icon(Icons.plus_one_outlined)),
              IconButton(
                  onPressed: () => {training.foul()},
                  icon: const Icon(Icons.cancel_outlined)),
              IconButton(
                  onPressed: () => {training.miss()},
                  icon: const Icon(Icons.safety_check_outlined)),
            ],
          ),
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
            "$title",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }
}
