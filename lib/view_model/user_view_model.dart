import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/data/models/user_model.dart';
import 'package:velo_toulouse_redesign/data/repositories/users/user_firebase_repository.dart';

class UserViewModel extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    return null;
  }

  Future<String?> signUp(String email, String password) async {
    state = const AsyncLoading();
    String? uid;
    state = await AsyncValue.guard(() async {
      uid = await ref.read(userRepositoryProvider).signUp(email, password);
      return null;
    });
    return uid;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).login(email, password);
      return null;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).signOut();
      return null;
    });
  }

  Future<void> createUserProfile(UserModel user) async {
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).createUserProfile(user);
      return user;
    });
  }

  Future<void> resetPassword(String email) async {
    await ref.read(userRepositoryProvider).resetPassword(email);
  }
}

final userViewModelProvider =
    AsyncNotifierProvider<UserViewModel, UserModel?>(() {
  return UserViewModel();
});
