import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class Firebaseuserservice {
  static String? barangay;
  static Map<String, dynamic>? userData;

  static String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert to DateTime
    return DateFormat.yMMMMd().add_jm().format(dateTime); // Format to string
  }

  static Future<Map<String, dynamic>?> getUserDeets(String UUID) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance
            .collection('barangayNexus/users/loginCredentials')
            .doc(UUID) // Access by document ID instead of querying
            .get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }

  static Future<String?> addRequest(Map<String, dynamic> request) async {
    await FirebaseFirestore.instance
        .collection('/barangayNexus/documents/requests')
        .add(request)
        .then((docRef) {
      print("Document added with ID: ${docRef.id}");

      Firebaseuserservice.addHistory({
        'type': 'dr',
        'uuid': "barangayNexus/documents/requests/${docRef.id}",
        'action': 'Document Requested: ${requestedDoc?['name']}',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    }).catchError((error) {
      print("Error adding document: $error");
    });
    return null;
  }

  static Future<String?> addApplication(Map<String, dynamic> request) async {
    await FirebaseFirestore.instance
        .collection('/barangayNexus/documents/applications')
        .add(request)
        .then((docRef) {
      print("Document added with ID: ${docRef.id}");

      Firebaseuserservice.addHistory({
        'action': 'Applied to Program: ${appliedProgram?['name']}',
        'type': 'pa',
        'uuid': "barangayNexus/documents/applications/${docRef.id}",
        'createdAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    }).catchError((error) {
      print("Error adding document: $error");
    });
    return null;
  }

  static Future<Map<String, dynamic>?> getRequestDeets(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore
        .instance
        .doc(
            'barangayNexus/documents/requests/$uid') // Use .doc() for a single document
        .get();

    if (docSnapshot.exists) {
      return {
        'id': docSnapshot.id,
        ...docSnapshot.data() as Map<String, dynamic> // Merge document data
      };
    }
    return null;
  }

  static Future<String?> addHistory(Map<String, dynamic> historyItem) async {
    await FirebaseFirestore.instance
        .collection('/barangayNexus/users/loginCredentials/$uid/history')
        .add(historyItem)
        .then((docRef) {
      print("Document added with ID: ${docRef.id}");
      return docRef.id;
    }).catchError((error) {
      print("Error adding document: $error");
    });
    return null;
  }

  static Future<String?> addNotif(Map<String, dynamic> notifItem) async {
    await FirebaseFirestore.instance
        .collection('/barangayNexus/users/loginCredentials/$uid/notifications')
        .add(notifItem)
        .then((docRef) {
      print("Document added with ID: ${docRef.id}");
      return docRef.id;
    }).catchError((error) {
      print("Error adding document: $error");
    });
    return null;
  }

  static Future<List<Map<String, dynamic>>?> getAvailableItems(
      String category) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('barangayNexus/documents/$category')
            // .where('requester', isEqualTo: uid)

            .get(); // Remove the limit if you want all results

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include the document ID
          ...doc.data() // Merge document data
        };
      }).toList();
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> getMasterList(
      String uid, String list, String type) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('barangayNexus/documents/$list')
            .where(type, isEqualTo: uid)
            .get(); // Remove the limit if you want all results

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include the document ID
          ...doc.data() // Merge document data
        };
      }).toList();
    }
    return null;
  }

  static Stream<List<Map<String, dynamic>>> getAnnouncements(String barangay) {
    print("Firebaseuserservice.userData?['barangay']");
    // print(Firebaseuserservice.userData?['barangay']);
    return FirebaseFirestore.instance
        .collection('barangayNexus/documents/announcements')
        .where('barangay', isEqualTo: barangay)
        .snapshots() // Real-time updates
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    });
  }

  static Future<void> cancelRequest() async {
    try {
      await FirebaseFirestore.instance
          .collection(
              'barangayNexus/documents/requests') // Replace with your collection name
          .doc(selectedRequest?['id']) // Reference the specific document by ID
          .update({
        'status': 'canceled',
        'updateTime': FieldValue.serverTimestamp()
      }); // Pass the updated fields

      Firebaseuserservice.addHistory({
        'type': 'dr',
        'action': 'Document Request canceled',
        'uuid': "barangayNexus/documents/requests/${selectedRequest?['id']}",
        'createdAt': FieldValue.serverTimestamp(),
      });

      Firebaseuserservice.addNotif({
        'type': 'dr',
        'action': 'You canceled your document request',
        'uuid': "barangayNexus/documents/requests/${selectedRequest?['id']}",
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("Document updated successfully!");
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  static Future<List<Map<String, dynamic>>?> getList(
      String uid, String list) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('/barangayNexus/users/loginCredentials/$uid/$list')
            .orderBy('createdAt', descending: true)
            .get(); // Remove the limit if you want all results

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include the document ID
          ...doc.data() // Merge document data
        };
      }).toList();
    }
    return null;
  }

  static Future<String?> uploadFile(File file) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();

      // Define a unique file path (e.g., "uploads/filename.jpg")
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final fileRef = storageRef.child("uploads/$fileName.jpg");

      // Upload the file
      UploadTask uploadTask = fileRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl; // Return the URL
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }
}
