import 'package:firebase_nexus/appColors.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: const Text(
          "Admin Home",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.blueGrey,
            alignment: Alignment.center,
            child: const Text(
              "Banner",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          const SizedBox(height: 16),

          // Buttons Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("Button 1")),
                ElevatedButton(onPressed: () {}, child: const Text("Button 2")),
                ElevatedButton(onPressed: () {}, child: const Text("Button 3")),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Horizontal ListView
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Horizontal List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.amber[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Item ${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
