import 'package:flutter/material.dart';

class adminTransactionHistory extends StatelessWidget {
  const adminTransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: const Color(0xFF5D3510),
      ),
      body: const Center(
        child: Text('This is the Transaction History page (placefwfewefwefholder).'),
      ),
    );
  }
}