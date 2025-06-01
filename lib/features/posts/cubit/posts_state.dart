

import 'package:flutter_task_app/features/posts/model/post_model.dart';

abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostModel> allPosts;
  final List<PostModel> filteredPosts;
  PostsLoaded(this.allPosts, this.filteredPosts);
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);
}
