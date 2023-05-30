import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MatchSetupScreen2 extends StatefulWidget {
  final String matchName;

  MatchSetupScreen2({required this.matchName});

  @override
  _MatchSetupScreen2State createState() => _MatchSetupScreen2State();
}

class _MatchSetupScreen2State extends State<MatchSetupScreen2> {
  String? selectedPreviousMatch;
  String? selectedFilter;
  String? selectedCriteria;

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
        title: Text('Match Setup 2'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Match Name: ${widget.matchName}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Select from previous matches:',
                    style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // child: Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 16.0),
                    //   child: DropdownButton<String>(
                    //     value: selectedPreviousMatch,
                    //     items: <String>['Match 1', 'Match 2', 'Match 3']
                    //         .map((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //     onChanged: (selectedValue) {
                    //       setState(() {
                    //         selectedPreviousMatch = selectedValue;
                    //       });
                    //     },
                    //     isExpanded: true,
                    //     underline: SizedBox(),
                    //   ),
                    // ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Selection Filter:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        items: <String>['1', '2', '3']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (selectedValue) {
                          setState(() {
                            selectedFilter = selectedValue;
                          });
                        },
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Selection Criteria:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: selectedCriteria,
                        items: <String>['Best Time', 'Average Time']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (selectedValue) {
                          setState(() {
                            selectedCriteria = selectedValue;
                          });
                        },
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle cancel button press
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _showToastMessage('Match created successfully');
                      },
                      child: Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
