import 'package:flutter/material.dart';
import 'profile_info_row.dart';

class ProfileInfoList extends StatelessWidget {
  final dynamic userProfile;

  const ProfileInfoList({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileInfoRow(
          label: 'Full Name',
          value: userProfile.fullName,
        ),
        ProfileInfoRow(
          label: 'Email',
          value: userProfile.email,
        ),
        ProfileInfoRow(
          label: 'Mobile',
          value: userProfile.mobile,
        ),
        ProfileInfoRow(
          label: 'Age',
          value: userProfile.age.toString(),
        ),
        ProfileInfoRow(
          label: 'Gender',
          value: userProfile.gender,
        ),
      ],
    );
  }
}