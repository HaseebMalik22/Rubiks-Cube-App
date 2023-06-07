import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/listofrounds.dart';
import 'package:rubikscube/timerecord_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class EditRoundResults extends StatefulWidget {
  final Round round;

  EditRoundResults({required this.round});

  @override
  _EditRoundResultsState createState() => _EditRoundResultsState();
}

class _EditRoundResultsState extends State<EditRoundResults> {
  List<TimeRecord> timeRecords = [];
  List<TimeRecord> filteredTimeRecords = [];
  String searchQuery = '';

  TimeRecordHelper timeRecordHelper = TimeRecordHelper();

  void searchParticipants() {
    setState(() {
      filteredTimeRecords = timeRecords.where((timeRecord) {
        return timeRecord.participantName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            timeRecord.round.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTimeRecords();
  }

  void fetchTimeRecords() async {
    List<TimeRecord> records = await timeRecordHelper.getAllTimeRecords();
    setState(() {
      timeRecords = records;
      filteredTimeRecords = records;
    });
  }

  Future<void> updateTimeRecord(int? id, String time) async {
    await timeRecordHelper.updateTimeRecord(id, time);
    fetchTimeRecords(); // Refresh the time records after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Head Judge Edit Records'),
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
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Head Judge Edit Records',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Round: ${widget.round.name}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Search Participant',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: searchParticipants,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTimeRecords.length,
                  itemBuilder: (context, index) {
                    TimeRecord timeRecord = filteredTimeRecords[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
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
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text('ID: ${timeRecord.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${timeRecord.participantName}'),
                            Text('Time: ${timeRecord.time}'),
                            Text('Attempts: ${timeRecord.attempt}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Open the edit dialog
                            showDialog(
                              context: context,
                              builder: (context) => EditTimeDialog(
                                timeRecord: timeRecord,
                                updateTimeRecord: updateTimeRecord,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditTimeDialog extends StatefulWidget {
  final TimeRecord timeRecord;
  final Function(int?, String) updateTimeRecord;

  EditTimeDialog({required this.timeRecord, required this.updateTimeRecord});

  @override
  _EditTimeDialogState createState() => _EditTimeDialogState();
}

class _EditTimeDialogState extends State<EditTimeDialog> {
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timeController.text = widget.timeRecord.time;
  }

  @override
  Widget build(BuildContext context) {
    String editedTime = '';

    return AlertDialog(
      title: Text('Edit Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ID: ${widget.timeRecord.id}'),
          Text('Name: ${widget.timeRecord.participantName}'),
          TextField(
            controller: _timeController,
            onChanged: (value) {
              editedTime = value;
            },
            inputFormatters: [
              _TimeInputFormatter(),
            ],
            decoration: InputDecoration(
              labelText: 'New Time',
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Save the edited time
            widget.updateTimeRecord(widget.timeRecord.id, editedTime);

            // Close the dialog
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.length == 2 || newValue.text.length == 5) {
      final updatedText = '${newValue.text}:';
      return TextEditingValue(
        text: updatedText,
        selection: TextSelection.collapsed(offset: updatedText.length),
      );
    }
    return newValue;
  }
}