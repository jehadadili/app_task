import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/posts/cubit/posts_state.dart';
import 'package:flutter_task_app/features/posts/repository/posts_repository.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostsRepository _repository;

  PostsCubit(this._repository) : super(PostsInitial()) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    emit(PostsLoading());
    try {
      final posts = await _repository.fetchPosts();
      emit(PostsLoaded(posts, posts));
    } catch (e) {
      log('Error: $e');
      final mockPosts = _repository.getMockPosts();
      emit(PostsLoaded(mockPosts, mockPosts));
    }
  }

  Future<void> retryFetch() async {
    await Future.delayed(Duration(seconds: 2));
    fetchPosts();
  }

  void filterPosts(String query) {
    if (state is PostsLoaded) {
      final current = state as PostsLoaded;
      final allPosts = current.allPosts;
      final filtered = query.isEmpty
          ? allPosts
          : allPosts.where((post) {
              final q = query.toLowerCase();
              return post.title.toLowerCase().contains(q) ||
                  post.body.toLowerCase().contains(q);
            }).toList();
      emit(PostsLoaded(allPosts, filtered));
    }
  }
}
