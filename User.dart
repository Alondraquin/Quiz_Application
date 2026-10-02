class User {
  final String name;
  final List<Attempt> attempts = []; 

  User({required this.name});

  Attempt startAttempt(Quiz quiz) {
    final attempt = Attempt(quiz: quiz);
    attempts.add(attempt);
    return attempt;
  }

  void viewResults() {
    print('\n--- Results History for $name ---');
    if (attempts.isEmpty) {
      print('No attempts completed yet.');
      return;
    }
    for (var i = 0; i < attempts.length; i++) {
      final a = attempts[i];
      print('Attempt #${i + 1} - ${a.quiz.title}: ${a.result}');
    }
  }
}