import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp(quiz: _buildSampleQuiz()));
}

QuizPreview _buildSampleQuiz() {
  return QuizPreview(
    title: 'Flutter & Dart Basics',
    description: 'A quick diagnostic practice test.',
    questions: [
      QuestionPreview(
        prompt:
            'Consider:\nvoid main() {\n  runApp(\n    Center(\n      child: Text("Hello")\n    )\n  );\n}\nWhich widget is the root of the widget tree?',
        points: 2,
        options: ['main', 'runApp', 'Center', 'Text'],
        correctOption: 2,
      ),
      QuestionPreview(
        prompt:
            '_______ lets you inject updated source code into a running Dart VM.',
        points: 1,
        options: const [],
        acceptedAnswers: ['Hot reload', 'hot reloading'],
      ),
      QuestionPreview(
        prompt: 'Is Dart an object-oriented language?',
        points: 1,
        options: ['true', 'false'],
        correctOption: 0,
      ),
    ],
  );
}

class QuizPreview {
  const QuizPreview({
    required this.title,
    required this.description,
    required this.questions,
  });

  final String title;
  final String description;
  final List<QuestionPreview> questions;
}

class QuestionPreview {
  const QuestionPreview({
    required this.prompt,
    required this.points,
    required this.options,
    this.correctOption,
    this.acceptedAnswers = const [],
  });

  final String prompt;
  final int points;
  final List<String> options;
  final int? correctOption;
  final List<String> acceptedAnswers;

  bool get isMultipleChoice => options.isNotEmpty;

  bool validateAnswer(String answer) {
    if (isMultipleChoice) {
      return int.tryParse(answer) == correctOption! + 1;
    }
    return acceptedAnswers.any(
      (acceptedAnswer) =>
          acceptedAnswer.toLowerCase() == answer.trim().toLowerCase(),
    );
  }
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key, required this.quiz});

  final QuizPreview quiz;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: quiz.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B5BD6),
          surface: const Color(0xFFF7F7FC),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FC),
      ),
      home: QuizWelcomeScreen(quiz: quiz),
    );
  }
}

class QuizWelcomeScreen extends StatelessWidget {
  const QuizWelcomeScreen({super.key, required this.quiz});

  final QuizPreview quiz;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        Icons.quiz_outlined,
                        color: colorScheme.primary,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Ready to test\nyour knowledge?',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.12,
                          letterSpacing: -0.6,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    quiz.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Icon(
                                Icons.help_outline,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${quiz.questions.length} questions',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.stars_outlined,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${quiz.questions.fold<int>(0, (sum, question) => sum + question.points)} points available',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => FirstQuestionScreen(
                            question: quiz.questions.first,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Start quiz'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FirstQuestionScreen extends StatefulWidget {
  const FirstQuestionScreen({super.key, required this.question});

  final QuestionPreview question;

  @override
  State<FirstQuestionScreen> createState() => _FirstQuestionScreenState();
}

class _FirstQuestionScreenState extends State<FirstQuestionScreen> {
  final TextEditingController _answerController = TextEditingController();
  int? _selectedOption;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Question 1')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: 1 / 3,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'QUESTION 1',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.prompt,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${question.points} points',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  if (question.isMultipleChoice)
                    ...List.generate(question.options.length, (index) {
                      final option = question.options[index];
                      final isSelected = _selectedOption == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: isSelected
                              ? colorScheme.primaryContainer
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () =>
                                setState(() => _selectedOption = index),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.outlineVariant,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                  else
                    TextField(
                      controller: _answerController,
                      decoration: const InputDecoration(
                        labelText: 'Your answer',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _selectedOption == null &&
                            question.isMultipleChoice
                        ? null
                        : () {
                            final answer = question.isMultipleChoice
                                ? '${_selectedOption! + 1}'
                                : _answerController.text;
                            final isCorrect = question.validateAnswer(answer);

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isCorrect
                                        ? 'Correct answer!'
                                        : 'Not quite. Try again!',
                                  ),
                                ),
                              );
                          },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: const Text('Check answer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
