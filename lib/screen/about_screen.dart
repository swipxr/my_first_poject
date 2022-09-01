import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  static const String routeName = "/about";
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Screen"),
      ),
      body: Container(
        child: Center(
          child: Text("About Screen"),
        ),
      ),
    );
  }
}
