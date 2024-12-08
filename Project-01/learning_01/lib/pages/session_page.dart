// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously, non_constant_identifier_names, unused_local_variable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_speak/firebase_db/firebase_db.dart';
import 'package:sign_speak/pages/home_page.dart';
import 'package:sign_speak/pages/join_session.dart';
import 'dart:math';
import 'package:clipboard/clipboard.dart';

class SessionPage extends StatefulWidget {
  final String user;
  const SessionPage({required this.user, super.key});

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              icon: const Icon(
                color: Colors.white,
                Icons.home,
                size: 40,
              )),
          toolbarHeight: 60,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              height: Height * 0.3,
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  image: DecorationImage(
                    image: AssetImage('images/meetingicon.png'),
                    opacity: 0.7,
                  )),
            ),
            Container(
                height: Height * 0.5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 0,
                      ),
                      child: Container(
                        transform: Matrix4.translationValues(0.0, -80.0, 0.0),
                        height: 170,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),

                        //Circle and Button
                        child: Column(
                          children: [
                            Container(
                                height: 120,
                                width: 120,
                                transform:
                                    Matrix4.translationValues(0.0, -40.0, 0.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(60)),
                                  border: Border.all(color: Colors.blue),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.meetup,
                                    size: 80,
                                    color: Colors.blue,
                                  ),
                                )),
                            // new container create

                            Container(
                              transform:
                                  Matrix4.translationValues(0.0, -20.0, 0.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  showMeetingCodeDialog(context,
                                      widget.user); //Pass sessionCode here
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.only(
                                        left: 60,
                                        right: 60,
                                        top: 10,
                                        bottom: 10)),
                                child: const Text(
                                  'Create',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: Container(
                        height: 170,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),

                        //Image and Button
                        child: Column(
                          children: [
                            Container(
                                height: 120,
                                width: 120,
                                transform:
                                    Matrix4.translationValues(0.0, -40.0, 0.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(60)),
                                  border: Border.all(color: Colors.blue),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.meetup,
                                    size: 80,
                                    color: Colors.blue,
                                  ),
                                )),
                            Container(
                              transform:
                                  Matrix4.translationValues(0.0, -20.0, 0.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => JoinSession(
                                              user: widget.user)));
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.only(
                                        left: 70,
                                        right: 70,
                                        top: 10,
                                        bottom: 10)),
                                child: const Text(
                                  'Join',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  //Updated method to accept sessionCode as argument
  void showMeetingCodeDialog(BuildContext context, String user) {
    String sessionCode = (Random().nextInt(9999) + 10000).toString();

    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    Widget nextButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 60.0, vertical: 10.0),
              ),
              child: const Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                FirestoreService.addSessionCode(sessionCode, sessionCode);
                if (widget.user == 'Normal') {
                  print(widget.user + ' User printed');
                  Navigator.pushNamed(context, '/listenercalling', arguments: {
                    'user': widget.user,
                    'roomID': sessionCode,
                  });
                } else if (widget.user == 'Deaf') {
                  print(widget.user + 'Deaf User printed');
                  Navigator.pushNamed(context, '/deafcalling', arguments: {
                    'user': widget.user,
                    'roomID': sessionCode,
                  });
                }
              }),
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: const EdgeInsets.only(top: 20.0),
      title: Center(
        child: Text(
          "Session Code",
          style: TextStyle(
            color: Colors.blue.shade700,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Width * 0.15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Text(
                    sessionCode,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    await FlutterClipboard.copy(sessionCode);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("SessionCode Copied To Clipboard")),
                      );
                    }
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          nextButton,
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }





}
