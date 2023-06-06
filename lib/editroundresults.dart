import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/listofrounds.dart';

class EditRoundResults extends StatefulWidget {
  final Round round;

  EditRoundResults({required this.round});

  @override
  _EditRoundResultsState createState() => _EditRoundResultsState();
}

class _EditRoundResultsState extends State<EditRoundResults> {
  List<Participant> filteredParticipants = [];
  String searchQuery = '';

  void searchParticipants() {
    setState(() {
      filteredParticipants = participants.where((participant) {
        return participant.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            participant.id.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
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
                  itemCount: filteredParticipants.length,
                  itemBuilder: (context, index) {
                    Participant participant = filteredParticipants[index];
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
                        title: Text('ID: ${participant.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${participant.name}'),
                            Text('Time: ${participant.time}'),
                            Text('Attempts: ${participant.attempts != null ? participant.attempts!.map((attempt) => 'Attempt: $attempt').join(", ") : '1'}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Open the edit dialog
                            showDialog(
                              context: context,
                              builder: (context) => EditTimeDialog(
                                participant: participant,
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

class EditTimeDialog extends StatelessWidget {
  final Participant participant;
  final TextEditingController _timeController = TextEditingController();

  EditTimeDialog({required this.participant}) {
    _timeController.text = participant.time;
  }

  @override
  Widget build(BuildContext context) {
    String editedTime = '';

    return AlertDialog(
      title: Text('Edit Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ID: ${participant.id}'),
          Text('Name: ${participant.name}'),
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
            participant.time = editedTime;

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

class Participant {
  final String id;
  final String name;
  String time;
  List<int>? attempts;

  Participant({
    required this.id,
    required this.name,
    required this.time,
    this.attempts,
  });
}

// Sample list of participants
List<Participant> participants = [
  Participant(id: '1', name: 'John Doe', time: '00:30', attempts: [1, 2, 3]),
  Participant(id: '2', name: 'Jane Smith', time: '01:15', attempts: [1, 2]),
  Participant(id: '3', name: 'Mike Johnson', time: '00:45', attempts: [1]),
  Participant(id: '4', name: 'Sarah Thompson', time: '01:05', attempts: [1, 2, 3, 4]),
];