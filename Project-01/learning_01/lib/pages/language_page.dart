// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:sign_speak/pages/home_page.dart';
import 'package:sign_speak/pages/session_page.dart';

class LanguageSelectionPage extends StatefulWidget { 
  final String user;
  LanguageSelectionPage({required this.user, super.key});

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
          actions: [
            Image.asset('images/icon.png'),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Text(
                "Welcome to Sign Speak",
                style: TextStyle(color: Colors.blue, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Choose your Language",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: (Height * 0.05)),

              // Language Buttons
              LanguageButton(
                language: 'English',
                isSelected: selectedLanguage == 'English',
                onTap: () => setState(() => selectedLanguage = 'English'),
              ),
              const SizedBox(height: 40),
              LanguageButton(
                language: 'Urdu',
                isSelected: selectedLanguage == 'Urdu',
                onTap: () => setState(() => selectedLanguage = 'Urdu'),
              ),

              SizedBox(height: Height * 0.2),
              const Text(
                "Your language preference can be changed at any time in the settings.",
                style: TextStyle(color: Colors.blue, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SessionPage(user: widget.user)));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 15, bottom: 15),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// LanguageButton Widget
class LanguageButton extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageButton({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding:
            const EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.blue, width: 1.5),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.blue.shade100, blurRadius: 15)]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: TextStyle(
                fontSize: 20,
                color: isSelected ? Colors.white : Colors.blue,
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.white : Colors.blue,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}