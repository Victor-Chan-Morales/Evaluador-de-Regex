import 'package:flutter/material.dart';
import '../Funcionalidades/regex.dart';

class RegexAnalyzerScreen extends StatefulWidget {
  const RegexAnalyzerScreen({super.key});

  @override
  State<RegexAnalyzerScreen> createState() => _RegexAnalyzerScreenState();
}

class _RegexAnalyzerScreenState extends State<RegexAnalyzerScreen> {
  final TextEditingController _regexController = TextEditingController();
  final TextEditingController _textoController = TextEditingController();

  String? _error;
  List<String> _coincidencias = [];
  int _numeroLineas = 0;
  bool _mostrarResultados = false;

  @override
  void initState() {
    super.initState();
    _textoController.addListener(_actualizarContadorLineas);
  }

  @override
  void dispose() {
    _textoController.removeListener(_actualizarContadorLineas);
    _regexController.dispose();
    _textoController.dispose();
    super.dispose();
  }

  void _actualizarContadorLineas() {
    final texto = _textoController.text;
    final lineas = texto.isEmpty ? 0 : texto.split('\n').length;
    if (lineas != _numeroLineas) {
      setState(() {
        _numeroLineas = lineas;
      });
    }
  }

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
    final regexInput = _regexController.text.trim();
    final texto = _textoController.text.trim();

    // Validación de campos vacíos
    if (regexInput.isEmpty) {
      setState(() {
        _error = "Debe ingresar una expresión regular.";
        _coincidencias = [];
        _mostrarResultados = false;
      });
      return;
    }

    if (texto.isEmpty) {
      setState(() {
        _error = "Debe ingresar texto para analizar.";
        _coincidencias = [];
        _mostrarResultados = false;
      });
      return;
    }

    // Validación de número de líneas mínimas
    final lineas = texto.split("\n");
    if (lineas.length < 5) {
      setState(() {
        _error =
            "El texto debe tener al menos 5 líneas para poder ser evaluado. "
            "Actualmente tiene ${lineas.length} línea${lineas.length == 1 ? '' : 's'}. "
            "Por favor, agregue ${5 - lineas.length} línea${5 - lineas.length == 1 ? '' : 's'} más.";
        _coincidencias = [];
        _mostrarResultados = false;
      });
      return;
    }

    // Validación de regex
    final error = RegexTool.validarRegex(regexInput);
    if (error != null) {
      setState(() {
        _error = error;
        _coincidencias = [];
        _mostrarResultados = false;
      });
      return;
    }

    // Procesar coincidencias
    final matches = RegexTool.aplicarRegex(regexInput, texto);
    setState(() {
      _error = null;
      _coincidencias = matches;
      _mostrarResultados = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Analizador de Regex",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: 'Regresar al inicio',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de entrada de datos
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuración',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Colors.blue.shade800, fontSize: 24),
                    ),
                    const SizedBox(height: 16),

                    // Entrada regex
                    TextField(
                      controller: _regexController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: "Expresión Regular",
                        labelStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey.shade600),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Ejemplo: \\d+|[a-zA-Z]+",
                        hintStyle: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade400),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Entrada texto
                    SizedBox(
                      height: 200,
                      child: TextField(
                        controller: _textoController,
                        maxLines: null,
                        expands: true,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          labelText: "Texto para analizar (mínimo 5 líneas)",
                          labelStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                          prefixIcon: const Icon(Icons.text_fields),
                          hintText:
                              "Ingresa el texto que deseas analizar...\n"
                              "IMPORTANTE: Debe tener al menos 5 líneas\n"
                              "Presiona Enter para crear nuevas líneas",
                          hintStyle: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Contador de líneas
                    Row(
                      children: [
                        Icon(
                          _numeroLineas >= 5 ? Icons.check_circle : Icons.info,
                          size: 16,
                          color: _numeroLineas >= 5
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Líneas: $_numeroLineas/5 ${_numeroLineas >= 5 ? '✓' : '(faltan ${5 - _numeroLineas})'}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _numeroLineas >= 5
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Botón de procesamiento
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _procesar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(
                          "Procesar Regex",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sección de resultados
            if (_mostrarResultados || _error != null) ...[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _error != null ? Icons.error : Icons.check_circle,
                            color: _error != null ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Resultados del Análisis',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: _error != null
                                      ? Colors.red.shade800
                                      : Colors.green.shade800,
                                  fontSize: 22,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Mostrar errores
                      if (_error != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Error encontrado:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: Colors.red.shade700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _error!,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.red.shade700),
                              ),
                            ],
                          ),
                        ),

                      // Mostrar coincidencias o mensaje de sin coincidencias
                      if (_error == null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _coincidencias.isNotEmpty
                                ? Colors.green.shade50
                                : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _coincidencias.isNotEmpty
                                  ? Colors.green.shade200
                                  : Colors.orange.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _coincidencias.isNotEmpty
                                        ? Icons.check_circle_outline
                                        : Icons.info_outline,
                                    color: _coincidencias.isNotEmpty
                                        ? Colors.green.shade600
                                        : Colors.orange.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _coincidencias.isNotEmpty
                                        ? 'Coincidencias encontradas (${_coincidencias.length}):'
                                        : 'No se encontraron coincidencias',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: _coincidencias.isNotEmpty
                                              ? Colors.green.shade700
                                              : Colors.orange.shade700,
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                              if (_coincidencias.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _coincidencias
                                      .map(
                                        (c) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue.shade300,
                                            ),
                                          ),
                                          child: Text(
                                            c,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Colors.blue.shade800,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ] else ...[
                                const SizedBox(height: 8),
                                Text(
                                  'La expresión regular es válida pero no coincide con ningún texto en el contenido proporcionado.',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Colors.orange.shade700,
                                        fontSize: 14,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Texto con coincidencias resaltadas (solo si hay coincidencias)
                        if (_coincidencias.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Texto con coincidencias resaltadas:',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxHeight: 300),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
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
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Botón para regresar (adicional)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.blue.shade300),
                ),
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  "Regresar al Inicio",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
