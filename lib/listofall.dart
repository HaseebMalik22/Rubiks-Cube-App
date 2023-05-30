import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rubikscube/Homepage.dart';

class Participant {
  final String id;
  final String name;
  final String email;
  final String bestTime;

  Participant({
    required this.id,
    required this.name,
    required this.email,
    required this.bestTime,
  });
}

class ListOfAllScreen extends StatefulWidget {
  @override
  _ListOfAllScreenState createState() => _ListOfAllScreenState();
}

class _ListOfAllScreenState extends State<ListOfAllScreen> {
  List<Participant> _participants = [
    Participant(
      id: '001',
      name: 'John Doe',
      email: 'john@example.com',
      bestTime: '00:30:22',
    ),
    Participant(
      id: '002',
      name: 'Jane Smith',
      email: 'jane@example.com',
      bestTime: '00:45:14',
    ),
    Participant(
      id: '003',
      name: 'Haseeb Malik',
      email: 'haseeb@example.com',
      bestTime: '00:47:14',
    ),
    Participant(
      id: '004',
      name: 'Amir Ali',
      email: 'amir@example.com',
      bestTime: '00:41:17',
    ),
    Participant(
      id: '005',
      name: 'Mubeen Ul Haq',
      email: 'mubeen@example.com',
      bestTime: '00:49:14',
    ),
    Participant(
      id: '006',
      name: 'Wilson',
      email: 'wilson@example.com',
      bestTime: '00:45:14',
    ),
    Participant(
      id: '007',
      name: 'Anum',
      email: 'anum@example.com',
      bestTime: '00:22:14',
    ),
    Participant(
      id: '008',
      name: 'Anas Sheikh',
      email: 'anas@example.com',
      bestTime: '00:55:17',
    ),
    Participant(
      id: '009',
      name: 'Shaukat',
      email: 'shaukat@example.com',
      bestTime: '00:25:14',
    ),
    Participant(
      id: '010',
      name: 'Yasir',
      email: 'yasir@example.com',
      bestTime: '00:28:16',
    ),
    // Add more participants here
  ];

  String _searchId = '';
  Participant? _searchResult;

  void _searchParticipant() {
    setState(() {
      _searchResult = _participants.firstWhere(
            (participant) => participant.id == _searchId,
        orElse: () => Participant(
          id: '',
          name: '',
          email: '',
          bestTime: '',
        ),
      );
    });
  }

  void _showParticipantDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Participant Details'),
          content: _searchResult!.id.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${_searchResult!.id}'),
              Text('Name: ${_searchResult!.name}'),
              Text('Email: ${_searchResult!.email}'),
              Text('Best Time: ${_searchResult!.bestTime}'),
            ],
          )
              : Text('Participant not found.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of All'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchId = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Participant ID',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _searchParticipant();
                _showParticipantDialog();
              },
              child: Text('Search'),
            ),
            SizedBox(height: 24.0),
            Flexible(
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
                padding: EdgeInsets.all(0.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Best Time')),
                    ],
                    rows: _participants.map((participant) {
                      return DataRow(cells: [
                        DataCell(Text(participant.id)),
                        DataCell(Text(participant.name)),
                        DataCell(Text(participant.email)),
                        DataCell(Text(participant.bestTime)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Exit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: 'Data exported successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                  child: Text('Export'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListOfAllScreen(),
  ));
}
