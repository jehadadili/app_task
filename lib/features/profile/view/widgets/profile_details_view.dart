import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_task_app/features/profile/cubit/profile_state.dart';
import 'profile_loaded_content.dart';
import 'profile_state_handler.dart';

class ProfileDetailsView extends StatefulWidget {
  const ProfileDetailsView({super.key});

  @override
  State<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          ProfileStateHandler.handleStateChanges(context, state);
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            return ProfileLoadedContent(userProfile: state.userProfile);
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileCubit>().fetchUserProfile();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
