// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:sign_speak/pages/language_page.dart';
import 'package:sign_speak/pages/session_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const Icon(Icons.home, size: 40, color: Colors.blue),
          actions: [
            Image.asset(
              'images/icon.png',
              height: 65,
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "Sign Speak",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 120),

              Container(
                height: 160,
                width: 330,
                // padding: const EdgeInsets.only(top: 40, bottom: 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, -40, 0.0),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Container(
                        transform: Matrix4.translationValues(0.0, -30, 0.0),
                        child: Image.asset(
                          'images/Deaficon.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ), // Space for the avatar
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SessionPage(user: 'Deaf')));
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(
                            left: 55, right: 55, top: 5, bottom: 5),
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Deaf',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ), // Position the avatar above the container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.blue, width: 2.0), 
                ),
              ),

              const SizedBox(height: 120),

              Container(
                height: 160,
                width: 330,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, -40, 0.0),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Container(
                        transform: Matrix4.translationValues(0.0, -30, 0.0),
                        child: Image.asset(
                          'images/listener.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ), 
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LanguageSelectionPage(user: "Normal")));
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, top: 5, bottom: 5),
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Listener',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ), 
              
            ],
          ),
        ),
      ),
    );
  }
}