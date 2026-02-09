import 'package:flutter/material.dart';

class CompoundListScreen extends StatelessWidget {
  const CompoundListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Compounds')),
      body: const Center(
        child: Text('Compound list will appear here'),
      ),
    );
  }
}
