part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<dynamic> posts;
  final List<dynamic> filteredPosts; 

  PostsLoaded({required this.posts, required this.filteredPosts});
}

class PostsError extends PostsState {
  final String message;

  PostsError(this.message);
}

