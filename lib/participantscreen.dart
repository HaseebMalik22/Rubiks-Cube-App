import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rubikscube/Homepage.dart';

class Participant {
  int id;
  String name;
  String email;
  String contact;
  DateTime? dateOfBirth;
  String category;

  Participant({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    this.dateOfBirth,
    required this.category,
  });
}

class ParticipantScreen extends StatefulWidget {
  @override
  _ParticipantScreenState createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  final List<Participant> participants = [
    Participant(
      id: 1,
      name: 'Alice Johnson',
      email: 'alice.johnson@example.com',
      contact: '1234567890',
      dateOfBirth: DateTime(1990, 1, 1),
      category: '8-12',
    ),
    // Add more participants here
    Participant(
      id: 2,
      name: 'Bob Smith',
      email: 'bob.smith@example.com',
      contact: '9876543210',
      dateOfBirth: DateTime(1995, 2, 10),
      category: '13-18',
    ),
  ];

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  DateTime? dateOfBirth;

  String selectedCategory = '8-12'; // Initialize with a default value
  String searchQuery = '';
  List<Participant> filteredParticipants = [];

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participant Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
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
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: idController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'ID'),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            controller: contactController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(labelText: 'Contact'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then((selectedDate) {
                                setState(() {
                                  dateOfBirth = selectedDate;
                                });
                              });
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                hintText: 'Select Date',
                              ),
                              child: Text(dateOfBirth != null
                                  ? '${dateOfBirth!.day}-${dateOfBirth!.month}-${dateOfBirth!.year}'
                                  : 'Select Date'),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: InputDecoration(labelText: 'Category'),
                            onChanged: (String? value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '8-12',
                                child: Text('8-12'),
                              ),
                              DropdownMenuItem<String>(
                                value: '13-18',
                                child: Text('13-18'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addParticipant();
                    },
                    child: Text('Add Participant'),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(labelText: 'Search by ID'),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            applySearchFilter();
                          },
                          child: Text('Apply'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredParticipants.length,
                    itemBuilder: (context, index) {
                      final participant = filteredParticipants[index];

                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Text(participant.id.toString()),
                            title: Text(participant.name),
                            subtitle: Text(participant.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    editParticipant(participant);
                                  },
                                  child: Text('Edit'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteParticipant(participant);
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void applySearchFilter() {
    setState(() {
      filteredParticipants = participants.where((participant) {
        return participant.id.toString().contains(searchQuery);
      }).toList();
    });
  }

  void addParticipant() {
    final id = int.tryParse(idController.text);
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final contact = contactController.text.trim();
    final category = selectedCategory;

    if (id != null && name.isNotEmpty && email.isNotEmpty && contact.isNotEmpty) {
      final participant = Participant(
        id: id,
        name: name,
        email: email,
        contact: contact,
        dateOfBirth: dateOfBirth,
        category: category,
      );

      setState(() {
        participants.add(participant);
        filteredParticipants.add(participant);
      });

      clearFields();
    } else {
      Fluttertoast.showToast(
        msg: 'Please fill in all the fields',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void editParticipant(Participant participant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Participant'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: idController..text = participant.id.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ID'),
                ),
                TextField(
                  controller: nameController..text = participant.name,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController..text = participant.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: contactController..text = participant.contact,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Contact'),
                ),
                InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: participant.dateOfBirth ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((selectedDate) {
                      setState(() {
                        dateOfBirth = selectedDate;
                        dateOfBirthController.text = selectedDate != null
                            ? '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}'
                            : '';
                      });
                    });
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      hintText: 'Select Date',
                    ),
                    child: Text(participant.dateOfBirth != null
                        ? '${participant.dateOfBirth!.day}-${participant.dateOfBirth!.month}-${participant.dateOfBirth!.year}'
                        : 'Select Date'),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: participant.category,
                  decoration: InputDecoration(labelText: 'Category'),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: '8-12',
                      child: Text('8-12'),
                    ),
                    DropdownMenuItem<String>(
                      value: '13-18',
                      child: Text('13-18'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                clearFields();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                updateParticipant(participant);
              },
            ),
          ],
        );
      },
    );
  }

  void updateParticipant(Participant participant) {
    final id = int.tryParse(idController.text);
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final contact = contactController.text.trim();
    final category = selectedCategory;

    if (id != null && name.isNotEmpty && email.isNotEmpty && contact.isNotEmpty) {
      final updatedParticipant = Participant(
        id: id,
        name: name,
        email: email,
        contact: contact,
        dateOfBirth: dateOfBirth,
        category: category,
      );

      setState(() {
        participants.remove(participant);
        participants.add(updatedParticipant);

        filteredParticipants.remove(participant);
        filteredParticipants.add(updatedParticipant);
      });

      clearFields();
      Navigator.of(context).pop(); // Close the dialog
    } else {
      Fluttertoast.showToast(
        msg: 'Please fill in all the fields',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void deleteParticipant(Participant participant) {
    setState(() {
      participants.remove(participant);
      filteredParticipants.remove(participant);
    });
  }

  void clearFields() {
    idController.clear();
    nameController.clear();
    emailController.clear();
    contactController.clear();
    dateOfBirthController.clear();
    setState(() {
      dateOfBirth = null;
      selectedCategory = '8-12';
    });
  }
}
