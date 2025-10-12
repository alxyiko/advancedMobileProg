import 'package:firebase_nexus/Profile/ShowProfile.dart';
import 'package:firebase_nexus/adminPages/dummyCart.dart';
import 'package:firebase_nexus/providers/navigation_provider.dart';
import 'package:firebase_nexus/views/cartView.dart';
import 'package:firebase_nexus/views/dummyCart.dart';
import 'package:firebase_nexus/views/dummyCartSupa.dart';
import 'package:firebase_nexus/views/MyHomePage.dart';
import 'package:firebase_nexus/views/orderView.dart';
import 'package:firebase_nexus/widgets/app_bottom_nav.dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    final pages = [
      const MyHomePage(),
      const NeilCart(),
      const DummyOrderPage(),
      
      // const SQLitePage(),
      // const SupaPage(),
 
      const ShowProfile(),
    ];

    return Scaffold(
      body: pages[navProvider.selectedIndex],
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
