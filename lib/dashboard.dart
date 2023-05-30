import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/judgescreen.dart';
import 'package:rubikscube/participantscreen.dart';
import 'package:rubikscube/resultscreen.dart';
import 'package:rubikscube/roundsetup.dart';

void main() {
  runApp(DashboardApp());
}

class DashboardApp extends StatelessWidget {
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
  List<bool> roundToggleStates = [true, false, true];
  List<List<bool>> attemptToggleStates = [
    [true, false, true],
    [false, true, false],
    [true, true, true],
  ];

  void toggleRoundState(int index) {
    setState(() {
      roundToggleStates[index] = !roundToggleStates[index];
    });
  }

  void toggleAttemptState(int roundIndex, int attemptIndex) {
    setState(() {
      attemptToggleStates[roundIndex][attemptIndex] =
      !attemptToggleStates[roundIndex][attemptIndex];
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Rounds',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(14.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RoundToggle(
                        roundNumber: 1,
                        active: roundToggleStates[0],
                        onToggle: () => toggleRoundState(0),
                        attemptToggleStates: attemptToggleStates[0],
                        onAttemptToggle: (index) => toggleAttemptState(0, index),
                      ),
                      RoundToggle(
                        roundNumber: 2,
                        active: roundToggleStates[1],
                        onToggle: () => toggleRoundState(1),
                        attemptToggleStates: attemptToggleStates[1],
                        onAttemptToggle: (index) => toggleAttemptState(1, index),
                      ),
                      // RoundToggle(
                      //   roundNumber: 3,
                      //   active: roundToggleStates[2],
                      //   onToggle: () => toggleRoundState(2),
                      //   attemptToggleStates: attemptToggleStates[2],
                      //   onAttemptToggle: (index) => toggleAttemptState(2, index),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    GridView.count(
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
                          text: 'Best time',
                        ),
                      ],
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
        } else if (text == 'Best time') {
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
              color: Colors.white.withOpacity(0.3),
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

class RoundToggle extends StatelessWidget {
  final int roundNumber;
  final bool active;
  final void Function()? onToggle;  // Update the property type
  final List<bool> attemptToggleStates;
  final Function(int) onAttemptToggle;

  const RoundToggle({
    required this.roundNumber,
    required this.active,
    required this.onToggle,
    required this.attemptToggleStates,
    required this.onAttemptToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Round $roundNumber',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        ToggleButtons(
          children: <Widget>[
            Text('1st'),
            Text('2nd'),
            Text('3rd'),
          ],
          isSelected: attemptToggleStates,
          onPressed: onAttemptToggle,
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: onToggle,
          child: Text(active ? 'Active' : 'Inactive'),
          style: ElevatedButton.styleFrom(
            primary: active ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}



