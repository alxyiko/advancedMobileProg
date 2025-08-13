import 'dart:async';
import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_nexus/FirebaseOperations/FirebaseuserService.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowAnnouncementDetails extends StatefulWidget {
  const ShowAnnouncementDetails({super.key});

  @override
  State<ShowAnnouncementDetails> createState() => _ShoRrequirementsStateList();
}

class _ShoRrequirementsStateList extends State<ShowAnnouncementDetails> {
  final GlobalKey<FormState> _requestForm = GlobalKey<FormState>();

  Future<void> _openLink() async {
    final Uri url = Uri.parse(selectedAnnouncement?['outsideLink']);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void focusPhoto() {
    Navigator.pushNamed(context, '/viewAnnoucementPhoto');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'View Announcement',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _requestForm,
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Announcement: ${selectedAnnouncement?['title']}',
                              style: const TextStyle(
                                color: Color(0xFF5E5E5E),
                                fontSize: 24,
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        GestureDetector(
                          onTap: focusPhoto,
                          child: Image.network(
                          selectedAnnouncement?['imageLink'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${selectedAnnouncement?['subtitle']} \n ${selectedAnnouncement?['content']} \n\nDate Announced: ${Firebaseuserservice.formatTimestamp(selectedAnnouncement?['createdAt'])}',
                            style: const TextStyle(
                              color: Color(0xFF2E2E2E),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 55),
                Column(
                  children: [
                    FloatingActionButton.extended(
                      onPressed: _openLink,
                      label: const Text(
                        'Go to Link',
                        style: TextStyle(
                            color: Color(0xFF006644),
                            fontSize: 16), // Makes text invisible
                      ),
                      icon: const Icon(
                        Icons.arrow_outward_rounded,
                        color: Color(0xFF006644), // Makes icon invisible
                      ),
                      backgroundColor:
                          Colors.transparent, // Makes button invisible
                      elevation: 0, // Removes shadow
                    ),
                    const SizedBox(height: 15),
                    FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: const Text(
                        'Back Home',
                        style: TextStyle(
                            color: Color(0xFF006644),
                            fontSize: 16), // Makes text invisible
                      ),
                      backgroundColor:
                          Colors.transparent, // Makes button invisible
                      elevation: 0, // Removes shadow
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
