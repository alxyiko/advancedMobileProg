import 'package:firebase_nexus/FirebaseOperations/FirebaseuserService.dart';
import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:flutter/material.dart';


Widget buildListView(List<Map<String, dynamic>> items,
    Function(Map<String, dynamic>) onItemTap) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: items.length,
    itemBuilder: (context, index) {
      bool isSelected = appliedProgram?['name'] == items[index]['name'];

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5), // Margin outside
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006644) : Colors.white, // Background color
          borderRadius: BorderRadius.circular(5), // Rounded corners
          border: Border.all(
            color: isSelected ? const Color(0xFF004D33) : const Color(0xFFC3C3C3), // Border color
            width: isSelected ? 2 : 1, // Thicker border for selected item
          ),
          boxShadow: [
            if (isSelected) // Add shadow when selected
              const BoxShadow(
                color: Color(0x19919191),
                blurRadius: 3,
                offset: Offset(0, 1),
                spreadRadius: 0,
              ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10), // Padding inside
          title: Text(
            items[index]['name'],
            style: TextStyle(
              color: isSelected ? Colors.white : const Color.fromARGB(255, 0, 0, 0), // Text color
              fontSize: 16, // Font size
              fontWeight: FontWeight.w500, // Medium weight for better visibility
            ),
          ),
          subtitle: Text('Deadline: ${Firebaseuserservice.formatTimestamp(items[index]['deadline'])}',
          style: TextStyle(
              color: isSelected ? Colors.white : const Color.fromARGB(255, 0, 0, 0), // Text color
          ),),
          onTap: () => onItemTap(items[index]), // Trigger action on tap
        ),
      );
    },
  );
}


class ShowProgList extends StatefulWidget {
  const ShowProgList({super.key});

  @override
  State<ShowProgList> createState() => _ShowProgListState();
}

class _ShowProgListState extends State<ShowProgList> {
  List<Map<String, dynamic>> myItems = []; // Non-nullable list
  bool searched = false;
  @override
  void initState() {
    super.initState();
    fetchDocList();
  }

  Future<void> fetchDocList() async {
    final data = await Firebaseuserservice.getAvailableItems('programs');
    print(data);

    print('excepmtedList');
    print(excepmtedList);
    List<Map<String, dynamic>> preItems = [];

    for (var item in data!) {
      if (!excepmtedList!.contains(item['id'])) {
        preItems.add(item);
      }
    }


    setState(() {
      searched = true;
    });

    setState(() {
      myItems = preItems;
    });
    }

  void handleNext(BuildContext context) {
  if (appliedProgram == null) {
    // Show Snackbar if no item is selected
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a program before proceeding.'),
        backgroundColor: Colors.red, // Optional: Custom color
        duration: Duration(seconds: 3),
      ),
    );
  } else {
    // Proceed to the next screen
    Navigator.pushNamed(context, '/viewProgAppli');
  }
}


  void handleItemTap(Map<String, dynamic> item) {
    setState(() {
      appliedProgram = item;
      print(appliedProgram);
    });

    // Pass data when navigating
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text("Available Documents")),
         appBar: AppBar(title: const Text(
              'Current Barangay Program:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),),
        body: SingleChildScrollView(
          child: Center(
            child: !searched
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator
                : myItems.isNotEmpty
                    ? Padding (
                        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                    
                    child: Column(

                      children: [

                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Step 01',
                            style: TextStyle(
                                color: Color(0xFF5E5E5E),
                                fontSize: 16,
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                            ),
                          )
                        ),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Choose a program',
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
                            'Which barangay program would you apply for?',
                            style: TextStyle(
                                color: Color(0xFF5E5E5E),
                                fontSize: 16,
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                            ),
                          )
                        ),

                        const SizedBox(height: 30),

                        buildListView(
                          myItems.map((doc) => doc).toList(),
                          handleItemTap,
                        ),
                        
                        const SizedBox(height: 50),

                        SizedBox(
                          width: double.infinity, // Makes the button take full width
                          child: FloatingActionButton.extended(
                            onPressed: () => {
                              handleNext(context),
                            },
                            label: const Row(
                              mainAxisSize: MainAxisSize.min, // Keeps the button size minimal
                              children: [
                                Text('Next', style: TextStyle(color: Colors.white, fontSize: 16)),
                                SizedBox(width: 8), // Adds spacing between text and icon
                                Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                              ],
                            ),
                            backgroundColor: const Color(0xFF006644), // Custom color
                             shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), // Adjust the radius here
                              ),
                          ),
                        ),

                        const SizedBox(height: 12), // Space between buttons

                        FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          label: const Text(
                            'Previous',
                            style: TextStyle(color: Color(0xFF006644), fontSize: 16), // Makes text invisible
                          ),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF006644), // Makes icon invisible
                          ),
                          backgroundColor: Colors.transparent, // Makes button invisible
                          elevation: 0, // Removes shadow
                        ),                     
                        

                        // Column(
                        //   children: [
                        //     ElevatedButton(
                        //         onPressed: () {
                        //           Navigator.pushNamed(context, '/viewReqList');
                        //         }, child: Text('Next')),
                        //     const SizedBox(height: 12),
                        //     ElevatedButton(
                        //         onPressed: () {
                        //           Navigator.pop(context);
                        //         }, child: Text('Previous')),
                        //   ],
                        // )
                      ]))
                      
                    : const Center(
                        child:
                            Text('There are no available documents right now.'),
                      ),
          ),
          
        ), 

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
