import 'package:flutter/material.dart';

import '../Attempt.dart';
import '../QuestionType.dart';
import '../Quiz.dart';
import 'ResultScreen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Attempt _attempt;
  int _currentIndex = 0;
  final TextEditingController _fillInBlankController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _attempt = Attempt(quiz: widget.quiz);
    _loadCurrentAnswer();
  }

  @override
  void dispose() {
    _fillInBlankController.dispose();
    super.dispose();
  }

  void _loadCurrentAnswer() {
    final savedAnswer = _attempt.responses[_currentIndex].answerText;
    _fillInBlankController.text = savedAnswer;
  }

  void _saveAnswer(String answer) {
    setState(() {
      _attempt.responses[_currentIndex].answerText = answer;
    });
  }

  void _goToNext() {
    if (_currentIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _loadCurrentAnswer();
      });
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _loadCurrentAnswer();
      });
    }
  }

  void _submitQuiz() {
    final result = _attempt.submit();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          attempt: _attempt,
          result: result,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.quiz.questions;
    final currentQ = questions[_currentIndex];
    final currentResp = _attempt.responses[_currentIndex];
    final isLastQuestion = _currentIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / questions.length,
            ),
            const SizedBox(height: 16),
            Text(
              'Question ${_currentIndex + 1} of ${questions.length}  (${currentQ.points} pt${currentQ.points > 1 ? 's' : ''})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentQ.prompt,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Multiple choice options
            if (currentQ.type == QuestionType.MULTIPLE_CHOICE) ...[
              for (int i = 0; i < currentQ.options.length; i++) ...[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: currentResp.answerText == '${i + 1}'
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                  ),
                  onPressed: () {
                    // Question.validateAnswer expects "1", "2", etc., for multiple choice
                    _saveAnswer('${i + 1}');
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        '${i + 1}. ${currentQ.options[i].text}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],

            // Fill in the blank input field
            if (currentQ.type == QuestionType.FILL_IN_BLANK) ...[
              TextField(
                controller: _fillInBlankController,
                decoration: const InputDecoration(
                  labelText: 'Type your answer here',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) => _saveAnswer(text),
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 20),

            // Navigation controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentIndex > 0 ? _goToPrevious : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
                if (!isLastQuestion)
                  ElevatedButton.icon(
                    onPressed: _goToNext,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  )
                else
                  FilledButton.icon(
                    onPressed: _submitQuiz,
                    icon: const Icon(Icons.check),
                    label: const Text('Submit'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}