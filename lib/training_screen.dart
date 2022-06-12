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
                  Provider.of<Training>(context, listen: false).finish();
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
      bottomNavigationBar: const CurrentInningBottomBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Provider.of<Training>(context, listen: false).pot()},
        child: const Icon(Icons.plus_one_outlined),
      ),
    );
  }
}

class TrainingStats extends StatelessWidget {
  const TrainingStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Training>(builder: (context, training, child) {
      return Center(
        child: Text(
          "${training.score()}",
          style: const TextStyle(fontSize: 48.0),
        ),
      );
    });
  }
}

class InningsGrid extends StatelessWidget {
  const InningsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Training>(builder: (context, training, child) {
      return Expanded(
        child: GridView.count(
          crossAxisCount: 5,
          children: training
              .innings()
              .map((inning) => InningGridTile(inning: inning))
              .toList(),
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
      return Column(
        children: [
          Text(
            "${training.currentInning().score()}",
            style: const TextStyle(fontSize: 64.0),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => {training.foul()},
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  child: const Text("Foul")),
              ElevatedButton(
                  onPressed: () => {training.miss()},
                  child: const Text("Miss")),
            ],
          )
        ],
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
        color: Colors.green,
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
