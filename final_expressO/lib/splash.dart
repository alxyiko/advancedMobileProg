import 'dart:async';

import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds then navigate to HomeScreen
    Timer(const Duration(seconds: 1), () {
      Navigator.pushNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(

        color: const Color.fromARGB(255, 29, 29, 29),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: Image.asset('assets/logoipsum.png')),
              const Text('Barangay Nexus',style: TextStyle(color: Colors.white),)
            
            ],
          ),
        ),
      )),
    );
  }
}
