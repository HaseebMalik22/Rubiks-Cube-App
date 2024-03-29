import 'dart:io';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/database_judgehelper.dart';
import 'package:path/path.dart' as path;


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
  List<Judges> _judges = []; // Initialize an empty list

  @override
  void initState() {
    super.initState();
    _loadJudges(); // Fetch judges data from the database
  }

  Future<void> _loadJudges() async {
    final dbHelper = DatabaseJudgeHelper.instance;
    final judges = await dbHelper.getJudges(); // Fetch judges data from the database

    setState(() {
      _judges = judges
          .map((judgeMap) => Judges(
        id: judgeMap['id'].toString(),
        name: judgeMap['name'],
        email: judgeMap['email'],
      ))
          .toList();
    });
  }

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
                    exportToCsv();
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


  void exportToCsv() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      // Retrieve the external storage directory
      Directory? externalStorageDir = await getExternalStorageDirectory();

      if (externalStorageDir != null) {
        // Construct the file path
        String downloadsPath = path.join(externalStorageDir.path, 'Download');
        String filePath = path.join(downloadsPath, 'judges.csv');

        // Create the Download directory if it doesn't exist
        Directory(downloadsPath).createSync(recursive: true);

        // Open the file
        File file = File(filePath);

        // Convert the participant details to CSV format
        String csvData = '';

        for (var judge in _judges) {
          String id = judge.id;
          String name = judge.name;
          String email = judge.email;

          csvData += '$id,$name,$email\n';
        }

        // Write the CSV data to the file
        await file.writeAsString(csvData);

        String fileLocation = file.path;
        showToast('CSV file exported successfully');
      } else {
        showToast('Unable to access external storage');
      }
    } else {
      showToast('Storage permission denied');
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: ListOfJudgesScreen(),
  ));
}
