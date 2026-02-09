import 'package:flutter/material.dart';

class ChequeListScreen extends StatelessWidget {
  const ChequeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cheques')),
      body: const Center(
        child: Text('Cheque list will appear here'),
      ),
    );
  }
}
