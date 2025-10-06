import 'package:firebase_nexus/appColors.dart';
import 'package:firebase_nexus/helpers/userPageSupabaseHelper.dart';
import 'package:firebase_nexus/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({super.key});

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _logout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Clear user in provider + shared preferences
    await userProvider.clearUser();

    // Navigate to login (replace with your actual login route)
    if (mounted) {
      Navigator.pushNamed(context, '/tioLogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isLoaded) {
      userProvider.loadUser();
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: user != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: AppColors.primaryVariant,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    width: double.infinity,
                    height: 210,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Registered Expresser!",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          user['username'],
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(user['email'],
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(user['address'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(user['phone_number'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🔹 Logout Button
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            )
          : const Center(child: Text("User not found")),
    );
  }
}
