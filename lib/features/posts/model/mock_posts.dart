import 'package:flutter_task_app/features/posts/model/post_model.dart';

final List<PostModel> mockPosts = [
  PostModel(
    id: 1,
    title: "Welcome to Flutter Task App",
    body: "This is a sample post to demonstrate the app functionality when the API is not available.",
  ),
  PostModel(
    id: 2,
    title: "How to Build Flutter Apps",
    body: "Flutter is Google's UI toolkit for building beautiful apps from a single codebase.",
  ),
  PostModel(
    id: 3,
    title: "State Management with BLoC",
    body: "BLoC is a design pattern that helps separate presentation from business logic.",
  ),
  PostModel(
    id: 4,
    title: "HTTP Requests in Flutter",
    body: "Learn how to make HTTP requests in Flutter using the http package.",
  ),
  PostModel(
    id: 5,
    title: "Error Handling Best Practices",
    body: "Proper error handling is crucial for good user experience.",
  ),
];
