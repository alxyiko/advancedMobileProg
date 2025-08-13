import 'package:firebase_nexus/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DummyOrderPage extends StatelessWidget {
  const DummyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dummy List Page'),
      ),
      body: ListView.builder(
        itemCount: 10, // Dummy length
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item #$index'),
            subtitle: Text('Provider value: ${navProvider.selectedIndex}'),
          );
        },
      ),
    );
  }
}
