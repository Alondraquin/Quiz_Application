import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_application/main.dart';

void main() {
  const quiz = QuizPreview(
    title: 'Sample quiz',
    description: 'A short sample.',
    questions: [
      QuestionPreview(
        prompt: 'Which is the root widget?',
        points: 1,
        options: ['Center', 'Text'],
        correctOption: 0,
      ),
    ],
  );

  testWidgets('shows the quiz welcome screen and opens question one',
      (tester) async {
    await tester.pumpWidget(const QuizApp(quiz: quiz));

    expect(find.text('Ready to test\nyour knowledge?'), findsOneWidget);
    expect(find.text('Sample quiz'), findsOneWidget);
    expect(find.text('1 questions'), findsOneWidget);

    await tester.tap(find.text('Start quiz'));
    await tester.pumpAndSettle();

    expect(find.text('QUESTION 1'), findsOneWidget);
    expect(find.text('Which is the root widget?'), findsOneWidget);
    expect(find.text('Center'), findsOneWidget);
  });
}
