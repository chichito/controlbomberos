import 'dart:typed_data';

import 'package:flutter/material.dart';

class Popupimagenitemwidget extends StatefulWidget {
  const Popupimagenitemwidget({super.key, required this.imagenBytes});
  final Uint8List imagenBytes;

  @override
  State<Popupimagenitemwidget> createState() => _PopupimagenitemwidgetState();
}

class _PopupimagenitemwidgetState extends State<Popupimagenitemwidget> {
  final TransformationController _transformationController =
      TransformationController();

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      // Si ya tiene zoom, vuelve al tamaño original
      _transformationController.value = Matrix4.identity();
    } else {
      // Si está normal, aplica un zoom de 2.5x centrado
      _transformationController.value = Matrix4.identity()
        ..translate(-200.0, -200.0) // Ajusta las coordenadas según tu diseño
        ..scale(2.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero, // Elimina bordes internos para el video
      backgroundColor: Colors.black,
      content: SizedBox(
        // 2. Define el ancho y alto deseado
        width:
            MediaQuery.of(context).size.width *
            0.9, // 90% del ancho de pantalla
        height: MediaQuery.of(context).size.height * 0.45, // A
        child: GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: InteractiveViewer(
            transformationController: _transformationController,
            clipBehavior: Clip
                .none, // Permite que la imagen se amplíe fuera de sus límites visuales
            minScale: 1.0, // Escala mínima permitida (normal)
            maxScale: 4.0, // Escala máxima permitida (4x de zoom)
            child: Image.memory(widget.imagenBytes, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
