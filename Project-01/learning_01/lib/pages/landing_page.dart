// ignore_for_file: camel_case_types, library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names, avoid_unnecessary_containers

import 'dart:async';

import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _landingPage createState() => _landingPage();
}

class _landingPage extends State<LandingPage> {
  Future<void> loadHomePage() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    loadHomePage();
  }

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          child: Stack(
            children: [
              // white color
              ClipPath(
                clipper: LandingCurve(),
                child: Container(
                  height: 600,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
              // Using Positioned to control the image inside the Stack
              Positioned(
                top: 100,
                left: Width * 0.12,
                child: Column(
                  children: [
                    Image.asset(
                      'images/icon.gif',
                      height: 300, // Set the size of the image here
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    const Row(
                      children: [
                        Text(
                          "Sign Sp",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          "eak",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LandingCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.9);
    path.quadraticBezierTo(
      size.width / 1.7,
      size.height,
      size.width,
      size.height * 0.6,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
