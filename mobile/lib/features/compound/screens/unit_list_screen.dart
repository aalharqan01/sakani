import 'package:flutter/material.dart';

class UnitListScreen extends StatelessWidget {
  const UnitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Units')),
      body: const Center(
        child: Text('Unit list will appear here'),
      ),
    );
  }
}
