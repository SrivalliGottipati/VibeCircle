import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart' as rec;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class AudioRecorder extends StatefulWidget {
  final ValueChanged<File> onComplete;
  final VoidCallback onCancel;
  const AudioRecorder({super.key, required this.onComplete, required this.onCancel});

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  final rec.AudioRecorder _rec = rec.AudioRecorder();
  StreamSubscription<rec.Amplitude>? _sub;
  List<double> wave = List.filled(40, 8);
  bool recording = false;
  int seconds = 0;
  Timer? timer;

  Future<void> start() async {
    if (!await Permission.microphone.request().isGranted) return;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/aud-${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _rec.start(const rec.RecordConfig(), path: path);

    _sub = _rec.onAmplitudeChanged(const Duration(milliseconds: 90)).listen((a) {
      setState(() {
        wave = List.generate(40, (_) => 6 + Random().nextDouble() * 22);
      });
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => seconds++);
    });

    setState(() => recording = true);
  }

  Future<void> stop({bool cancel = false}) async {
    final path = await _rec.stop();
    await _sub?.cancel();
    timer?.cancel();

    if (!cancel && path != null) widget.onComplete(File(path));
    if (cancel) widget.onCancel();
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  void dispose() {
    timer?.cancel();
    _sub?.cancel();
    _rec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recording Audio…", style: Txt.body.copyWith(color: AppColors.text1)),
          const SizedBox(height: 14),

          Row(
            children: [
              // Pulse Animated Mic
              _PulsingCircle(
                child: const Icon(Icons.mic, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: CustomPaint(
                  size: const Size(double.infinity, 50),
                  painter: _WavePainter(wave),
                ),
              ),

              const SizedBox(width: 12),
              Text(
                _formatTime(seconds),
                style: Txt.body.copyWith(color: AppColors.primaryAccent),
              )
            ],
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => stop(cancel: true),
                child: Text("Cancel", style: Txt.body.copyWith(color: AppColors.text3)),
              ),
              const SizedBox(width: 12),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.primaryAccent),
                onPressed: stop,
                child: const Text("Done", style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _formatTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, "0");
    final sec = (s % 60).toString().padLeft(2, "0");
    return "$m:$sec";
  }
}

class _WavePainter extends CustomPainter {
  final List<double> bars;
  _WavePainter(this.bars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final mid = size.height / 2;
    final spacing = 4.0;
    final step = 3 + spacing;

    for (int i = 0; i < bars.length; i++) {
      final x = i * step;
      if (x > size.width) break;
      canvas.drawLine(
        Offset(x, mid - bars[i]),
        Offset(x, mid + bars[i]),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

class _PulsingCircle extends StatefulWidget {
  final Widget child;
  const _PulsingCircle({required this.child});

  @override
  State<_PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<_PulsingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController c;

  @override
  void initState() {
    super.initState();
    c = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: c,
      builder: (_, __) {
        final scale = 1 + (c.value * 0.25);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF6D5BFF), Color(0xFF8C7BFF)],
              ),
            ),
            alignment: Alignment.center,
            child: widget.child,
          ),
        );
      },
    );
  }
}
