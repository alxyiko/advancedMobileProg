 
import 'package:firebase_nexus/appColors.dart';
import 'package:flutter/material.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({super.key});

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0, // Align the leading icon to the left
        backgroundColor: AppColors.secondary,
        title: const Text(
          'Profile',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner

          : userData != null
              ? SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Container(
                        color: AppColors.primaryVariant,
                        padding:
                            const EdgeInsets.only(left: 25, right: 15, top: 20),
                        width: double.infinity,
                        height: 210,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Registered Resident",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ("${userData!['firstname']} ${userData!['middlename']} ${userData!['lastname']}"),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${userData!['email']}",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Barangay",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            Text("${userData!['barangay']}",
                                style: const TextStyle(
                                    color: Color(0xFF3F4147),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 15),
                            const Text("Subdivision",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            Text("${userData!['subdiv']}",
                                style: const TextStyle(
                                    color: Color(0xFF3F4147),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 15),
                            const Text("Street",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            Text("${userData!['street']}",
                                style: const TextStyle(
                                    color: Color(0xFF3F4147),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 15),
                            const Text("House Number",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            Text("${userData!['housenum']}",
                                style: const TextStyle(
                                    color: Color(0xFF3F4147),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 15),
                            const Text("Gender",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            Text("${userData!['gender']}",
                                style: const TextStyle(
                                    color: Color(0xFF3F4147),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 200),
                          ],
                        ),
                      ),
                    ]))

              // ? Column(
              //     children: [
              //       Text("Name: ${userData!['firstname']} ${userData!['middlename']}. ${userData!['lastname']}"),
              //       Text("Barangay: ${userData!['barangay']}"),
              //       Text("Email: ${userData!['email']}"),
              //       Text("Email: ${userData!['email']}"),
              //       Text("subdiv: ${userData!['subdiv']}"),
              //       Text("street: ${userData!['street']}"),
              //       Text("housenum: ${userData!['housenum']}"),
              //       Text("barangay: ${userData!['barangay']}"),
              //       Text("gender: ${userData!['gender']}"),
              //     ],
              //   )
              : const Center(child: Text("User not found")),
    );
  }
}
