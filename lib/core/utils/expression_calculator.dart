class ExpressionCalculator {
  const ExpressionCalculator._();

  static String evaluate(String expression) {
    try {
      String cleanExpr = expression;
      if (cleanExpr.endsWith('+') ||
          cleanExpr.endsWith('-') ||
          cleanExpr.endsWith('x')) {
        cleanExpr = cleanExpr.substring(0, cleanExpr.length - 1);
      }

      String parsedExpr = cleanExpr.replaceAll('x', '*');

      final RegExp regExp = RegExp(r'(\d+)|([+\-*])');
      var matches =
          regExp.allMatches(parsedExpr).map((m) => m.group(0)!).toList();
      if (matches.isEmpty) return '0';

      if (matches.isNotEmpty && matches[0] == '-') {
        if (matches.length >= 2) {
          matches[1] = '-${matches[1]}';
          matches.removeAt(0);
        }
      }

      final List<String> afterMul = [];
      for (var i = 0; i < matches.length; i++) {
        if (i > 0 && matches[i] == '*') {
          final prev = afterMul.removeLast();
          final next = matches[i + 1];
          afterMul.add(
            (int.parse(prev) * int.parse(next)).toString(),
          );
          i++;
        } else {
          afterMul.add(matches[i]);
        }
      }

      int total = int.tryParse(afterMul[0]) ?? 0;
      for (var i = 1; i < afterMul.length; i += 2) {
        if (i + 1 >= afterMul.length) break;
        final op = afterMul[i];
        final nextValue = int.tryParse(afterMul[i + 1]) ?? 0;
        if (op == '+') total += nextValue;
        if (op == '-') total -= nextValue;
      }

      return total.toString();
    } catch (_) {
      return '0';
    }
  }
}
