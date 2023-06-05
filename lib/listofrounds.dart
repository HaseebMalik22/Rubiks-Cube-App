import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/EditRoundResults.dart';
import 'package:rubikscube/database_roundhelper.dart';

class RoundsScreen extends StatefulWidget {
  @override
  _RoundsScreenState createState() => _RoundsScreenState();
}

class _RoundsScreenState extends State<RoundsScreen> {
  Future<List<Round>> _fetchRounds() async {
    List<Round> rounds = [];

    try {
      List<Map<String, dynamic>> roundData = await DatabaseRoundHelper.instance.getRounds();
      rounds = roundData.map((data) => Round.fromMap(data)).toList();
    } catch (e) {
      // Handle any errors that occurred while fetching rounds from the database
      print('Error fetching rounds: $e');
    }

    return rounds;
  }

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
        padding: const EdgeInsets.all(12.0),
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
          child: FutureBuilder<List<Round>>(
            future: _fetchRounds(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while fetching rounds
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Display an error message if there was an error fetching rounds
                return Center(child: Text('Error fetching rounds'));
              } else if (snapshot.hasData) {
                // Display the list of rounds
                List<Round> rounds = snapshot.data!;
                return ListView.builder(
                  itemCount: rounds.length,
                  itemBuilder: (context, index) {
                    final round = rounds[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRoundResults(round: round),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(round.name),
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Display a message if there are no rounds
                return Center(child: Text('No rounds found'));
              }
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

  Round({
    required this.id,
    required this.name,
  });

  factory Round.fromMap(Map<String, dynamic> map) {
    return Round(
      id: map['id'],
      name: map['roundName'],
    );
  }
}
