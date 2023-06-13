import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/database_roundhelper.dart';
import 'package:rubikscube/judgescan.dart';

void main() {
  runApp(MaterialApp(
    title: 'Judge Round Selection',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: JudgeRoundSelectionScreen(),
  ));
}

class JudgeRoundSelectionScreen extends StatefulWidget {
  @override
  _JudgeRoundSelectionScreenState createState() =>
      _JudgeRoundSelectionScreenState();
}

class _JudgeRoundSelectionScreenState
    extends State<JudgeRoundSelectionScreen> {
  List<String> rounds = [];

  @override
  void initState() {
    super.initState();
    loadRounds();
  }

  Future<void> loadRounds() async {
    List<String> loadedRounds = await getActiveRoundsFromDatabase();
    setState(() {
      rounds = loadedRounds;
    });
  }

  Future<List<String>> getActiveRoundsFromDatabase() async {
    List<Map<String, dynamic>> roundsData =
    await DatabaseRoundHelper.instance.getRounds();
    List<String> activeRoundNames = [];
    for (var round in roundsData) {
      if (round['roundNowOpen'] == 'active') {
        activeRoundNames.add(round['roundName'] as String);
      }
    }
    return activeRoundNames;
  }

  Future<String?> getAttemptNowOpen(String roundName) async {
    Map<String, dynamic>? roundData =
    await DatabaseRoundHelper.instance.getRoundByName(roundName);
    return roundData?['attemptNowOpen'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Judge Round Selection'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 0.0),
            Image.asset(
              'assets/images/logorubiks-01.png',
              width: 400.0,
              height: 300.0,
            ),
            SizedBox(height: 0.0),
            Column(
              children: <Widget>[
                Text(
                  'Haseeb Malik',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'J126773',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 3),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '                             Rounds',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  for (String round in rounds)
                    FutureBuilder<String?>(
                      future: getAttemptNowOpen(round),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          String? attemptNowOpen = snapshot.data;
                          return RoundButton(
                            roundNumber: round,
                            roundName: round,
                            attemptNowOpen: attemptNowOpen,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JudgeScan(
                                        roundName: round,
                                        attemptNowOpen: attemptNowOpen,
                                      ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  class RoundButton extends StatelessWidget {
  final String roundNumber;
  final String roundName;
  final String? attemptNowOpen;
  final VoidCallback onPressed;

  const RoundButton({
    required this.roundNumber,
    required this.roundName,
    required this.attemptNowOpen,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                roundNumber,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text('Add Participants'),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
