import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoundSetupScreen extends StatefulWidget {
  @override
  _RoundSetupScreenState createState() => _RoundSetupScreenState();
}

class _RoundSetupScreenState extends State<RoundSetupScreen> {
  String selectedPreviousQualified = '1';
  String selectedParticipant = 'Select All';
  String selectedJudge = 'Select All';
  String selectedAgeGroup = '8-12';
  String roundName = '';
  String matchName = '';

  List<String> previousQualifiedOptions = ['1', '2', '3','4','5','6'];

  List<String> participantOptions = ['Select All', 'Participant 1', 'Participant 2', 'Participant 3'];

  List<String> judgeOptions = ['Select All', 'Judge 1', 'Judge 2', 'Judge 3'];

  List<String> ageGroupOptions = ['8-12', '13-16', 'All age group'];

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round Setup'),
      ),
      body: Center(
        child: Padding(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Round Setup',
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
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Match Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          matchName = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Round Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          roundName = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Attempts',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: selectedPreviousQualified,
                      onChanged: (value) {
                        setState(() {
                          selectedPreviousQualified = value!;
                        });
                      },
                      items: previousQualifiedOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Participant',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: selectedParticipant,
                      onChanged: (value) {
                        setState(() {
                          selectedParticipant = value!;
                        });
                      },
                      items: participantOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                          key: ValueKey(option),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Judge',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: selectedJudge,
                      onChanged: (value) {
                        setState(() {
                          selectedJudge = value!;
                        });
                      },
                      items: judgeOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                          key: ValueKey(option),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Age Group',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: selectedAgeGroup,
                      onChanged: (value) {
                        setState(() {
                          selectedAgeGroup = value!;
                        });
                      },
                      items: ageGroupOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Perform desired action with round setup data
                        if (matchName.isNotEmpty &&
                            roundName.isNotEmpty &&
                            selectedParticipant.isNotEmpty &&
                            selectedJudge.isNotEmpty &&
                            selectedPreviousQualified.isNotEmpty &&
                            selectedAgeGroup.isNotEmpty) {
                          _showToastMessage('Round Set');
                        } else {
                          _showToastMessage('Please fill in all fields');
                        }
                      },
                      child: Text('Set Round'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
