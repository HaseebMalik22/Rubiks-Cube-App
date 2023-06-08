import 'dart:io';
import 'package:universal_io/io.dart';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/database_helper.dart';
import 'package:path/path.dart' as path;


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
  List<Participant> _participants = [];

  void _fetchParticipantsFromDatabase() async {
    List<Map<String, dynamic>> participantsData = await DatabaseHelper.instance
        .getAllParticipants();
    setState(() {
      _participants = participantsData.map((data) {
        return Participant(
          id: data['id'].toString(),
          name: data['name'],
          email: data['email'],
          bestTime: data['time'],
        );
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchParticipantsFromDatabase();
  }


  String _searchId = '';
  Participant? _searchResult;

  void _searchParticipant() {
    setState(() {
      _searchResult = _participants.firstWhere(
            (participant) => participant.id == _searchId,
        orElse: () =>
            Participant(
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
        String filePath = path.join(downloadsPath, 'participants.csv');

        // Create the Download directory if it doesn't exist
        Directory(downloadsPath).createSync(recursive: true);

        // Open the file
        File file = File(filePath);

        // Convert the participant details to CSV format
        String csvData = '';

        for (var participant in _participants) {
          String id = participant.id;
          String name = participant.name;
          String email = participant.email;
          String bestTime = participant.bestTime;

          csvData += '$id,$name,$email,$bestTime\n';
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
    home: ListOfAllScreen(),
  ));
}
