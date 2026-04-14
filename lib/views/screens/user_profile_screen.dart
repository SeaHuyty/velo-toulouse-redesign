import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/view_model/user_viewmodel.dart';
import 'package:velo_toulouse_redesign/views/screens/auth/login_screen.dart';
import 'package:velo_toulouse_redesign/views/screens/edit_profile_screen.dart';
import 'package:velo_toulouse_redesign/views/screens/ride_history_screen.dart';
import 'package:velo_toulouse_redesign/views/widgets/user_menu.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Failed to load profile')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No profile found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.imageUrl.isNotEmpty
                            ? NetworkImage(user.imageUrl)
                            : null,
                        child: user.imageUrl.isEmpty
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(user: user),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    user.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 24),
                UserMenu(
                  onHistory: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RideHistoryScreen(),
                      ),
                    );
                  },
                  onLogout: () async {
                    await ref.read(userViewModelProvider.notifier).signOut();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
