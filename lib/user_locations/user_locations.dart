import 'package:flutter/material.dart';

class UserLocationsScreen extends StatefulWidget {
  const UserLocationsScreen({super.key});

  @override
  State<UserLocationsScreen> createState() => _UserLocationsScreenState();
}

class _UserLocationsScreenState extends State<UserLocationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Locations Screen")),
    );
  }
}
