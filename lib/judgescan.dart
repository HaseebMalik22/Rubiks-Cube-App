import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rubikscube/Homepage.dart';
import 'package:rubikscube/judgeroundselection.dart';



class JudgeScan extends StatefulWidget {
  @override
  _JudgeScanState createState() => _JudgeScanState();
}

class _JudgeScanState extends State<JudgeScan> {
  String selectedAttempts = '';
  String enteredTime = '';
  String participantName = '';
  String participantID = '';

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  bool isScanning = false;

  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participant Scan'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judge Name: John Doe',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Judge ID: J123456',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Container(
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Participant Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Participant Name: $participantName',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Participant ID: $participantID',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Round Name: Round 1',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Attempts:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Attempt 1'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 40), // Increase icon size
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: timeController,
                          decoration: InputDecoration(
                            labelText: 'Time',
                          ),
                          keyboardType: TextInputType.datetime,
                          style: TextStyle(fontSize: 30),
                          onChanged: (value) {
                            setState(() {
                              enteredTime = value;
                            });
                          },
                          inputFormatters: [
                            _TimeInputFormatter(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            enteredTime = incrementTimeByOneSecond(enteredTime);
                            timeController.text = enteredTime;
                          });
                        },
                        child: Text('+1'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            enteredTime = 'DNF';
                            timeController.text = enteredTime;
                          });
                        },
                        child: Text('DNF'),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.qr_code, size: 32), // Increase icon size
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _startScan();
                        },
                        child: Text(
                          'Scan QR Code',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (isScanning)
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _startScan() {
    setState(() {
      isScanning = true;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    qrController!.scannedDataStream.listen((scanData) {
      setState(() {
        participantName = scanData.code!;
        participantID = scanData.code!;
        isScanning = false;
      });
      qrController!.dispose();
    });
  }

  Future<void> _showConfirmationDialog() async {
    String displayTime = enteredTime;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Please confirm the given information before submitting'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Judge Name: John Doe'),
                  Text('Participant ID: $participantID'),
                  Text('Participant Name: $participantName'),
                  Text('Round: Round 1'),
                  Text('Attempts: Attempt 1'),
                  Text('Time: $displayTime'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       displayTime = incrementTimeByOneSecond(displayTime);
                //       timeController.text = displayTime;
                //     });
                //   },
                //   child: Text('+1'),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       displayTime = 'DNF';
                //       timeController.text = displayTime;
                //     });
                //   },
                //   child: Text('DNF'),
                // ),
                ElevatedButton(
                  onPressed: () {
                    _addParticipant();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JudgeRoundSelectionScreen(),
                      ),
                    );

                    // Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: 'Participant added',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                  },
                  child: Text('Confirm'),

                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addParticipant() {

    // Add logic to save the participant's information and submission
    // to your data source or perform any other required actions.
    print('Participant added:');
    print('Participant Name: $participantName');
    print('Participant ID: $participantID');
    print('Round: Round 1');
    print('Attempts: Attempt 1');
    print('Time: $enteredTime');

  }

  String incrementTimeByOneSecond(String time) {
    // Add logic to increment the time by one second
    if (time.isEmpty || time == 'DNF') {
      return '00:01:000';
    }

    final parts = time.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    final milliseconds = int.parse(parts[2]);

    final totalMilliseconds = ((minutes * 60) + seconds) * 1000 + milliseconds + 1000;
    final newMinutes = (totalMilliseconds ~/ (60 * 1000)) % 60;
    final newSeconds = (totalMilliseconds ~/ 1000) % 60;
    final newMilliseconds = totalMilliseconds % 1000;

    final formattedMinutes = newMinutes.toString().padLeft(2, '0');
    final formattedSeconds = newSeconds.toString().padLeft(2, '0');
    final formattedMilliseconds = newMilliseconds.toString().padLeft(3, '0');

    return '$formattedMinutes:$formattedSeconds:$formattedMilliseconds';
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

void main() {
  runApp(MaterialApp(
    title: 'Judge Scan',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: JudgeScan(),
  ));
}
