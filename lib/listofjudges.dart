import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rubikscube/Homepage.dart';

class Judges {
  final String id;
  final String name;
  final String email;

  Judges({
    required this.id,
    required this.name,
    required this.email,
  });
}

class ListOfJudgesScreen extends StatefulWidget {
  @override
  _ListOfJudgesScreenState createState() => _ListOfJudgesScreenState();
}

class _ListOfJudgesScreenState extends State<ListOfJudgesScreen> {
  List<Judges> _judges = [
    Judges(
      id: '001',
      name: 'John Doe',
      email: 'john@example.com',
    ),
    Judges(
      id: '002',
      name: 'Jane Smith',
      email: 'jane@example.com',
    ),
    Judges(
      id: '003',
      name: 'Haseeb Malik',
      email: 'haseeb@example.com',
    ),
    Judges(
      id: '004',
      name: 'Amir Ali',
      email: 'amir@example.com',
    ),
    Judges(
      id: '005',
      name: 'Mubeen Ul Haq',
      email: 'mubeen@example.com',
    ),
    Judges(
      id: '006',
      name: 'Wilson',
      email: 'wilson@example.com',
    ),
    Judges(
      id: '007',
      name: 'Anum',
      email: 'anum@example.com',
    ),
    Judges(
      id: '008',
      name: 'Anas Sheikh',
      email: 'anas@example.com',
    ),
    Judges(
      id: '009',
      name: 'Shaukat',
      email: 'shaukat@example.com',
    ),
    Judges(
      id: '010',
      name: 'Yasir',
      email: 'yasir@example.com',
    ),
    // Add more participants here
  ];

  String _searchId = '';
  Judges? _searchResult;

  void _searchParticipant() {
    setState(() {
      _searchResult = _judges.firstWhere(
            (participant) => participant.id == _searchId,
        orElse: () => Judges(
          id: '',
          name: '',
          email: '',
        ),
      );
    });
  }

  void _showParticipantDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Judge Details'),
          content: _searchResult!.id.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${_searchResult!.id}'),
              Text('Name: ${_searchResult!.name}'),
              Text('Email: ${_searchResult!.email}'),
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
        title: Text('List of Judges'),
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
                labelText: 'Judge ID',
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
                    ],
                    rows: _judges.map((participant) {
                      return DataRow(cells: [
                        DataCell(Text(participant.id)),
                        DataCell(Text(participant.name)),
                        DataCell(Text(participant.email)),
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
    home: ListOfJudgesScreen(),
  ));
}
