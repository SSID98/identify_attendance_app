import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});
}
