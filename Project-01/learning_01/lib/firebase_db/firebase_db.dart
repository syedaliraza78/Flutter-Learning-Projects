import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a session code
  static Future<void> addSessionCode(String sessionCode, String key) async {
    await _db.collection('sessions').doc(key).set({'sessionCode': sessionCode});
  }

  // Search for a session code
 static Future<String?> searchSessionCode(String key) async {
  try {
    var doc = await _db.collection('sessions').doc(key).get();  // Fetch the document by the key
    if (doc.exists) {  // Check if the document exists
      return doc['sessionCode'];  // Return the session code
    } else {
      return null;  // If document doesn't exist, return null
    }
  } catch (e) {
    print("Error searching for session code: $e");
    return null;  // If there’s an error, return null
  }
}


  static Future<void> deleteSessionCode(String key) async {
    try {
      await _db.collection('sessions').doc(key).delete(); // Delete the document with the specified key
      print('Session with key $key deleted successfully.');
    } catch (e) {
      print("Error deleting session code: $e");
    }
  }
}
