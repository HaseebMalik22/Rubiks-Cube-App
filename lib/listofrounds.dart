import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/EditRoundResults.dart';

class RoundsScreen extends StatefulWidget {
  @override
  _RoundsScreenState createState() => _RoundsScreenState();
}

class _RoundsScreenState extends State<RoundsScreen> {
  List<Round> _rounds = [
    Round(id: 1, name: 'Round 1', participants: 10),
    Round(id: 2, name: 'Round 2', participants: 22),
    Round(id: 3, name: 'Round 3', participants: 30),
    Round(id: 4, name: 'Round 4', participants: 55),
    Round(id: 5, name: 'Round 5', participants: 28),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Rounds'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement your logout logic here
              // For example, you can navigate to the home screen

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );

            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: _rounds.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditRoundResults(round: _rounds[index]),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(_rounds[index].name),
                    subtitle: Text('${_rounds[index].participants} participants'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Round {
  final int id;
  final String name;
  final int participants;

  Round({
    required this.id,
    required this.name,
    required this.participants,
  });
}
