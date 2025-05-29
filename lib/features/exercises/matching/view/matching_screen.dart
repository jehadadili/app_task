// TODO: Implement Matching Exercise Screen UI (Connect with Lines)
import 'package:flutter/material.dart';

class MatchingScreen extends StatelessWidget {
  const MatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder UI - Actual line drawing requires custom painting or a package
    return Scaffold(
      appBar: AppBar(title: const Text('Matching Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Match the pairs by drawing lines:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Left Column (Questions)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['Flutter', 'Firebase', 'Dart']
                        .map((item) => Draggable<String>(
                              data: item,
                              feedback: Material(child: Text(item, style: const TextStyle(fontSize: 16, color: Colors.blue))),
                              child: Text(item, style: const TextStyle(fontSize: 16)),
                            ))
                        .toList(),
                  ),
                  // Right Column (Answers) - Need DropTargets
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['Programming Language', 'Cloud Backend', 'UI Framework']
                        .map((item) => DragTarget<String>(
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(item, style: const TextStyle(fontSize: 16)),
                                );
                              },
                              onWillAccept: (data) => true, // Basic acceptance
                              onAccept: (data) {
                                // TODO: Handle matching logic
                                print('$data matched with $item');
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
             // TODO: Add submit button and result display
            ElevatedButton(onPressed: () {}, child: const Text('Submit')),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

