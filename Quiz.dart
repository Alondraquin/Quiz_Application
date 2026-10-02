import 'Question.dart';

class Quiz {
  final String title;
  final String description;
  final List<Question> questions;

  Quiz({
    required this.title,
    required this.description,
    required this.questions,
  });

  void display() {
    print('========================================');
    print('Quiz: $title');
    print('Description: $description');
    print('Total Questions: ${questions.length}');
    print('========================================\n');
  }
}