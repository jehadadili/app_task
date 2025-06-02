import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String searchText;
  final VoidCallback onClear;

  const EmptyState({
    super.key,
    required this.searchText,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isSearch = searchText.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearch ? Icons.search_off : Icons.post_add,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isSearch
                ? 'No posts found matching "$searchText".'
                : 'No posts available.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          if (isSearch) ...[
            const SizedBox(height: 16),
            TextButton(onPressed: onClear, child: const Text('Clear search')),
          ],
        ],
      ),
    );
  }
}
