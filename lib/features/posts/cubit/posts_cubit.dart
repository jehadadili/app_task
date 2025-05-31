import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_task_app/data/models/post_model.dart';
import 'package:flutter_task_app/features/posts/cubit/posts_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial()) {
    fetchPosts(); 
  }

  List<PostModel> _allPosts = []; 

  Future<void> fetchPosts() async {
    emit(PostsLoading());
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _allPosts = data.map((json) => PostModel.fromJson(json)).toList();
        emit(PostsLoaded(_allPosts, _allPosts));
      } else {
        emit(PostsError('Failed to load posts. Status code: ${response.statusCode}')); 
      }
    } catch (e) {
      emit(PostsError('Failed to load posts: ${e.toString()}')); 
    }
  }

  void filterPosts(String query) {
    if (state is PostsLoaded) {
      final currentState = state as PostsLoaded;
      if (query.isEmpty) {
        emit(PostsLoaded(currentState.allPosts, currentState.allPosts));
      } else {
        final filtered = currentState.allPosts.where((post) {
          final titleLower = post.title.toLowerCase();
          final bodyLower = post.body.toLowerCase();
          final queryLower = query.toLowerCase();
          return titleLower.contains(queryLower) || bodyLower.contains(queryLower);
        }).toList();
        emit(PostsLoaded(currentState.allPosts, filtered));
      }
    } else {
      log("Cannot filter posts: Posts not loaded yet.");
    }
  }
}
