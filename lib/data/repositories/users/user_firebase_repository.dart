import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/data/models/user_model.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_repository.dart';

class UserFirebaseRepository implements UserRepository {
  final FirebaseAuth _auth;
  final FirebaseDatabase _database;

  UserFirebaseRepository({
    FirebaseAuth? auth,
    FirebaseDatabase? database,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _database = database ?? FirebaseDatabase.instance;

  DatabaseReference _userRef(String uid) =>
      _database.ref('users/$uid');

  @override
  Future<String> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!.uid;
  }

  @override
  Future<String> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!.uid;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> createUserProfile(UserModel user) async {
    await _userRef(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await _userRef(user.id).update(user.toMap());
  }

  @override
  Future<UserModel?> getUserProfile(String id) async {
    final snapshot = await _userRef(id).get();
    if (!snapshot.exists || snapshot.value == null) return null;
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return UserModel.fromMap(id, data);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserFirebaseRepository();
});
