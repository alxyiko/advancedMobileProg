import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_nexus/FirebaseOperations/FirebaseuserService.dart';

Widget buildListView(
    List<Map<String, dynamic>> items, Function(String, String) onItemTap) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(5), // Rounded corners
          border: Border.all(
            color: const Color(0xFFC3C3C3), // Border color
            width: 1, // Border width
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19919191), // Light shadow
              blurRadius: 3,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10), // Padding inside
          title: Text(
            '${items[index]["action"]} on  ${Firebaseuserservice.formatTimestamp(items[index]["createdAt"] as Timestamp)}', // Assuming this is your item text
            style: const TextStyle(
              color: Color.fromARGB(255, 39, 39, 39), // Text color
              fontSize: 16,
              fontWeight:
                  FontWeight.w500, // Medium weight for better visibility
            ),
          ),
          onTap: () {
            onItemTap(items[index]['type'], items[index]['uuid']);
            // Navigator.pushNamed(context, '/requestList/viewRequest');
          },
          leading: const Icon(Icons.list,
              color: Color.fromARGB(255, 134, 134, 134)), // Leading icon
          trailing: const Icon(Icons.arrow_forward,
              color: Color.fromARGB(255, 134, 134, 134)), // Trailing icon
        ),
      );
    },
  );
}

class ShowNotification extends StatefulWidget {
  const ShowNotification({super.key});

  @override
  State<ShowNotification> createState() => _ShowNotificationState();
}

class _ShowNotificationState extends State<ShowNotification> {
  List<Map<String, dynamic>> myItems = []; // Non-nullable list
  bool searched = false;
  

  @override
  void initState() {
    super.initState();
    fetchDocsRequests();
  }

  Future<void> fetchNotifObject(type, docPath) async {
    print(docPath);
    setState(() {
      searched = false;
    });
    DocumentReference docRef = FirebaseFirestore.instance.doc(docPath);
    DocumentSnapshot docSnap = await docRef.get();

    setState(() {
      searched = true;
    });

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
      print("Document Data: $data");

      if (type == 'pa') {
        selectedApplication = {...data, 'id': docSnap.id};
        Navigator.pushNamed(context, '/viewProgDeets');
      } else if (type == 'dr') {
        selectedRequest = {...data, 'id': docSnap.id};
        Navigator.pushNamed(context, '/viewReqDeets');
      }
    } else {
      print("Document does not exist");
    }
    // print(myItems);
  }

  Future<void> fetchDocsRequests() async {
    final data =
        await Firebaseuserservice.getList(uid as String, 'notifications');

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
        title: const Text(
          'Notifications & Updates',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ),
      body: !searched
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : myItems.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.all(20), // Padding of 20 on all sides
                  child: buildListView(myItems.toList(), fetchNotifObject),
                )
              : const Center(
                  child: Text("You haven't made any actions yet"),
                ),
    );
  }
}
