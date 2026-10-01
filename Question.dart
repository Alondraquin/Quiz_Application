class Question {
  final String prompt;
  final QuestionType type;
  final int points;
  final List<AnswerOption> options; 

  Question({
    required this.prompt,
    required this.type,
    this.points = 1,
    this.options = const [],
  });

  /// Validates the provided answer string against valid options/answers.
  bool validateAnswer(String answer) {
    final cleanAnswer = answer.trim();

    if (type == QuestionType.MULTIPLE_CHOICE) {
      final selectedIndex = int.tryParse(cleanAnswer);
      if (selectedIndex != null &&
          selectedIndex >= 1 &&
          selectedIndex <= options.length) {
        return options[selectedIndex - 1].isCorrect;
      }
      return false;
    } else {// FILL_IN_BLANK: Case-insensitive match against all valid answers
      return options.any((opt) =>
          opt.isCorrect &&
          opt.text.trim().toLowerCase() == cleanAnswer.toLowerCase());
    }
  }

String getExpectedAnswerText() {
    if (type == QuestionType.MULTIPLE_CHOICE) {
      final correctOpt = options.firstWhere((opt) => opt.isCorrect,
          orElse: () => AnswerOption(text: 'N/A', isCorrect: false));
      return correctOpt.text;
    } else {
      return options.map((opt) => opt.text).join(' OR ');
    }
  }
}  