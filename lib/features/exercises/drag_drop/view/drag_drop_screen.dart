// TODO: Implement Drag and Drop Exercise Screen UI
import 'package:flutter/material.dart';

class DragDropScreen extends StatelessWidget {
  const DragDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder UI
    return Scaffold(
      appBar: AppBar(title: const Text('Drag and Drop Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Complete the sentence:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            // TODO: Implement the sentence with a blank space (DropTarget)
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text('Flutter is a _____ framework.'),
            ),
            const SizedBox(height: 30),
            const Text('Drag the correct word:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            // TODO: Implement Draggable text blocks
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: ['React', 'mobile', 'cross-platform', 'native']
                  .map((word) => Draggable<String>(
                        data: word,
                        feedback: Material(
                          elevation: 4.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            color: Colors.blueAccent,
                            child: Text(word, style: const TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                        childWhenDragging: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          color: Colors.grey[300],
                          child: Text(word, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(word, style: const TextStyle(fontSize: 16)),
                        ),
                      ))
                  .toList(),
            ),
            const Spacer(),
            // TODO: Add validation and success message logic
            Center(child: ElevatedButton(onPressed: () {}, child: const Text('Check Answer'))),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

