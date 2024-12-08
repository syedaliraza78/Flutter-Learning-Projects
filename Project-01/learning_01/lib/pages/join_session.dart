// ignore_for_file: sort_child_properties_last, non_constant_identifier_names, prefer_const_constructors, unused_local_variable, unnecessary_null_comparison, use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:sign_speak/firebase_db/firebase_db.dart';

class JoinSession extends StatefulWidget {
  final String user;

  const JoinSession({required this.user, super.key});

  @override
  State<JoinSession> createState() => _JoinSessionState();
}

class _JoinSessionState extends State<JoinSession> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: Height * 0.03),
                  child: const Text(
                    "Join Session",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.blue,
                      fontWeight: FontWeight.w900,
                    ),
                  )),
              Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: const Text(
                    "Safe and Secure Conference",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.only(top: 5),
                  child: const Text(
                    "Session Code",
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.blue,
                      fontWeight: FontWeight.w900,
                    ),
                  )),
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    hintText: '  Enter Meeting Code',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.3),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(width: 1.5, color: Colors.blue),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(width: 1.5, color: Colors.blue),
                    ),
                  ),
                ),
              ),
              Container(
                height: Height * 0.45,
                padding: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/joinmeeting.png'),
                    opacity: 0.6,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: Height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.only(
                            top: 17,
                            bottom: 17,
                            left: Width * 0.11,
                            right: Width * 0.11,
                          )),
                    ),
                    // join
                    ElevatedButton(
                      onPressed: () async {
                        String? sessionCode = await FirestoreService.searchSessionCode(myController.text);
                        if (sessionCode == myController.text) {
                          if (widget.user == 'Deaf') {
                            Navigator.pushNamed(context, '/deafcalling',
                                arguments: {
                                  'user': widget.user,
                                  'roomID': myController.text,
                                });
                          } else {
                            Navigator.pushNamed(context, '/listenercalling',
                                arguments: {
                                  'user': widget.user,
                                  'roomID': myController.text,
                                });
                          }
                        } else if ( myController.text == ""){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Field is Empty')),
                          );
                        } else {
                          print('$myController.text: ==============');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('SessionCode is not Valid')),
                          );
                        }
                      },
                      child: const Text(
                        "Join",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.only(
                            top: 17,
                            bottom: 17,
                            left: Width * 0.13,
                            right: Width * 0.13,
                          )),
                    ),
                  ],
                ),
              )
            ],
                  ),
                ),
          ),
        ));
  }
}
