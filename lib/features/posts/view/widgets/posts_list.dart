import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/posts/model/post_model.dart';
import 'package:flutter_task_app/features/posts/view/widgets/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/posts/cubit/posts_cubit.dart';

class PostsList extends StatelessWidget {
  final List<PostModel> posts;

  const PostsList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<PostsCubit>().fetchPosts(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }
}
