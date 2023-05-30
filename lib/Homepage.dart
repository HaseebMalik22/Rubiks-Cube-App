import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rubikscube/dashboard.dart';
import 'package:rubikscube/judgeroundselection.dart';
import 'package:rubikscube/judgescan.dart';
import 'package:rubikscube/headjudgescreen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Center(
          child: Text("Login Page"),
        ),
      ),
      body: const MyStatefulWidget(),
      backgroundColor: Colors.white,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Rubiks Cube',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Login in',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Add spacing between fields
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                SizedBox(height: 10), // Add spacing between containers
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              final username = nameController.text;
              final password = passwordController.text;

              if (username == 'admin' && password == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              } else if (username == 'judge' && password == 'judge') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JudgeRoundSelectionScreen()),
                );
              } else if (username == 'hjudge' && password == 'hjudge') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HeadJudgeScreen()),
                );
              }
              else {
                Fluttertoast.showToast(
                  msg: 'Incorrect credentials',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow,
              onPrimary: Colors.black,
              textStyle: const TextStyle(fontSize: 18.0),
              padding: const EdgeInsets.symmetric(vertical: 15.0),
            ),
          ),
          TextButton(
            onPressed: () {
              //forgot password screen
            },
            child: const Text(
              'Forgot Password',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              const Text('Does not have an account?'),
              TextButton(
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  //signup screen
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}
