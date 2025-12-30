import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/model/football_matches.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<FootballMathes> _footballMatches = [];
  Future<void> _getData() async {
    _footballMatches.clear();
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('football')
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      _footballMatches.add(FootballMathes.fromJson(doc.data()));
    }
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Score App')),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final footballMatch = _footballMatches[index];
          return ListTile(
            title: Text(
              '${footballMatch.team1Name} VS ${footballMatch.team2Name}',
            ),
            subtitle: Text('Winner Team: ${footballMatch.winnerTeam}'),
            trailing: Text(
              '${footballMatch.team1Score}:${footballMatch.team2Score}',
              style: TextTheme.of(context).titleMedium,
            ),
            leading: CircleAvatar(
              radius: 10,
              backgroundColor: footballMatch.isRunning
                  ? Colors.green
                  : Colors.blueGrey,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: _footballMatches.length,
      ),
    );
  }
}
