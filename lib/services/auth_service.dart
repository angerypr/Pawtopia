import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<UserModel?> register({
    required String nombre,
    required String email,
    required String password,
    required String telefono,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = UserModel(
      id: credential.user!.uid,
      nombre: nombre,
      email: email,
      telefono: telefono,
      createdAt: DateTime.now(),
    );
    await _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toMap());
    return user;
  }
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();
    return UserModel.fromMap(doc.data()!);
  }
  Future<void> logout() async {
    await _auth.signOut();
  }
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    final doc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }
}
