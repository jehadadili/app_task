import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  List<dynamic> _allPosts = []; 

  PostsCubit() : super(PostsInitial());


  Future<void> fetchPosts() async {
    emit(PostsLoading());
    try {
      final String apiUrl = 'https://jsonplaceholder.typicode.com/posts'; 
      log("--- Placeholder: Fetching posts from API --- ");
      log("API URL: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        _allPosts = json.decode(response.body);
        log("Posts fetched successfully: ${_allPosts.length} posts");
        emit(PostsLoaded(posts: _allPosts, filteredPosts: _allPosts)); 
      } else {
        log("API Error: Status Code ${response.statusCode}");
        emit(PostsError('Failed to load posts. Status code: ${response.statusCode}'));
      }


    } catch (e) {
      log("Error fetching posts: ${e.toString()}");
      emit(PostsError('Failed to fetch posts: ${e.toString()}'));
    }
  }

  void searchPosts(String query) {
    if (state is PostsLoaded) {
      if (query.isEmpty) {
        emit(PostsLoaded(posts: _allPosts, filteredPosts: _allPosts));
      } else {
        final filtered = _allPosts.where((post) {
          final title = post['title']?.toLowerCase() ?? '';
          final body = post['body']?.toLowerCase() ?? '';
          final lowerQuery = query.toLowerCase();
          return title.contains(lowerQuery) || body.contains(lowerQuery);
        }).toList();
        log("Filtered posts: ${filtered.length} for query '$query'");
        emit(PostsLoaded(posts: _allPosts, filteredPosts: filtered));
      }
    }
  }
}

