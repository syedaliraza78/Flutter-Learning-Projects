// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_print

import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class SessionLoading extends StatefulWidget {
  final String user;
  final String roomID;
  const SessionLoading({required this.user,required this.roomID, super.key});

  @override
  State<SessionLoading> createState() => _SessionLoadingState();
}

class _SessionLoadingState extends State<SessionLoading> {
  @override
  void initState() {
    super.initState();
    loadMeeting();
  }

  Future<void> loadMeeting() async {
    await Future.delayed(const Duration(seconds: 1));
    if (widget.user == 'Normal') {
      print(widget.user + ' User printed');
      Navigator.pushNamed(context, '/listenercalling', arguments: {
        'user' : widget.user,
        'roomID' : widget.roomID,
      });
    } else if (widget.user == 'Deaf') {
      print(widget.user + 'Deaf User printed');
      Navigator.pushNamed(context, '/deafcalling', arguments: {
        'user' : widget.user,
        'roomID' : widget.roomID,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.4),
              child: const FaIcon(
                FontAwesomeIcons.spinner,
                size: 60,
                color: Colors.blue,
              ),
            ),
          ),
          Container(
            child: const Text(
              "Processing ...",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          )
        ],
      ),
    );
  }
}