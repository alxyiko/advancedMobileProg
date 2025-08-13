import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:flutter/material.dart';

class ShowAnnoucementphoto extends StatelessWidget {
  const ShowAnnoucementphoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for better contrast
      appBar: AppBar(title: Text(selectedAnnouncement?['title'])),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Allows dragging
          boundaryMargin: const EdgeInsets.all(20), // Extra space for movement
          minScale: 1.0, // No zoom out beyond original size
          maxScale: 5.0, // Maximum zoom
          child: Image.network(
            selectedAnnouncement?['imageLink'], // Change this to your image path
            fit: BoxFit.contain, // Keep image aspect ratio
          ),
        ),
      ),
    );
  }
}
 
