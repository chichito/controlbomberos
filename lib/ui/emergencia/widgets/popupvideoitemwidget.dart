import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class Popupvideoitemwidget extends StatefulWidget {
  final Uint8List videoBytes;

  const Popupvideoitemwidget({super.key, required this.videoBytes});

  @override
  State<Popupvideoitemwidget> createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<Popupvideoitemwidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );
      await file.writeAsBytes(widget.videoBytes);
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error inicializando video: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return AlertDialog(
      contentPadding: EdgeInsets.zero, // Elimina bordes internos para el video
      backgroundColor: Colors.black,
      content: SizedBox(
        // 2. Define el ancho y alto deseado
        width:
            MediaQuery.of(context).size.width *
            0.9, // 90% del ancho de pantalla
        height: MediaQuery.of(context).size.height * 0.45, // A
        child: _controller!.value.isInitialized
            ? GestureDetector(
                onTap: _togglePlayPause,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller!),
                    if (!_controller!.value.isPlaying)
                      Icon(
                        Icons.play_circle_fill,
                        size: 60,
                        color: Colors.white70,
                      ),
                  ],
                ),
              )
            : SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}
