import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/posts/cubit/posts_cubit.dart';
import 'package:flutter_task_app/features/posts/cubit/posts_state.dart';
import 'package:flutter_task_app/features/posts/view/widgets/empty_state.dart';
import 'package:flutter_task_app/features/posts/view/widgets/posts_list.dart';
import 'package:flutter_task_app/features/posts/view/widgets/search_field.dart';

class PostsListView extends StatefulWidget {
  const PostsListView({super.key});

  @override
  State<PostsListView> createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<PostsCubit>().filterPosts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          SearchField(controller: _searchController),
          Expanded(
            child: BlocBuilder<PostsCubit, PostsState>(
              builder: (context, state) {
                if (state is PostsLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading posts...'),
                      ],
                    ),
                  );
                }

                if (state is PostsLoaded) {
                  if (state.filteredPosts.isEmpty) {
                    return EmptyState(searchText: _searchController.text, onClear: () {
                      _searchController.clear();
                    });
                  }

                  return PostsList(posts: state.filteredPosts);
                }

                return const Center(child: Text('Loading posts...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
