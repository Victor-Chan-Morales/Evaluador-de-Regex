// lib/main.dart
import 'package:flutter/material.dart';
import 'Funcionalidades/regex.dart';

void main() {
  runApp(const RegexApp());
}

class RegexApp extends StatelessWidget {
  const RegexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Herramienta Regex',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RegexHomePage(),
    );
  }
}

class RegexHomePage extends StatefulWidget {
  const RegexHomePage({super.key});

  @override
  State<RegexHomePage> createState() => _RegexHomePageState();
}

class _RegexHomePageState extends State<RegexHomePage> {
  final TextEditingController _regexController = TextEditingController();
  final TextEditingController _textoController = TextEditingController();

  String? _error;
  List<String> _coincidencias = [];

  /// Resaltar coincidencias dentro del texto
  List<TextSpan> _resaltarTexto(String texto, String pattern) {
    final spans = <TextSpan>[];
    if (pattern.isEmpty) {
      spans.add(TextSpan(text: texto));
      return spans;
    }

    try {
      final regex = RegExp(pattern);
      int lastMatchEnd = 0;
      for (final match in regex.allMatches(texto)) {
        if (match.start > lastMatchEnd) {
          spans.add(TextSpan(text: texto.substring(lastMatchEnd, match.start)));
        }
        spans.add(
          TextSpan(
            text: texto.substring(match.start, match.end),
            style: const TextStyle(
              backgroundColor: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        lastMatchEnd = match.end;
      }
      if (lastMatchEnd < texto.length) {
        spans.add(TextSpan(text: texto.substring(lastMatchEnd)));
      }
    } catch (_) {
      spans.add(TextSpan(text: texto));
    }

    return spans;
  }

  void _procesar() {
    final regexInput = _regexController.text;
    final texto = _textoController.text;

    // Validación de regex
    final error = RegexTool.validarRegex(regexInput);
    if (error != null) {
      setState(() {
        _error = error;
        _coincidencias = [];
      });
      return;
    }

    // Validación de número de líneas
    if (texto.trim().split("\n").length < 5) {
      setState(() {
        _error = "Debe ingresar al menos 5 líneas de texto.";
        _coincidencias = [];
      });
      return;
    }

    // Procesar coincidencias
    final matches = RegexTool.aplicarRegex(regexInput, texto);
    setState(() {
      _error = null;
      _coincidencias = matches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Herramienta Regex")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Entrada regex
            TextField(
              controller: _regexController,
              decoration: const InputDecoration(
                labelText: "Expresión Regular",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Entrada texto
            Expanded(
              child: TextField(
                controller: _textoController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: "Texto (mínimo 5 líneas)",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(onPressed: _procesar, child: const Text("Procesar")),
            const SizedBox(height: 12),

            // Mostrar errores
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            // Mostrar coincidencias
            if (_coincidencias.isNotEmpty) ...[
              const Text(
                "Coincidencias encontradas:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: _coincidencias
                    .map((c) => Chip(label: Text(c)))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: _resaltarTexto(
                        _textoController.text,
                        _regexController.text,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
