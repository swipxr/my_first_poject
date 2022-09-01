import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  static const String routeName = "/contact";
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Screen"),
      ),
      body: Container(
        child: Center(
          child: Text("Contact Screen"),
        ),
      ),
    );
  }
}
