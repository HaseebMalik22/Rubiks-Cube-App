import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';
import 'database_judgehelper.dart';

class JudgeScreen extends StatefulWidget {
  @override
  _JudgeScreenState createState() => _JudgeScreenState();
}

class _JudgeScreenState extends State<JudgeScreen> with RouteAware {
  List<Map<String, dynamic>> judges = [];
  RouteObserver routeObserver = RouteObserver();

  @override
  void initState() {
    super.initState();
    _loadJudges();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _showAddJudgeDialog() async {
    String name = '';
    String email = '';
    String contact = '';

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add Judge'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                onChanged: (value) {
                  contact = value;
                },
                decoration: InputDecoration(labelText: 'Contact'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Close the dialog without returning a value
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newJudge = {
                  'name': name,
                  'email': email,
                  'contact': contact,
                };

                final id = await DatabaseJudgeHelper.instance.addJudge(newJudge);
                if (id != null) {
                  newJudge['id'] = id as String;
                  setState(() {
                    judges.add(newJudge);
                  });
                  Navigator.of(dialogContext).pop(true); // Close the dialog and return 'true'
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _loadJudges(); // Reload the judges list
    }
  }

  Future<void> _loadJudges() async {
    final loadedJudges = await DatabaseJudgeHelper.instance.getJudges();
    setState(() {
      judges = loadedJudges;
    });
  }

  void _deleteJudge(Map<String, dynamic> judge) async {
    final rowsAffected = await DatabaseJudgeHelper.instance.deleteJudge(judge['id']);
    if (rowsAffected > 0) {
      setState(() {
        judges.remove(judge);
      });
    }
  }

  void _editJudge(Map<String, dynamic> judge) async {
    final updatedJudge = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditJudgeScreen(judge: judge),
      ),
    );

    if (updatedJudge != null) {
      setState(() {
        // Update the judge in the list
        int index = judges.indexWhere((element) => element['id'] == updatedJudge['id']);
        if (index != -1) {
          judges[index] = updatedJudge;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Judges'),
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
      body: ListView.builder(
        itemCount: judges.length,
        itemBuilder: (context, index) {
          final judge = judges[index];
          return Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(8.0),
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
              title: Text(judge['name']),
              subtitle: Text(judge['email']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editJudge(judge);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteJudge(judge);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddJudgeDialog,
        // Handle adding a new judge
      ),
    );
  }
}

class EditJudgeScreen extends StatefulWidget {
  final Map<String, dynamic> judge;

  EditJudgeScreen({required this.judge});

  @override
  _EditJudgeScreenState createState() => _EditJudgeScreenState();
}

class _EditJudgeScreenState extends State<EditJudgeScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.judge['name'];
    _emailController.text = widget.judge['email'];
    _contactController.text = widget.judge['contact'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _updateJudge() async {
    final updatedJudge = {
      'id': widget.judge['id'],
      'name': _nameController.text,
      'email': _emailController.text,
      'contact': _contactController.text,
    };

    final rowsAffected = await DatabaseJudgeHelper.instance.updateJudge(updatedJudge);
    if (rowsAffected > 0) {
      Navigator.pop(context, updatedJudge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Judge'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Contact'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateJudge,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
