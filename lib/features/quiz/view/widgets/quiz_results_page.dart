import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/question.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_answer.dart';

class QuizResultsPage extends StatelessWidget {
  final List<Question> questions;
  final Map<String, QuizAnswer> userAnswers; 
  final int finalScore;
  final int totalQuestions;

  const QuizResultsPage({
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.finalScore,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = totalQuestions > 0 ? (finalScore / totalQuestions) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'), 
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Quiz Complete!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Your Score:', 
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '$finalScore / $totalQuestions',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '(${percentage.toStringAsFixed(1)}%)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final answer = userAnswers[question.id];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: answer?.isCorrect ?? false ? Colors.green.shade50 : Colors.red.shade50,
                    child: ListTile(
                      leading: Icon(
                        answer?.isCorrect ?? false ? Icons.check_circle : Icons.cancel,
                        color: answer?.isCorrect ?? false ? Colors.green : Colors.red,
                      ),
                      title: Text('Question ${index + 1}: ${question.questionText}', maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('Time: ${answer?.timeTakenSeconds ?? '-'}s'), 
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
               
                log("Navigate back to Home Screen - Placeholder");
                 Navigator.of(context).pop();
              },
              child: const Text('Finish'), 
            ),
          ],
        ),
      ),
    );
  }
}
