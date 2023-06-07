import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';






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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'dateOfBirth': dateOfBirth?.toString(),
      'category': category,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      contact: map['contact'],
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.parse(map['dateOfBirth'])
          : null,
      category: map['category'],
    );
  }
}

class ParticipantScreen extends StatefulWidget {
  @override
  _ParticipantScreenState createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  final List<Participant> participants = [];
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
  void initState() {
    super.initState();
    fetchParticipants();
  }

  Future<void> fetchParticipants() async {
    final dbHelper = DatabaseHelper.instance;
    final Database db = await dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('participants');

    setState(() {
      participants.clear();
      filteredParticipants.clear();
      participants.addAll(maps.map((map) => Participant.fromMap(map)));
      filteredParticipants.addAll(participants);
    });
  }


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
              // Handle logout
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
                                  ? '${dateOfBirth!.day}-${dateOfBirth!
                                  .month}-${dateOfBirth!.year}'
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
                            decoration: InputDecoration(
                                labelText: 'Search by ID'),
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
                            applySearchFilter(searchQuery);
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

  void applySearchFilter(String searchQuery) async {
    final dbHelper = DatabaseHelper.instance;
    final Database db = await dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'participants',
      where: 'id LIKE ? OR name LIKE ?',
      whereArgs: ['%$searchQuery%', '%$searchQuery%'],
    );

    setState(() {
      filteredParticipants = maps.map((map) => Participant.fromMap(map)).toList();
    });
  }




  Future<void> addParticipant() async {
    final dbHelper = DatabaseHelper.instance;

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

      final result = await dbHelper.addParticipant(participant.toMap());

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
      context: this.context,
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
                            ? '${selectedDate.day}-${selectedDate
                            .month}-${selectedDate.year}'
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
                        ? '${participant.dateOfBirth!.day}-${participant
                        .dateOfBirth!.month}-${participant.dateOfBirth!.year}'
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateParticipant(participant);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void updateParticipant(Participant participant) async {
    final dbHelper = DatabaseHelper.instance;

    final id = int.tryParse(idController.text);
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final contact = contactController.text.trim();
    final category = selectedCategory;

    if (id != null && name.isNotEmpty && email.isNotEmpty && contact.isNotEmpty) {
      // Create a new Participant object with the updated details
      Participant updatedParticipant = Participant(
        id: id,
        name: name,
        email: email,
        contact: contact,
        dateOfBirth: dateOfBirth,
        category: category,
      );

      // Update the participant in the database
      await dbHelper.updateParticipant(updatedParticipant.toMap());

      setState(() {
        // Find the index of the participant in the participants list
        int index = participants.indexWhere((p) => p.id == participant.id);
        if (index != -1) {
          // Update the participant in the participants list
          participants[index] = updatedParticipant;
        }

        // Find the index of the participant in the filteredParticipants list
        int filteredIndex =
        filteredParticipants.indexWhere((p) => p.id == participant.id);
        if (filteredIndex != -1) {
          // Update the participant in the filteredParticipants list
          filteredParticipants[filteredIndex] = updatedParticipant;
        }
      });

      clearFields();
    } else {
      Fluttertoast.showToast(
        msg: 'Please fill in all the fields',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }


  void deleteParticipant(Participant participant) {
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Participant'),
          content: Text('Are you sure you want to delete this participant?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteParticipantFromDatabase(participant);
                setState(() {
                  participants.remove(participant);
                  filteredParticipants.remove(participant);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteParticipantFromDatabase(Participant participant) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    final id = participant.id;

    await db.delete(
      'participants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  void clearFields() {
    idController.clear();
    nameController.clear();
    emailController.clear();
    contactController.clear();
    dateOfBirthController.clear();
    setState(() {
      dateOfBirth = null;
    });
  }
}
