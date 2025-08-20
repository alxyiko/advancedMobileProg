import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_nexus/FirebaseOperations/FirebaseuserService.dart';
import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:firebase_nexus/main.dart';
import 'package:firebase_nexus/widgets/app_bottom_nav.dart.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> announcementsList = []; // Non-nullable list
  // Map<String, dynamic>? userData;

  // String  brgy = "";
  bool searched = false;
  bool completedReg = true;
  bool loaded = false;

  final int _selectedIndex = 0;

  // fetchAnnouncements();

  void handleItemTap(Map<String, dynamic> item) {
    setState(() {
      selectedAnnouncement = item;
      print(selectedAnnouncement);
      Navigator.pushNamed(context, '/viewAnnouncementDeets');
    });
  }

  Future<void> fetchUserData() async {
    if (userCreds?.user?.email != null) {
      final data = await Firebaseuserservice.getUserDeets(
          userCreds?.user?.uid as String);
      print("asdadsad");
      print(data);

      setState(() {
        Firebaseuserservice.userData = data;
        loaded = true;
      });

      if (data?['barangay'] == ' ') {
        print('ahaha sige');
        setState(() {
          completedReg = false;
        });
      } else if (data?['barangay'] != ' ') {
        print('ahaha tite');
        setState(() {
          completedReg = true;
        });
      }
    }
  }

  @override
  void initState() {
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF006644),
        // Aesthetic Appbar hihi
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 0, // Align the leading icon to the left
          leading: Padding(
            padding: const EdgeInsets.only(
                left: 16.0), // Adds left spacing for the logo icon
            child: IconButton(
              icon: const Icon(Icons.square), // Placeholder, Temporary Log out
              onPressed: () async {
                // await FirebaseAuth.instance.setPersistence(Persistence.NONE);
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ),

          title: const Row(
            children: [
              Text(
                'Barangay Nexus',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              Spacer(), // Pushes the icons to the right
            ],
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.history,
                  color: Colors.white), // Clock/History Icon
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
            ),

            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white), // Notification Icon
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),

            IconButton(
              icon: const Icon(Icons.account_circle_outlined,
                  color: Colors.white), // Profile Icon
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),

            const SizedBox(width: 8),
            // Adds some spacing at the end
          ],
        ),
        // bottomNavigationBar: const AppBottomNav(),
        body: RefreshIndicator(
            child: SingleChildScrollView(
              child: completedReg != false
                  ? Container(
                      // height: MediaQuery.of(context).size.height * 0.95,
                      child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                              height: MediaQuery.of(context).size.height *
                                  0.15, // 15% of screen height
                              color:
                                  const Color(0xFF006644), // Stacked above red

                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hello, User!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.48,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'How can we assist you today?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFD8F0E8),
                                      fontSize: 16,
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              )),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: MediaQuery.of(context).size.height *
                                0.69, // 15% of screen height
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // border: Border.all(width: 1, color: Color(0xFF8899AE)), // Border
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(66, 120, 120,
                                      120), // Shadow color with 26% opacity
                                  blurRadius: 8, // Softness of the shadow
                                  offset: Offset(2,
                                      5), // Moves the shadow 2px right & 2px down
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.18,
                          left: MediaQuery.of(context).size.width *
                              0.05, // 5% margin from left
                          right: MediaQuery.of(context).size.width *
                              0.05, // 5% margin from right
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/requestList');
                                    },
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      height: 190,
                                      width: 170,
                                      alignment: Alignment
                                          .center, // Ensures everything is centered
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // border: Border.all(width: 1, color: Color(0xFF8899AE)), // Border
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(66, 120, 120,
                                                120), // Shadow color with 26% opacity
                                            blurRadius:
                                                8, // Softness of the shadow
                                            offset: Offset(2,
                                                5), // Moves the shadow 2px right & 2px down
                                          ),
                                        ],
                                      ),

                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // Centers content vertically
                                        mainAxisSize: MainAxisSize
                                            .min, // Prevents unnecessary expansion
                                        children: [
                                          Stack(
                                            alignment: Alignment
                                                .center, // Center the icon inside the circle
                                            children: [
                                              Container(
                                                width:
                                                    80, // Adjust size as needed
                                                height: 80,
                                                decoration: const BoxDecoration(
                                                  color: Color(
                                                      0xFFE2EFEB), // Background color
                                                  shape: BoxShape
                                                      .circle, // Makes it a circle
                                                ),
                                              ),
                                              const Icon(
                                                Icons.description_outlined,
                                                size: 35,
                                                color: Color(
                                                    0xFF006644), // Icon color
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          const Text(
                                            'Document Request',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              Flexible(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/programsList');
                                    },
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      height: 190,
                                      width: 170,
                                      alignment: Alignment
                                          .center, // Ensures everything is centered
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // border: Border.all(width: 1, color: Color(0xFF8899AE)), // Border
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(66, 120, 120,
                                                120), // Shadow color with 26% opacity
                                            blurRadius:
                                                8, // Softness of the shadow
                                            offset: Offset(2,
                                                5), // Moves the shadow 2px right & 2px down
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // Centers content vertically
                                        mainAxisSize: MainAxisSize
                                            .min, // Prevents unnecessary expansion
                                        children: [
                                          Stack(
                                            alignment: Alignment
                                                .center, // Center the icon inside the circle
                                            children: [
                                              Container(
                                                width:
                                                    80, // Adjust size as needed
                                                height: 80,
                                                decoration: const BoxDecoration(
                                                  color: Color(
                                                      0xFFE2EFEB), // Background color
                                                  shape: BoxShape
                                                      .circle, // Makes it a circle
                                                ),
                                              ),
                                              const Icon(
                                                Icons.ballot_outlined,
                                                size: 35,
                                                color: Color(
                                                    0xFF006644), // Icon color
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          const Text(
                                            'Apply a Program',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 380, bottom: 50, left: 30),
                          height: MediaQuery.of(context).size.height *
                              0.40, // 40% of screen height
                          decoration: BoxDecoration(
                            // color: const Color.fromARGB(255, 124, 54, 244),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                12), // Optional: rounded corners
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Announcements',
                                style: TextStyle(
                                  color: Color(0xFF2E2E2E),
                                  fontSize: 20,
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const Text(
                                'Stay informed about the latest updates on our barangay',
                                style: TextStyle(
                                  color: Color(0xFF797B81),
                                  fontSize: 14,
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              const SizedBox(
                                  height: 10), // Space before GridView

                              (loaded == true
                                  ? StreamBuilder<List<Map<String, dynamic>>>(
                                      stream:
                                          Firebaseuserservice.getAnnouncements(
                                              Firebaseuserservice
                                                  .userData?['barangay']),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  "Error: ${snapshot.error}"));
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return const Center(
                                              child: Text(
                                                  "No announcements available."));
                                        }

                                        List<Map<String, dynamic>>
                                            announcementsList = snapshot.data!;

                                        return SizedBox(
                                          height: 240,
                                          child: GridView.builder(
                                            scrollDirection: Axis
                                                .horizontal, // Enable horizontal scrolling
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  1, // Ensures a single row
                                              mainAxisSpacing:
                                                  15, // Space between items
                                              childAspectRatio: 5 / 7,
                                            ),
                                            itemCount: announcementsList
                                                .length, // Number of items
                                            itemBuilder: (context, index) {
                                              return _buildAnnouncementCard(
                                                announcementsList[index],
                                                (announcement) {
                                                  handleItemTap(announcement);
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child:
                                          CircularProgressIndicator()) // Show loading indicator
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person,
                                size: 60,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            const SizedBox(height: 16),
                            const Text(
                              "Only one step left, let's finish setting up your account!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .green, // Change this to any color you prefer
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12), // Adds padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Optional: Rounded corners
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/postGegister');
                              },
                              child: const Text(
                                "Complete Setup",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255,
                                        255)), // Ensures text is visible
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255), // Change this to any color you prefer
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12), // Adds padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Optional: Rounded corners
                                ),
                              ),
                              onPressed: () {
                                if (loaded) {
                                  setState(() {
                                    loaded = false;
                                  });

                                  fetchUserData();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Currently reloading the page, wait!')),
                                  );
                                }
                              },
                              child: Text(
                                loaded ? "Reload Page" : "Reloading Page",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 58, 162,
                                        44)), // Ensures text is visible
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            onRefresh: () async {
              fetchUserData();
            }));
  }
}

Widget _buildAnnouncementCard(Map<String, dynamic> announcement,
    Function(Map<String, dynamic>) onItemTap) {
  return GestureDetector(
    onTap: () => onItemTap(announcement), // Call the function when tapped
    child: Container(
      margin: const EdgeInsets.only(left: 5, top: 10, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(66, 108, 108, 108),
              blurRadius: 6,
              offset: Offset(2, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              announcement['imageLink'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(announcement['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(announcement['subtitle'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
