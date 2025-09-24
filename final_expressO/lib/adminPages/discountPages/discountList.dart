import 'package:flutter/material.dart';
import 'package:firebase_nexus/appColors.dart';

class DiscountListPage extends StatelessWidget {
  const DiscountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: const Text(
          "Discount Codes",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Discount List Screendssdsdssdds',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
