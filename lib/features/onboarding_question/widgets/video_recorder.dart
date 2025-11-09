import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class VideoRecorderScreen extends StatelessWidget {
  const VideoRecorderScreen({super.key});

  Future<void> _record(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickVideo(source: ImageSource.camera);

    if (picked == null) {
      Navigator.pop(context, null);
      return;
    }

    // Copy video into app storage so we can delete it later
    final tempDir = await getTemporaryDirectory();
    final newPath = '${tempDir.path}/vibe_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final copiedFile = await File(picked.path).copy(newPath);

    Navigator.pop(context, copiedFile);
  }

  @override
  Widget build(BuildContext context) {
    _record(context);

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
