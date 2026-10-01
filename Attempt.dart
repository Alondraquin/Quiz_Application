class Attempt {
  final Quiz quiz; 
  final DateTime startedAt;
  DateTime? submittedAt;
  final List<Response> responses = [];
  Result? result;

  Attempt({required this.quiz}) : startedAt = DateTime.now() {
    for (final q in quiz.questions) {
      responses.add(Response(question: q));
    }
  }

  int calculateScore() {
    return responses.fold(0, (sum, res) => sum + res.awardedPoints);
  }

  Result submit() {
    submittedAt = DateTime.now();
    for (final r in responses) {
      r.evaluate();
    }
    final totalPoints = calculateScore();
    final maxPoints = quiz.questions.fold(0, (sum, q) => sum + q.points);
    result = Result(score: totalPoints, totalPossible: maxPoints);
    return result!;
  }
}
