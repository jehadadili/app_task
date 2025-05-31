import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/posts/cubit/posts_cubit.dart';
import 'package:flutter_task_app/features/posts/view/widgets/posts_list_view.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => PostsCubit(),
      child: const PostsListView(),
    );
  }
}
