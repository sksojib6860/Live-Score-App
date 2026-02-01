import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/model/football_matches.dart';

import '../widget/separetor_listview_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<FootballMathes> _footballMatches = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController name1Controller = TextEditingController();
  TextEditingController name2Controller = TextEditingController();
  TextEditingController score1Controller = TextEditingController();
  TextEditingController score2Controller = TextEditingController();
  TextEditingController winnerController = TextEditingController();
  TextEditingController isRunningController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Score App')),
      body: StreamBuilder(
        stream: _firestore.collection('football').snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(child: Text('${asyncSnapshot.error}'));
          }
          if (asyncSnapshot.hasData) {
            _footballMatches.clear();
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in asyncSnapshot.data!.docs) {
              _footballMatches.add(FootballMathes.fromJson(doc.data()));
            }
            return ListViewBuilder(footballMatches: _footballMatches);
          }
          return const Center(child: Text('No Data'));
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: showDialogAdd,
            child: Icon(Icons.add),
          ),
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.update)),
        ],
      ),
    );
  }

  Future<void> showDialogAdd() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Match"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: name1Controller,
                decoration: InputDecoration(labelText: 'Team 1 Name'),
              ),
              TextFormField(
                controller: name2Controller,
                decoration: InputDecoration(labelText: 'Team 2 Name'),
              ),
              TextFormField(
                controller: score1Controller,
                decoration: InputDecoration(labelText: 'Team 1 Score'),
              ),
              TextFormField(
                controller: score2Controller,
                decoration: InputDecoration(labelText: 'Team 2 Score'),
              ),
              TextFormField(
                controller: winnerController,
                decoration: InputDecoration(labelText: 'Winner Team'),
              ),
              TextFormField(
                controller: isRunningController,
                decoration: InputDecoration(labelText: 'Is Running'),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      mathAdd();
                      Navigator.pop(context);
                      clearText();
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> mathAdd() async {
    FootballMathes footballMathes = FootballMathes(
      team1Name: name1Controller.text,
      team2Name: name2Controller.text,
      team1Score: int.parse(score1Controller.text),
      team2Score: int.parse(score2Controller.text),
      winnerTeam: winnerController.text,
      isRunning: isRunningController.text == 'true' ? true : false,
    );
    await _firestore.collection('football').add(footballMathes.toJson());
  }

  void clearText() {
    name1Controller.clear();
    name2Controller.clear();
    score1Controller.clear();
    score2Controller.clear();
    winnerController.clear();
    isRunningController.clear();
  }
}
