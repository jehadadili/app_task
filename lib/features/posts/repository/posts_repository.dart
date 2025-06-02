import 'dart:convert';
import 'package:flutter_task_app/features/posts/model/mock_posts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_task_app/features/posts/model/post_model.dart';

class PostsRepository {
  final _url = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<PostModel>> fetchPosts() async {
    final headers = {
      'User-Agent': 'Flutter App',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(_url), headers: headers).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts. Status: ${response.statusCode}');
    }
  }

  List<PostModel> getMockPosts() {
    return mockPosts;
  }
}
