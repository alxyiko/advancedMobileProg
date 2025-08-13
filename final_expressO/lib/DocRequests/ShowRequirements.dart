import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:firebase_nexus/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_nexus/FirebaseOperations/FirebaseuserService.dart';
import 'package:image_picker/image_picker.dart';

Widget buildListView(
    List<Map<String, dynamic>> items, Function(int) onItemTap) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // Number of columns
      crossAxisSpacing: 10, // Space between columns
      mainAxisSpacing: 10, // Space between rows
      mainAxisExtent: 220, // Fixed height for each item
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        // onTap: () => onItemTap(items[index]), // Trigger action on tap
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
                                child: Image.file(
                                  File(items[index]['file']),
                                  fit: BoxFit.cover,
                                ),
                              ),
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

                  // This button will be stacked on top of the image/container
                  Positioned(
                      bottom: 40, // Adjust position if needed
                      top: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          onItemTap(index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: items[index]['file'] != null
                              ? Colors.black.withOpacity(
                                  0.5) // Slightly black with low opacity
                              : Colors.grey
                                  .withOpacity(0), // Light gray for no picture
                          shadowColor: Colors.transparent, // Removes shadow
                          elevation: 0, // No elevation for a flat look
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5), // Adjust border radius
                          ),
                        ),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // Keeps button height minimal
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: items[index]['file'] != null
                                  ? Colors.white
                                  : Colors
                                      .grey, // White when there's a picture, gray when none
                              size: 40,
                            ),
                            const SizedBox(
                                height: 4), // Space between icon and text
                            Text(
                              items[index]['file'] != null
                                  ? 'Retake Photo'
                                  : 'Take Photo',
                              style: TextStyle(
                                color: items[index]['file'] != null
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
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

class ShowRequirementsList extends StatefulWidget {
  const ShowRequirementsList({super.key});

  @override
  State<ShowRequirementsList> createState() => _ShoRrequirementsStateList();
}

class _ShoRrequirementsStateList extends State<ShowRequirementsList> {
  final GlobalKey<FormState> _requestForm = GlobalKey<FormState>();
  bool success = true;
  bool loading = false;
  int _copies = 1;
  // int? _copies = 1;
  String? _reason;
  List<String> reasons = [
    'Financial',
    'Legal',
    'Medical',
    'Scholarship',
    'Employment',
    'Business',
    'Marriage',
    'Government Benefits',
    'Travel and Immigration',
    'Housing and Residency',
    'Other',
  ];

  String docname = requestedDoc?['name'] as String;
  XFile? file;
  List<Map<String, dynamic>> requirements = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    requirements = (requestedDoc?['requirements'] as List<dynamic>?)
            ?.map((req) =>
                {'reqName': req.toString(), 'file': file}) // Use null initially
            .toList() ??
        [];

    if (requestedDoc == null) {
      backToDocList();

      return;
    }
  }

  bool withNulls() {
    return requirements.any((map) => map.containsValue(null));
  }

  Future<void> _openCamera(index) async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        requirements[index]['file'] = image.path;
      });
    }
  }

  Future<void> _uploadImage(String ImagePath, index) async {
    File file = File(ImagePath);
    String? url = await Firebaseuserservice.uploadFile(file);
    requirements[index]['file'] = url;
    print('file successfully uploaded:');
    print(requirements[index]['name']);
    print(url);
    }

  Future<void> submitRequirementPhotos() async {
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something wrong happened on our end...'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('/barangayNexus/documents/documents')
        .doc(requestedDoc?['id']);

    await Firebaseuserservice.addRequest({
      'title':
          "$_copies ${_copies > 1 ? 'copies' : 'copy'} of ${requestedDoc?['name']}",
      'documentRequested': docRef,
      'entityID': requestedDoc?['id'],
      'requester': uid,
      'barangay': Firebaseuserservice.userData?['barangay'],
      'status': 'pending',
      'requirmentFiles': jsonEncode(requirements),
      'reason': _reason,
      'copies': _copies,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // // String? id = await requestID;
    // print("SIGE");
    // print(Firebaseuserservice.addRequest({
    //   'title':
    //       "$_copies ${_copies! > 1 ? 'copies' : 'copy'} of ${requestedDoc?['name']}",
    //   'documentRequested': docRef,
    //   'requester': uid,
    //   'requirmentFiles': jsonEncode(requirements),
    //   'reason': _reason,
    //   'copies': _copies,
    //   'createdAt': FieldValue.serverTimestamp(),
    // }));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request Successfully submitted!'),
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.popUntil(context, ModalRoute.withName('/home'));
  }

  Future<void> _submitForm() async {
    if (_requestForm.currentState!.validate()) {
      if (_reason == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please pick a reason first.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      } else if (withNulls()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submit photos of all requirements first!'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent closing while loading
        builder: (context) {
          return const AlertDialog(
            contentPadding: EdgeInsets.all(40),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50, // Adjust width
                  height: 50, // Adjust height
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 20),

                Text(
                  'Please wait',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                      "This will only take a moment while\nwe process your request"),
                ), // Loading message
              ],
            ),
          );
        },
      );

      for (int index = 0; index < requirements.length; index++) {
        await _uploadImage(requirements[index]['file'], index);
      }

      submitRequirementPhotos();

      // Close loading dialog
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Properly fill all fields!'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Future<void> _submitForm() async {
  //   if (_requestForm.currentState!.validate()) {
  //     if (_reason == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Please pick a reason first.'),
  //           backgroundColor: Colors.red, // Optional: Custom color
  //           duration: Duration(seconds: 3),
  //         ),
  //       );

  //       return;
  //     } else if (withNulls()) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Submit photos of all requirements first!'),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );

  //       return;
  //     }

  //     for (int index = 0; index < requirements.length; index++) {
  //       await _uploadImage(requirements[index]['file'], index);
  //     }

  //     submitRequirementPhotos();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Properly fill all fields!'),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   }
  //   return;
  // }

  void backToDocList() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You need to select a document first!')),
    );
    Timer(const Duration(seconds: 2), () {
      Navigator.pushNamed(context, '/viewDocList');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Finalize Request',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: !requestedDoc!.containsKey('requirements')
            ? const Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : Padding(
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
                              //   Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: Text(
                              //     'Request for $docname',
                              //     style: const TextStyle(
                              //         color: Color(0xFF5E5E5E),
                              //         fontSize: 16,
                              //         fontFamily: 'Rubik',
                              //         fontWeight: FontWeight.w700,
                              //     ),
                              //   )
                              // ),

                              const SizedBox(height: 12),
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Step 02',
                                    style: TextStyle(
                                      color: Color(0xFF5E5E5E),
                                      fontSize: 14,
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
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

                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Kindly fill in the remaining details',
                                    style: TextStyle(
                                      color: Color(0xFF5E5E5E),
                                      fontSize: 16,
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),

                              const SizedBox(height: 30),

                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Number of Copies',
                                  style: TextStyle(
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: _copies > 1
                                            ? () => setState(() {
                                                  _copies--;
                                                })
                                            : null,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: BoxDecoration(
                                          border: Border.symmetric(
                                            vertical: BorderSide(
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                        child: Text(
                                          '$_copies',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: _copies < 5
                                            ? () => setState(() {
                                                  _copies++;
                                                })
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // DropdownButtonFormField<int>(
                              //   value: _copies,
                              //   hint:
                              //       const Text('How many copies do you need?'),
                              //   isExpanded: true,
                              //   decoration: InputDecoration(),
                              //   onChanged: (int? newValue) =>
                              //       setState(() => _copies = newValue),
                              //   items: List.generate(5, (index) => index + 1)
                              //       .map((number) => DropdownMenuItem(
                              //           value: number,
                              //           child: Text(number.toString())))
                              //       .toList(),
                              // ),

                              const SizedBox(height: 25),

                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Reason for Request',
                                  style: TextStyle(
                                    color: Color(0xFF5E5E5E),
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),

                              DropdownButtonFormField<String>(
                                value: _reason,
                                hint: const Text(
                                    'Why do you need this document?'),
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                onChanged: (String? newValue) =>
                                    setState(() => _reason = newValue),
                                items: reasons.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ],
                          )),
                      const SizedBox(height: 55),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Step 03',
                            style: TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontSize: 14,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      const SizedBox(height: 5),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Requirements',
                          style: TextStyle(
                            color: Color(0xFF2E2E2E),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kindly take a photo of the requirement(s)',
                            style: TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      const SizedBox(height: 15),
                      Flexible(
                          child: buildListView(
                        requirements.map((req) => req).toList(),
                        _openCamera,
                      )),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          SizedBox(
                            width: double
                                .infinity, // Makes the button take full width
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18), // Custom padding
                              ),
                              onPressed: () async {
                                await _submitForm();
                              },
                              child: const Text('Finalize',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
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
