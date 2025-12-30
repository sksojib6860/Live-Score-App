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
  // Future<void> _getData() async {
  //   _footballMatches.clear();
  //   QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
  //       .collection('football')
  //       .get();
  //   for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
  //     _footballMatches.add(FootballMathes.fromJson(doc.data()));
  //   }
  //   setState(() {});
  // }
  //
  // @override
  // void initState() {
  //   _getData();
  //   super.initState();
  // }

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
    );
  }
}
