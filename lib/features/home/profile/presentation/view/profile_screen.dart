import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Full Name: [User Name]'),
            const Text('Mobile: [User Mobile]'),
            const Text('Age: [User Age]'),
            const Text('Gender: [User Gender]'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
