import 'package:flutter/material.dart';

class Buscador extends StatefulWidget {
  final Function(int) onNavigate;

  const Buscador({super.key, required this.onNavigate});

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final List<Map<String, dynamic>> opciones = [
    {
      "titulo": "Ayuda",
      "index": 1,
      "keywords": ["ayuda", "soporte"]
    },
    {
      "titulo": "Configuración",
      "index": 2,
      "keywords": ["config", "ajustes", "contraseña", "clave"]
    },
    {
      "titulo": "Perfil",
      "index": 3,
      "keywords": ["perfil", "usuario", "cuenta"]
    },
  ];

  List<Map<String, dynamic>> resultados = [];

  void filtrar(String texto) {
    if (texto.isEmpty) {
      resultados = [];
      _removeOverlay();
    } else {
      resultados = opciones.where((opcion) {
        final titulo = opcion["titulo"].toLowerCase();
        final keywords =
            (opcion["keywords"] as List).map((e) => e.toLowerCase());

        return titulo.contains(texto.toLowerCase()) ||
            keywords.any((k) => k.contains(texto.toLowerCase()));
      }).toList();

      _showOverlay();
    }

    setState(() {});
  }

  void limpiar() {
    _controller.clear();
    resultados = [];
    _removeOverlay();
    setState(() {});
  }

  void navegar(int index) {
    limpiar();
    _focusNode.unfocus();
    widget.onNavigate(index);
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 45),
          showWhenUnlinked: false,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 250, // 👈 ancho fijo seguro
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Text(resultados[index]["titulo"]),
                    onTap: () =>
                        navegar(resultados[index]["index"]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: filtrar,
                decoration: const InputDecoration(
                  hintText: "Buscar...",
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ),
            if (_controller.text.isNotEmpty)
              GestureDetector(
                onTap: limpiar,
                child: const Icon(Icons.close, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}