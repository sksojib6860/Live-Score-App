import 'package:flutter/material.dart';

import '../model/football_matches.dart';

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({
    super.key,
    required List<FootballMathes> footballMatches,
  }) : _footballMatches = footballMatches;

  final List<FootballMathes> _footballMatches;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
    );
  }
}
