import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/listofall.dart';
import 'package:rubikscube/listofjudges.dart';
import 'package:rubikscube/listofrounds.dart';
import 'package:rubikscube/resultscreen.dart';

class HeadJudgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Head Judge'),
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
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/rubikscube.png'), // Add the path to your image
                  fit: BoxFit.cover,
                ),
              ),
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent, // Make the header transparent
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('All Participants'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListOfAllScreen(),
                  ),
                );
                // Handle List of All option
              },
            ),
            ListTile(
              title: Text('List of Judges'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListOfJudgesScreen(),
                  ),
                );

                // Handle List of Judges option
              },
            ),
            ListTile(
              title: Text('List of Rounds'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoundsScreen(),
                  ),
                );

                // Handle List of Matches option
              },
            ),
            ListTile(
              title: Text('Results'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(),
                  ),
                );
                // Handle Results option
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Quick Options',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoundsScreen(),
                    ),
                  );
                  // Handle Edit Results button press
                },
                child: Text('Edit Results'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(),
                    ),
                  );
                  // Handle View Results button press
                },
                child: Text('View Results'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HeadJudgeScreen(),
  ));
}