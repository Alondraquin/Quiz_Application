import 'Question.dart';

class Response {
  final Question question;
  String answerText;
  bool isCorrect;
  int awardedPoints;

  Response({
    required this.question,
    this.answerText = '',
    this.isCorrect = false,
    this.awardedPoints = 0,
  });

  void evaluate() {
    isCorrect = question.validateAnswer(answerText);
    awardedPoints = isCorrect ? question.points : 0;
  }
}