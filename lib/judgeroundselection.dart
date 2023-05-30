import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';
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

class JudgeRoundSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Judge Round Selection'),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20.0), // Add SizedBox for spacing
          Image.asset(
            'assets/images/rubiks-logo.png',
            width: 300.0,
            height: 300.0,
          ),
          SizedBox(height: 0.0), // Add SizedBox for spacing
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
          SizedBox(height: 15.0), // Add SizedBox for spacing
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
                    '                         Rounds',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RoundButton(
                  roundNumber: 'Round 1',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JudgeScan(),
                      ),
                    );
                  },
                ),
                RoundButton(
                  roundNumber: 'Round 2',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JudgeScan(),
                      ),
                    );
                  },
                ),
                RoundButton(
                  roundNumber: 'Round 3',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JudgeScan(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class RoundButton extends StatelessWidget {
  final String roundNumber;
  final VoidCallback onPressed;

  const RoundButton({required this.roundNumber, required this.onPressed});

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
