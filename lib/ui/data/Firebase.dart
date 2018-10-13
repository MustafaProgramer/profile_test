import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig1 {
  static Future<Firestore> initFire(Firestore firestore) async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'test',
      options: const FirebaseOptions(
        googleAppID: '1:282652140711:android:dbac553d9ed9b18c',
        apiKey: 'AIzaSyCgJPiep1ADLqvJXbfwDz_hj_Vh_Q_2vuE',
        projectID: 'senior-project-a1ec6',
      ),
    );
    firestore = Firestore(app: app);
    return firestore;
  }
}

class UserDetails {
  static FirebaseUser user;
  static Map details;

  static void setUser(FirebaseUser u) {
    user = u;
  }

  static getUser() {
    return user;
  }

  static void setDetails(Map d) {
    details = d;
  }

  static getDetails() {
    return details;
  }
}
