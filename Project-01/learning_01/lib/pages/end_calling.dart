// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_speak/pages/home_page.dart';
import 'package:sign_speak/pages/session_page.dart';

class EndCalling extends StatelessWidget {
  final  String user;
  const EndCalling({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          icon: const Icon(Icons.home, size: 40, color: Colors.blue),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: Height * 0.726,
            padding: EdgeInsets.only(top: Height * 0.3),
            child: const FaIcon(
              FontAwesomeIcons.videoSlash,
              color: Colors.blue,
              size: 150,
            ),
          ),
          Transform.rotate(
            angle: 0.785398, // 45 degrees in radians
            child: Container(
              transform: Matrix4.translationValues(12, 12, 0),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 2, color: Colors.blue),
              ),
              child: Transform.rotate(
                angle: -0.785398, 
                child: Center(
                  
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => SessionPage(user: user)));
                    },
                    icon: const FaIcon(
                    FontAwesomeIcons.meetup,
                    size: 40,
                    color: Colors.blue,
                  ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                height: Height * 0.0868,
                width: Width * 0.5,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.elliptical(90, 90)),
                  color: Colors.blue,
                ),
              ),
              Container(
                height: Height * 0.0868,
                width: Width * 0.5,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.elliptical(90, 90)),
                  color: Colors.blue,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
