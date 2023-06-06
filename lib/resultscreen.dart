import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/database_helper.dart';
import 'package:rubikscube/database_roundhelper.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Map<String, dynamic>> participants = [
    {'name': 'John Doe', 'ageGroup': '8-12', 'bestTime': '1:30'},
    {'name': 'Jane Smith', 'ageGroup': '8-12', 'bestTime': '2:15'},
    {'name': 'haseeb', 'ageGroup': '13-16', 'bestTime': '1:45'},
    {'name': 'ali', 'ageGroup': '13-16', 'bestTime': '2:00'},
    {'name': 'raza', 'ageGroup': '13-16', 'bestTime': '1:00'},
    // Add more participants...
  ];

  bool filterAscending = true;
  int selectedTop = 10;
  List<Map<String, dynamic>> filteredParticipants = [];
  String selectedRound = '';
  String bestTime = '';
  String bestParticipantName = '';

  List<Map<String, dynamic>> rounds = [];

  @override
  void initState() {
    super.initState();
    applyFilter();
    fetchRounds();
  }

  void fetchRounds() async {
    List<Map<String, dynamic>> fetchedRounds =
    await DatabaseRoundHelper.instance.getRounds();
    setState(() {
      rounds = fetchedRounds;
      selectedRound = fetchedRounds[0]['roundName']; // Assuming the first round is selected initially
    });

    // Retrieve the participant with the lowest time
    String lowestTime = await DatabaseHelper.instance.getLowestTime();
    String participantName =
    await DatabaseHelper.instance.getParticipantName(lowestTime);

    setState(() {
      bestTime = lowestTime;
      bestParticipantName = participantName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Screen'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Select Round:'),
                      SizedBox(width: 8.0),
                      DropdownButton<String>(
                        value: selectedRound,
                        items: rounds.map<DropdownMenuItem<String>>((round) {
                          return DropdownMenuItem<String>(
                            value: round['roundName'],
                            child: Text(round['roundName']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRound = value!;
                            applyFilter();
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(child: Text('Participant Name')),
                          TableCell(child: Text('Age Group')),
                          TableCell(child: Text('Best Time')),
                        ],
                      ),
                      for (var participant in filteredParticipants)
                        TableRow(
                          children: [
                            TableCell(child: Text(participant['name'])),
                            TableCell(child: Text(participant['ageGroup'])),
                            TableCell(child: Text(participant['bestTime'] ?? '-')),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showExportDBDialog(context); // Show the export dialog
                        },
                        child: Text('Export to DB'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showFilterDialog(context); // Show the filter dialog
                  },
                  child: Text('Filter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showQualifyDialog(context); // Show the qualify dialog
                  },
                  child: Text('Qualify'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showExportDialog(context); // Show the export dialog
                  },
                  child: Text('Export'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Best Time: $bestTime',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Participant Name: $bestParticipantName',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Participants'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sort by Best Time'),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: filterAscending,
                    onChanged: (value) {
                      setState(() {
                        filterAscending = value!;
                        applyFilter();
                        Navigator.pop(context); // Close the dialog
                      });
                    },
                  ),
                  Text('Ascending'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: false,
                    groupValue: filterAscending,
                    onChanged: (value) {
                      setState(() {
                        filterAscending = value!;
                        applyFilter();
                        Navigator.pop(context); // Close the dialog
                      });
                    },
                  ),
                  Text('Descending'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showQualifyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Qualify Participants'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter the number of participants to qualify:'),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Number of Participants',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    selectedTop = int.tryParse(value) ?? 10;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                applyFilter();
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Qualify'),
            ),
          ],
        );
      },
    );
  }

  void showExportDialog(BuildContext context) {
    String tableName = ''; // Variable to store the table name entered by the user

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Participants'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select export format:'),
              ElevatedButton(
                onPressed: () {
                  exportToCSV(tableName); // Pass the table name to the export method
                  Navigator.pop(context); // Close the dialog
                  showToast('Exported to CSV');
                },
                child: Text('Export to CSV'),
              ),
              SizedBox(height: 16.0),
              Text('Enter file name:'), // Add label for the text input field
              TextField(
                decoration: InputDecoration(
                  labelText: 'File Name',
                ),
                onChanged: (value) {
                  setState(() {
                    tableName = value;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showExportDBDialog(BuildContext context) {
    String tableName = ''; // Variable to store the table name entered by the user

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Participants'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select export format:'),
              ElevatedButton(
                onPressed: () {
                  exportToDB(tableName); // Pass the table name to the export method
                  Navigator.pop(context); // Close the dialog
                  showToast('Exported to DB');
                },
                child: Text('Export to DB'),
              ),
              SizedBox(height: 16.0),
              Text('Enter table name:'), // Add label for the text input field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Table Name',
                ),
                onChanged: (value) {
                  setState(() {
                    tableName = value;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void applyFilter() {
    filteredParticipants = List.from(participants);
    filteredParticipants.sort((a, b) {
      final aTime = a['bestTime'] as String?;
      final bTime = b['bestTime'] as String?;
      if (aTime != null && bTime != null) {
        if (filterAscending) {
          return aTime.compareTo(bTime);
        } else {
          return bTime.compareTo(aTime);
        }
      } else {
        return 0;
      }
    });
    if (selectedTop < filteredParticipants.length) {
      filteredParticipants = filteredParticipants.sublist(0, selectedTop);
    }
  }

  void exportToCSV(String tableName) {
    // Export logic to CSV
  }

  void exportToDB(String tableName) {
    // Export logic to DB
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Result Screen',
    home: ResultScreen(),
  ));
}