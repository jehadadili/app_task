
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/posts/cubit/posts_cubit.dart';
import 'package:flutter_task_app/features/posts/cubit/posts_state.dart';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Posts...', 
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<PostsCubit, PostsState>(
              builder: (context, state) {
                if (state is PostsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PostsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error loading posts: ${state.message}', 
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                if (state is PostsLoaded) {
                  if (state.filteredPosts.isEmpty) {
                    return Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'No posts available.' 
                            : 'No posts found matching "${_searchController.text}".', 
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = state.filteredPosts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ListTile(
                          title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                          onTap: () {
                            log("Tapped on post ID: ${post.id}");
                          },
                        ),
                      );
                    },
                  );
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
