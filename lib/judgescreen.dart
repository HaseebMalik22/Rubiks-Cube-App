import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';

class Judge {
  final int id;
  final String name;
  final String email;
  final String contact;

  Judge({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
  });
}

class JudgeScreen extends StatefulWidget {
  @override
  _JudgeScreenState createState() => _JudgeScreenState();
}

class _JudgeScreenState extends State<JudgeScreen> {
  final List<Judge> judges = [
    Judge(id: 1, name: 'John Doe', email: 'john.doe@example.com', contact: '1234567890'),
    Judge(id: 2, name: 'Jane Smith', email: 'jane.smith@example.com', contact: '9876543210'),
  ];

  int indexToEdit = -1;
  int indexToDelete = -1;

  List<Judge> filteredJudges = [];

  @override
  void initState() {
    super.initState();
    filteredJudges = judges;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Judge Details'),
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
        padding: EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(16.0),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Judge Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    filterJudges(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredJudges.length,
                  itemBuilder: (context, index) {
                    final judge = filteredJudges[index];
                    return ListTile(
                      title: Text('Judge ID: ${judge.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Judge Name: ${judge.name}'),
                          Text('Email Address: ${judge.email}'),
                          Text('Contact No: ${judge.contact}'),
                        ],
                      ),
                      onTap: () {
                        // Judge item tapped
                        _showEditJudgeDialog(index);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Close button pressed
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add button pressed
                        _showAddJudgeDialog();
                      },
                      child: Text('Add'),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Edit button pressed
                    //     _showEditJudgeDialog(indexToEdit);
                    //   },
                    //   child: Text('Edit'),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        // Delete button pressed
                        _showDeleteJudgeDialog(indexToDelete);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void filterJudges(String query) {
    setState(() {
      filteredJudges = judges.where((judge) {
        final nameLower = judge.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  void _showAddJudgeDialog() {
    int judgeId = 0;
    String judgeName = '';
    String emailAddress = '';
    String contactNo = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Judge'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Judge ID'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    judgeId = int.tryParse(value) ?? 0;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Judge Name'),
                  onChanged: (value) {
                    judgeName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email Address'),
                  onChanged: (value) {
                    emailAddress = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contact No'),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    contactNo = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Save button pressed in the dialog
                setState(() {
                  judges.add(
                    Judge(
                      id: judgeId,
                      name: judgeName,
                      email: emailAddress,
                      contact: contactNo,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                // Cancel button pressed in the dialog
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditJudgeDialog(int index) {
    setState(() {
      indexToEdit = index;
    });

    if (indexToEdit == -1) {
      // No judge selected, display an error message or handle the scenario appropriately
      return;
    }

    final judgeToEdit = judges[indexToEdit];

    int judgeId = judgeToEdit.id;
    String judgeName = judgeToEdit.name;
    String emailAddress = judgeToEdit.email;
    String contactNo = judgeToEdit.contact;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Judge'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    initialValue: judgeId.toString(),
                    decoration: InputDecoration(labelText: 'Judge ID'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        judgeId = int.tryParse(value) ?? judgeId;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: judgeName,
                    decoration: InputDecoration(labelText: 'Judge Name'),
                    onChanged: (value) {
                      setState(() {
                        judgeName = value;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onChanged: (value) {
                      setState(() {
                        emailAddress = value;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: contactNo,
                    decoration: InputDecoration(labelText: 'Contact No'),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      setState(() {
                        contactNo = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Save button pressed in the dialog
                setState(() {
                  judges[indexToEdit] = Judge(
                    id: judgeId,
                    name: judgeName,
                    email: emailAddress,
                    contact: contactNo,
                  );
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                // Cancel button pressed in the dialog
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteJudgeDialog(int index) {
    setState(() {
      indexToDelete = index;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Judge'),
          content: Text('Are you sure you want to delete this judge?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Delete button pressed in the dialog
                setState(() {
                  judges.removeAt(indexToDelete);
                });
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                // Cancel button pressed in the dialog
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
