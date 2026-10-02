import 'dart:io';

import 'Attempt.dart';
import 'AnswerOption.dart';
import 'Question.dart';
import 'QuestionType.dart';
import 'Quiz.dart';
import 'User.dart';

class QuizRunner {
  final User user;
  final Quiz quiz;

  QuizRunner({required this.user, required this.quiz});

  void run() {
    quiz.display();
    final attempt = user.startAttempt(quiz);

    int currentIndex = 0;
    final total = attempt.responses.length;

    // Interactive quiz navigation loop
    while (true) {
      final currentResp = attempt.responses[currentIndex];
      final currentQ = currentResp.question;

      print('----------------------------------------------------');
      print('Question ${currentIndex + 1} of $total [${currentQ.points} pt(s)]');
      print(currentQ.prompt);

      if (currentQ.type == QuestionType.MULTIPLE_CHOICE) {
        for (var i = 0; i < currentQ.options.length; i++) {
          print('  ${i + 1}. ${currentQ.options[i].text}');
        }
      }

      if (currentResp.answerText.isNotEmpty) {
        print('  Current Saved Answer: "${currentResp.answerText}"');
      }

      print('\nCommands: [n]ext | [p]revious | [s]ubmit quiz | or type your answer');
      stdout.write('Your input: ');
      final input = stdin.readLineSync()?.trim() ?? '';

      if (input.toLowerCase() == 'n') {
        if (currentIndex < total - 1) {
          currentIndex++;
        } else {
          print('You are on the last question.');
        }
      } else if (input.toLowerCase() == 'p') {
        if (currentIndex > 0) {
          currentIndex--;
        } else {
          print('You are on the first question.');
        }
      } else if (input.toLowerCase() == 's') {
        stdout.write('Are you sure you want to finish and submit? (y/n): ');
        final confirm = stdin.readLineSync()?.trim().toLowerCase();
        if (confirm == 'y') {
          break;
        }
      } else if (input.isNotEmpty) {
        currentResp.answerText = input;
        print('-> Answer saved.');
        if (currentIndex < total - 1) {
          currentIndex++;
        }
      }
    }

    // Submit attempt and calculate scores
    final summary = attempt.submit();
    print('\n========================================');
    print('QUIZ COMPLETE');
    print(summary);
    print('========================================\n');

    // Review phase
    _reviewIncorrectQuestions(attempt);
  }

  void _reviewIncorrectQuestions(Attempt attempt) {
    final incorrect = attempt.responses.where((r) => !r.isCorrect).toList();

    if (incorrect.isEmpty) {
      print('Outstanding! You got every question correct!');
      return;
    }

    stdout.write('Would you like to review incorrect questions? (y/n): ');
    final choice = stdin.readLineSync()?.trim().toLowerCase();
    if (choice != 'y') return;

    print('\n--- INCORRECT QUESTIONS REVIEW ---');
    for (var i = 0; i < incorrect.length; i++) {
      final resp = incorrect[i];
      final q = resp.question;

      print('\n[Review ${i + 1} of ${incorrect.length}]');
      print('Question: ${q.prompt}');
      print('Your answer: ${resp.answerText.isEmpty ? "(Unanswered)" : resp.answerText}');
      print('Correct answer: ${q.getExpectedAnswerText()}');
    }
    print('\nReview complete.\n');
  }
}


void main() {
  final sampleQuiz = Quiz(
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
        prompt: '_______ lets you inject updated source code into a running Dart VM.',
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

  final user = User(name: 'Student');
  final runner = QuizRunner(user: user, quiz: sampleQuiz);
  runner.run();

  user.viewResults();
}