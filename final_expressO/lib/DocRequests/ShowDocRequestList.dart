import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_nexus/FirebaseOperations/FirebaseuserService.dart';

Widget buildListView(
    List<Map<String, dynamic>> items, Function(String) onItemTap) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Column(
        children: [
          Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            elevation: 2, // Adds shadow effect
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Color(0xFFC3C3C3), width: 1), // Gray border
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            child: ListTile(
              title: Text(
                items[index]['title'],
                style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0)), // Set font size
              ),
              subtitle: Text(
                '${items[index]['status'] ?? 'Pending'}',
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              onTap: () async {
                selectedRequest = items[index];
                Navigator.pushNamed(context, '/viewReqDeets');
              },
              leading: const Icon(Icons.file_present),
              trailing: const Icon(Icons.arrow_forward),
            ),
          ),
          const SizedBox(height: 10), // Adds spacing between cards
        ],
      );
    },
  );
}

class ShowDocRequests extends StatefulWidget {
  const ShowDocRequests({super.key});

  @override
  State<ShowDocRequests> createState() => _ShowDocRequestsState();
}

class _ShowDocRequestsState extends State<ShowDocRequests> {
  List<Map<String, dynamic>> myItems = []; // Non-nullable list
  bool searched = false;
  void handleItemTap(String item) {
    print("Tapped on $item");
  }

  @override
  void initState() {
    super.initState();
    fetchDocsRequests();
  }

  Future<void> fetchDocsRequests() async {
    final data = await Firebaseuserservice.getMasterList(
        uid as String, 'requests', 'requester');
    List<String> preItems = [];

    if (data != null) {
      for (var item in data) {
        if (item['status'] == 'pending' || item['status'] == 'approved') {
          preItems.add(item['entityID']);
        }
      }
    }

    excepmtedList = preItems;
    // data
    //     ?.map((item) {
    //       if (item['status'] == 'pending') {
    //         return item['entityID'];
    //       }
    //     }).toList();

    // print("akmdaksmdasmdoksafeqomqeqepqwmdqwd");
    // print(excepmtedList);

    // data?.forEach((item) {
    //   if (item['status'] == 'pending') {
    //     excepmtedList?.add(item['entityID']);
    //   }
    // });

    setState(() {
      searched = true;
    });

    if (data != null) {
      setState(() {
        myItems = data;
      });
    } else {
      setState(() {
        myItems = [];
      });
    }

    // print(myItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Your custom logic here
            print("Back button pressed");
            // Example: Navigate somewhere specific
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: const Text(
          'Your Document Requests',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adjust padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: !searched
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loading indicator
                  : myItems.isNotEmpty
                      ? buildListView(
                          myItems.map((doc) => doc).toList(),
                          handleItemTap,
                        )
                      : const Center(
                          child: Text("You haven't made any requests yet")),
            ),

            const SizedBox(height: 60), // Spacing before button
          ],
        ),
      ),

      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 25, vertical: 20), // Adjust margins
        width: double.infinity, // Full width
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF006644),
          onPressed: () {
            Navigator.pushNamed(context, '/viewDocList');
          },
          icon: const Icon(Icons.send, color: Colors.white),
          label: const Text(
            'Create Request',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Change the roundness
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // Centered at the bottom
    );
  }
}
