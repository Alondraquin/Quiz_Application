import 'package:flutter/material.dart';

import '../Attempt.dart';
import '../Result.dart';
import 'QuizScreen.dart';

class ResultScreen extends StatelessWidget {
  final Attempt attempt;
  final Result result;

  const ResultScreen({
    super.key,
    required this.attempt,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final incorrect = attempt.responses.where((r) => !r.isCorrect).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Score',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Review',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (incorrect.isEmpty)
              const Text('Outstanding! You got every question correct!')
            else ...[
              for (final resp in incorrect) ...[
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resp.question.prompt,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your answer: ${resp.answerText.isEmpty ? "(Unanswered)" : resp.answerText}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        Text(
                          'Correct answer: ${resp.question.getExpectedAnswerText()}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(quiz: attempt.quiz),
                  ),
                );
              },
              child: const Text('Retake Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}