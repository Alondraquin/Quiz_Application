class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: QuizScreen(quiz: _getSampleQuiz()),
    );
  }

  static Quiz _getSampleQuiz() {
    return Quiz(
      title: 'Flutter & Dart Basics',
      description: 'A quick diagnostic practice test.',
      questions: [
        Question(
          prompt:
              'Consider:\nvoid main() {\n  runApp(\n    Center(\n      child: Text("Hello")\n    )\n  );\n}\nWhich widget is the root of the widget tree?',
          type: QuestionType.MULTIPLE_CHOICE,
          points: 2,
          options: [
            AnswerOption(text: 'main', isCorrect: false),
            AnswerOption(text: 'runApp', isCorrect: false),
            AnswerOption(text: 'Center', isCorrect: true),
            AnswerOption(text: 'Text', isCorrect: false),
          ],
        ),
        Question(
          prompt:
              '_______ lets you inject updated source code into a running Dart VM.',
          type: QuestionType.FILL_IN_BLANK,
          points: 1,
          options: [
            AnswerOption(text: 'Hot reload', isCorrect: true),
            AnswerOption(text: 'hot reloading', isCorrect: true),
          ],
        ),
        Question(
          prompt: 'Is Dart an object-oriented language?',
          type: QuestionType.MULTIPLE_CHOICE,
          points: 1,
          options: [
            AnswerOption(text: 'true', isCorrect: true),
            AnswerOption(text: 'false', isCorrect: false),
          ],
        ),
      ],
    );
  }
}