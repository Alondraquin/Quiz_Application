class Result {
  final int score;
  final int totalPossible;
  final DateTime generatedAt;

  Result({
    required this.score,
    required this.totalPossible,
  }) : generatedAt = DateTime.now();

  @override
  String toString() {
    final percentage =
        totalPossible > 0 ? (score / totalPossible * 100).toStringAsFixed(1) : '0';
    return 'Final Score: $score / $totalPossible ($percentage%)';
  }
}