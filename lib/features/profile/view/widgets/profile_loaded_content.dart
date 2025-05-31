import 'package:flutter/material.dart';
import 'profile_avatar.dart';
import 'profile_info_list.dart';
import 'logout_button.dart';

class ProfileLoadedContent extends StatelessWidget {
  final dynamic userProfile;
  final EdgeInsetsGeometry padding;

  const ProfileLoadedContent({
    super.key,
    required this.userProfile,
    this.padding = const EdgeInsets.all(24.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ProfileAvatar(),
          const SizedBox(height: 24.0),
          ProfileInfoList(userProfile: userProfile),
          const Spacer(),
          const LogoutButton(),
        ],
      ),
    );
  }
}