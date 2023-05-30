import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryChangeScreen extends StatefulWidget {
  @override
  _CategoryChangeScreenState createState() => _CategoryChangeScreenState();
}

class _CategoryChangeScreenState extends State<CategoryChangeScreen> {
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

  Set<int> selectedIndices = {};

  String selectedRound = 'Round 1'; // New variable to store the selected round

  @override
  void initState() {
    super.initState();
    applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Change'),
        actions: [
          IconButton(
            icon: Icon(Icons.import_export_rounded),
            onPressed: () {
              showExportDialog(context); // Show the export dialog
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
                  DropdownButton<String>(
                    value: selectedRound,
                    onChanged: (value) {
                      setState(() {
                        selectedRound = value!;
                        applyFilter();
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'Round 1',
                        child: Text('Round 1'),
                      ),
                      DropdownMenuItem(
                        value: 'Round 2',
                        child: Text('Round 2'),
                      ),
                      DropdownMenuItem(
                        value: 'Round 3',
                        child: Text('Round 3'),
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
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the dashboard screen
                  },
                  child: SizedBox(
                    width: 40,
                    child: Text('Close'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showFilterOptions(context); // Show the filter options dialog
                  },
                  child: SizedBox(
                    width: 40,
                    child: Text('Filter'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showQualifyPopup(context); // Show the qualify popup
                  },
                  child: SizedBox(
                    width: 45,
                    child: Text('Qualify'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showChangeCategoryPopup(context); // Show the change category popup
                  },
                  child: SizedBox(
                    width: 50,
                    child: Text('Group'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Participants'),
          content: Text('Do you want to export the participants?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                exportParticipants(); // Call the exportParticipants function
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Export'),
            ),
          ],
        );
      },
    );
  }

  void exportParticipants() {
    // Add your export functionality here
    // This function is called when the export button is pressed
    // You can export the participants list to a file or perform any other export operation
    Fluttertoast.showToast(msg: 'Exported participants'); // Show a toast message
  }

  void showChangeCategoryPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Category'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select participants to change category:'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final participant = participants[index];
                      return ListTile(
                        title: Text(participant['name']),
                        subtitle: Text('Age Group: ${participant['ageGroup']}'),
                        trailing: Checkbox(
                          value: selectedIndices.contains(index),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedIndices.add(index);
                              } else {
                                selectedIndices.remove(index);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
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
                // Change the age group of selected participants
                for (final index in selectedIndices) {
                  final participant = participants[index];
                  if (participant['ageGroup'] == '8-12') {
                    participant['ageGroup'] = '13-16';
                  } else {
                    participant['ageGroup'] = '8-12';
                  }
                }
                setState(() {
                  selectedIndices.clear();
                });
                applyFilter(); // Apply the filter after changing the age group
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Sort by Best Time (Ascending)'),
                leading: Radio(
                  value: true,
                  groupValue: filterAscending,
                  onChanged: (value) {
                    setState(() {
                      filterAscending = value!;
                      applyFilter();
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Sort by Best Time (Descending)'),
                leading: Radio(
                  value: false,
                  groupValue: filterAscending,
                  onChanged: (value) {
                    setState(() {
                      filterAscending = value!;
                      applyFilter();
                    });
                  },
                ),
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
                // Apply the filter
                applyFilter();
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void showQualifyPopup(BuildContext context) {
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
                  labelText: 'Top',
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
                applyFilter(); // Apply the filter based on the entered value
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
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
}

void main() {
  runApp(MaterialApp(
    title: 'Category Change',
    home: CategoryChangeScreen(),
  ));
}
