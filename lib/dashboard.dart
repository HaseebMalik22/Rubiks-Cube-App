import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/judgeroundselection.dart';
import 'package:rubikscube/judgescreen.dart';
import 'package:rubikscube/participantscreen.dart';
import 'package:rubikscube/resultscreen.dart';
import 'package:rubikscube/roundsetup.dart';
import 'package:rubikscube/database_roundhelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> roundNames = [];

  List<bool> roundToggleStates = [];
  List<List<bool>> attemptToggleStates = [];

  @override
  void initState() {
    super.initState();
    // emptyRoundTable();
    fetchRoundsData();
  }

  Future<void> fetchRoundsData() async {
    // Fetch rounds data from the database
    List<Map<String, dynamic>> rounds = await DatabaseRoundHelper.instance
        .getRounds();

    // Print the fetched rounds and their names
    for (var round in rounds) {
      final roundName = round['roundName'];
      if (roundName != null) {
        print('Round: $roundName');
      }
    }

    // Create round toggle states and attempt toggle states based on fetched data
    setState(() {
      roundToggleStates = List.generate(rounds.length, (index) => false);
      attemptToggleStates =
          List.generate(rounds.length, (_) => [false, false, false]);
    });

    // Store the round names from the database in a list
    List<String> roundNames = rounds
        .map((round) => round['roundName'] as String?) // Use null-aware cast
        .where((roundName) => roundName != null) // Filter out null values
        .map((
        roundName) => roundName!) // Remove nullability using non-null assertion
        .toList();

    // Pass the round names to the RoundToggle widgets
    setState(() {
      this.roundNames = roundNames;
    });
  }

  // void emptyRoundTable() async {
  //   await DatabaseRoundHelper.instance.deleteAllRounds();
  // }


  void toggleRoundState(int index) {
    setState(() {
      roundToggleStates[index] = !roundToggleStates[index];
    });
  }

  void toggleAttemptState(int roundIndex, int attemptIndex) {
    setState(() {
      for (int i = 0; i < attemptToggleStates[roundIndex].length; i++) {
        attemptToggleStates[roundIndex][i] = (i == attemptIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/rubikscube.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: Text('Judges'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JudgeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Participants'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParticipantScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Round Setup'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoundSetupScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Check Results'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Current Rounds',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (int i = 0; i < roundToggleStates.length; i++)
                      RoundToggle(
                        roundNumber: i + 1,
                        active: roundToggleStates[i],
                        onToggle: () => toggleRoundState(i),
                        attemptToggleStates: attemptToggleStates[i],
                        onAttemptToggle: (index) =>
                            toggleAttemptState(i, index),
                        roundName: roundNames.length > i ? roundNames[i] : '',
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 16.0,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    DashboardBox(
                      image: AssetImage('assets/images/participants.png'),
                      text: 'Participants',
                    ),
                    DashboardBox(
                      image: AssetImage('assets/images/judges.png'),
                      text: 'Judges',
                    ),
                    DashboardBox(
                      image: AssetImage('assets/images/results.png'),
                      text: 'Results',
                    ),
                    DashboardBox(
                      image: AssetImage('assets/images/best-time.png'),
                      text: 'Best Time',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  class RoundToggle extends StatelessWidget {
  final int roundNumber;
  final String roundName;
  final bool active;
  final VoidCallback onToggle;
  final List<bool> attemptToggleStates;
  final Function(int) onAttemptToggle;

  const RoundToggle({
    required this.roundNumber,
    required this.roundName,
    required this.active,
    required this.onToggle,
    required this.attemptToggleStates,
    required this.onAttemptToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add elevation for the drop shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Set border radius for curved corners
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0), // Set border radius for curved corners
          color: Colors.yellow, // Set the background color to yellow
        ),
        padding: EdgeInsets.all(16.0), // Add padding for spacing
        child: Column(
          children: <Widget>[
            Text(
              'Round $roundNumber - $roundName',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: onToggle,
              style: ElevatedButton.styleFrom(
                primary: active ? Colors.green : Colors.red[400],
              ),
              child: Text(active ? 'Active' : 'Inactive'),
            ),
            SizedBox(height: 10.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (int i = 0; i < attemptToggleStates.length; i++)
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: ElevatedButton(
                        onPressed: () => onAttemptToggle(i),
                        style: ElevatedButton.styleFrom(
                          primary: attemptToggleStates[i] ? Colors.green : Colors.red[400],
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        child: Text('Attempt ${i + 1}'),
                      ),
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


class DashboardBox extends StatelessWidget {
  final ImageProvider image;
  final String text;

  const DashboardBox({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (text == 'Participants') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParticipantScreen(),
            ),
          );
        } else if (text == 'Judges') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JudgeScreen(),
            ),
          );
        } else if (text == 'Results') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(),
            ),
          );
        } else if (text == 'Best Time') {
          // Replace the navigation with a toast message
          showToastMessage(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: image,
              height: 80.0,
            ),
            SizedBox(height: 10.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToastMessage(BuildContext context) {
    Fluttertoast.showToast(
      msg: 'Best time: 01:25:112',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// class ParticipantScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Participants'),
//       ),
//       body: Center(
//         child: Text('Participant Screen'),
//       ),
//     );
//   }
// }
//
// class JudgeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Judges'),
//       ),
//       body: Center(
//         child: Text('Judge Screen'),
//       ),
//     );
//   }
// }
//
// class ResultScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Results'),
//       ),
//       body: Center(
//         child: Text('Result Screen'),
//       ),
//     );
//   }
// }
//
// class RoundSetupScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Round Setup'),
//       ),
//       body: Center(
//         child: Text('Round Setup Screen'),
//       ),
//     );
//   }
// }
//
// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Text('Home Screen'),
//       ),
//     );
//   }
// }
