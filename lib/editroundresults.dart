import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/listofrounds.dart';

class EditRoundResults extends StatelessWidget {
  final Round round;

  EditRoundResults({required this.round});

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
        padding: const EdgeInsets.all(16.0),
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
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Participant',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    Participant participant = participants[index];
                    return ListTile(
                      title: Text('ID: ${participant.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${participant.name}'),
                          Text('Time: ${participant.time}'),
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

  EditTimeDialog({required this.participant});

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
          Text('Time: ${participant.time}'),
          TextField(
            onChanged: (value) {
              editedTime = value;
            },
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

class Participant {
  final String id;
  final String name;
  String time;

  Participant({required this.id, required this.name, required this.time});
}

// Sample list of participants
List<Participant> participants = [
  Participant(id: '1', name: 'John Doe', time: '00:30'),
  Participant(id: '2', name: 'Jane Smith', time: '01:15'),
  Participant(id: '3', name: 'Mike Johnson', time: '00:45'),
  Participant(id: '4', name: 'Sarah Thompson', time: '01:05'),
];
