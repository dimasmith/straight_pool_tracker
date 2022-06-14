import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                {
                  Provider.of<Trainings>(context, listen: false).finish();
                  Navigator.pop(context);
                }
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
    Key? key, required this.score,
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
                    child: Icon(Icons.undo)),
                ElevatedButton(
                    onPressed: () => {training.foul()},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red.shade100)),
                    child: Text("Foul")),
                ElevatedButton(
                    onPressed: () => {training.miss()}, child: Text("Miss")),
                ElevatedButton(
                    onPressed: () => {training.pot()}, child: Text("Pot")),
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
