import 'dart:core';

class RegexTool {
  static String? validarRegex(String pattern) {
    try {
      RegExp(pattern);
    } catch (e) {
      return "Regex inválida: ${e.toString()}";
    }

    if (_tieneParentesisDesbalanceados(pattern)) {
      return "Error: Paréntesis sin cerrar.";
    }
    if (_tieneCorchetesDesbalanceados(pattern)) {
      return "Error: Corchetes sin cerrar.";
    }

    return null;
  }

  static List<String> aplicarRegex(String pattern, String texto) {
    final regex = RegExp(pattern);
    return regex.allMatches(texto).map((m) => m.group(0)!).toList();
  }

  static bool _tieneParentesisDesbalanceados(String s) {
    int balance = 0;
    for (var c in s.split('')) {
      if (c == '(') balance++;
      if (c == ')') balance--;
      if (balance < 0) return true;
    }
    return balance != 0;
  }

  static bool _tieneCorchetesDesbalanceados(String s) {
    int balance = 0;
    for (var c in s.split('')) {
      if (c == '[') balance++;
      if (c == ']') balance--;
      if (balance < 0) return true;
    }
    return balance != 0;
  }
}
