import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/presentation/cubit/auth_cubit.dart'; // Needed for logout
import 'package:flutter_task_app/features/auth/presentation/view/login_screen.dart'; // Needed for logout navigation
import 'package:flutter_task_app/features/home/posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_task_app/features/home/posts/presentation/view/post_screen.dart';
import 'package:flutter_task_app/features/home/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_task_app/features/home/profile/presentation/view/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define the screens for the tabs
  static final List<Widget> _widgetOptions = <Widget>[
    BlocProvider(
      create: (context) => PostsCubit()..fetchPosts(), // Create and fetch posts
      child: const PostsScreen(),
    ),
    BlocProvider(
      create: (context) => ProfileCubit(), // Create and fetch profile
      child: const ProfileScreen(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to AuthState changes for handling logout redirection
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          // Navigate to login screen when logged out
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false, // Remove all previous routes
          );
        }
      },
      child: Scaffold(
        // AppBar might be dynamic based on the selected tab
        appBar: AppBar(
          title: Text(_selectedIndex == 0 ? 'Posts' : 'Profile'),
          // Optionally add actions like refresh or settings
        ),
        body: IndexedStack( // Use IndexedStack to keep state of tabs
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article),
              label: 'Posts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          // Use theme colors or customize as needed
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

