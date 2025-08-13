import 'dart:async';
import 'dart:convert';
import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:firebase_nexus/FirebaseOperations/FirebaseuserService.dart';
import 'package:flutter/material.dart';

Widget buildListView(List<dynamic> items, Function onItemTap) {
  return GridView.builder(
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // Number of columns
      crossAxisSpacing: 10, // Space between columns
      mainAxisSpacing: 10, // Space between rows
      childAspectRatio: 4 / 5, // Aspect ratio of each grid item
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () => onItemTap(items[index]), // Trigger action on tap
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            side: const BorderSide(
              color: Color.fromARGB(255, 190, 190, 190), // Border color
              width: 1, // Border width
            ),
          ),

          elevation: 2, // Shadow effect

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment
                    .center, // Centers the button on the image/container
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12), // Round only the top left
                        topRight:
                            Radius.circular(12), // Round only the top right
                      ),
                      child: items[index]['file'] != null
                          ? Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey, // Border color
                                    width: 1, // Border thickness
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                  height: 160,
                                  width: double.infinity,
                                  child: Image.network(items[index]['file'])),
                            )
                          : Container(
                              height: 160,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey, // Border color
                                    width: 1, // Border width
                                  ),
                                ),
                              ),
                            )),
                ],
              ),
              Text(
                items[index]['reqName'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromARGB(255, 48, 48, 48),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      );
    },
  );
}

class ShowRequestDeets extends StatefulWidget {
  const ShowRequestDeets({super.key});

  @override
  State<ShowRequestDeets> createState() => _ShoRrequirementsStateList();
}

class _ShoRrequirementsStateList extends State<ShowRequestDeets> {
  final GlobalKey<FormState> _requestForm = GlobalKey<FormState>();
  bool success = true;
  String remarkText = selectedRequest?['status'] == 'denied' ? "due to ${selectedRequest?['remarks']}" : "";
  bool loading = false;
  String timeText = selectedRequest?['updateTime'] != null ? 'on ${Firebaseuserservice.formatTimestamp(selectedRequest?['updateTime'])}' : "";
  String copiesText = 'Number of Copies: ${selectedRequest?['copies']}';
  String reasonText = 'Reason for Request: ${selectedRequest?['reason']}';
  String requestTitle = selectedRequest?['title'] as String;
  String? file;
  List<dynamic> requirements = [];

  @override
  void initState() {
    super.initState();
    // print(jsonDecode(selectedRequest?['requirmentFiles']));
    print('requestedDoc');
    requirements = (jsonDecode(selectedRequest?['requirmentFiles']))
            ?.map((req) => {
                  'reqName': req['reqName'],
                  'file': req['file'],
                }) // Use null initially
            .toList() ??
        [];

    print(requirements);

    if (selectedRequest == null) {
      backtoRequestList();

      return;
    }
  }

  Future<void> cancelRequest(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Cancellation"),
          content: const Text("Are you sure you want to cancel this request?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                // Perform cancellation logic here
                await Firebaseuserservice.cancelRequest();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request Canceled successfully.'),
                    duration: Duration(seconds: 1),
                  ),
                );

                Navigator.popUntil(context, ModalRoute.withName('/requestList'));
                Navigator.pop(context);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void focusPhoto(Map<String, dynamic> requirementObj) {
    selectedRequirement = requirementObj;
    Navigator.pushNamed(context, '/viewRequirementPhoto');
  }

  void backtoRequestList() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You need to select a document first!')),
    );
    Timer(const Duration(seconds: 2), () {
      Navigator.pushNamed(context, '/viewReqList');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      // appBar: AppBar(title: Text('New Request')),
      appBar: AppBar(
        title: const Text(
          'Your Request Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
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
                              'Request ID: ${selectedRequest?['id']}',
                              style: const TextStyle(
                                color: Color(0xFF5E5E5E),
                                fontSize: 20,
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w700,
                              ),
                            )),

                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Status: ${selectedRequest?['status'] != null ? selectedRequest!['status'] : 'Pending'} ',
                              style: const TextStyle(
                                color: Color(0xFF5E5E5E),
                                fontSize: 15,
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w700,
                              ),
                            )),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Request Details',
                            style: TextStyle(
                              color: Color(0xFF2E2E2E),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            copiesText,
                            style: const TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(
                            height:
                                5), // Adds space between the text and the container

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            reasonText,
                            style: const TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 55),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Submitted Requirements',
                    style: TextStyle(
                      color: Color(0xFF2E2E2E),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Flexible(
                    child: buildListView(requirements, focusPhoto
                        // _openCamera,
                        )),
                const SizedBox(height: 40),
                Column(
                  children: [
                    SizedBox(
                      width:
                          double.infinity, // Makes the button take full width
                      child: selectedRequest?['status'] == null || selectedRequest?['status'] == 'pending' ? 
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18), // Custom padding
                        ),
                        onPressed: () async {
                          await cancelRequest(context);
                        },
                        child: const Text('Cancel',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ) :

                      Text('This request has been ${selectedRequest?['status']} $timeText $remarkText ') 
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: const Text(
                        'Previous',
                        style: TextStyle(
                            color: Color(0xFF006644),
                            fontSize: 16), // Makes text invisible
                      ),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF006644), // Makes icon invisible
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
