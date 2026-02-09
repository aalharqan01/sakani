import 'package:flutter/material.dart';

class MaintenanceListScreen extends StatelessWidget {
  const MaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance')),
      body: const Center(
        child: Text('Maintenance requests will appear here'),
      ),
    );
  }
}
