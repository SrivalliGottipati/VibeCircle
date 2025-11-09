import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import '../../../core/routers/app_router.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/wave_progress.dart';
import '../../experience_select/widgets/multi_line_field.dart';
import '../bloc/question_bloc.dart';
import '../bloc/question_event.dart';
import '../bloc/question_state.dart';
import '../widgets/audio_recorder.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../widgets/video_recorder.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionBloc(),
      child: const _QuestionView(),
    );
  }
}

class _QuestionView extends StatefulWidget {
  const _QuestionView();

  @override
  State<_QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<_QuestionView> {
  String? activeMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base1,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: BlocBuilder<QuestionBloc, QuestionState>(
            builder: (context, s) {
              final hasAudio = s.audio != null;
              final hasVideo = s.video != null;
              final canContinue = s.text.trim().isNotEmpty || hasAudio || hasVideo;
              final showSelector = !hasAudio && !hasVideo && activeMode == null;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 6),
                    const WaveProgress(step: 2),
                    const SizedBox(height: 24),

                    Text('Why do you want to host with us?',
                        style: Txt.h1.copyWith(color: AppColors.text1)),
                    const SizedBox(height: 10),

                    Text(
                      'Tell us about your intent and what motivates you to create experiences.',
                      style: Txt.body.copyWith(color: AppColors.text3),
                    ),
                    const SizedBox(height: 20),

                    MultiLineField(
                      hint: 'Start typing here...',
                      value: s.text,
                      maxWords: 600,
                      onChanged: (v) =>
                          context.read<QuestionBloc>().add(QuestionTextChanged(v)),
                    ),

                    const SizedBox(height: 16),

                    if (showSelector)
                      Row(
                        children: [
                          Expanded(
                            child: _IconBar(
                              onMic: () => setState(() => activeMode = 'audio'),
                              onVideo: () async {
                                final file = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const VideoRecorderScreen()),
                                );

                                if (file != null) {
                                  context.read<QuestionBloc>().add(QuestionAttachVideo(file));
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: _NextButton(canContinue: canContinue)),
                        ],
                      ),

                    if (activeMode == 'audio' && !hasAudio)
                      AudioRecorder(
                        onCancel: () => setState(() => activeMode = null),
                        onComplete: (f) {
                          context.read<QuestionBloc>().add(QuestionAttachAudio(f));
                          setState(() => activeMode = null);
                        },
                      ),

                    if (!showSelector)
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              if (hasAudio)
                                _RecordedTile(
                                  file: s.audio!,
                                  label: "Audio Recorded",
                                  onDelete: () =>
                                      context.read<QuestionBloc>().add(const QuestionDeleteAudio()),
                                ),

                              if (hasVideo)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: _RecordedTile(
                                    file: s.video!,
                                    label: "Video Recorded",
                                    onDelete: () =>
                                        context.read<QuestionBloc>().add(const QuestionDeleteVideo()),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                    if (!showSelector) ...[
                      const SizedBox(height: 14),
                      _NextButton(canContinue: canContinue),
                    ],

                    const SizedBox(height: 22),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


class _NextButton extends StatelessWidget {
  final bool canContinue;
  const _NextButton({required this.canContinue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canContinue
          ? () {
        // ✅ Navigate to Start Screen and remove previous screens
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.start,
              (route) => false,
        );
      }
          : null,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 54,
        borderRadius: 16,
        blur: 18,
        alignment: Alignment.center,
        border: 1.2,
        linearGradient: const LinearGradient(
          begin: Alignment.center,
          colors: [AppColors.border1, AppColors.border2, AppColors.border1],
        ),
        borderGradient: const LinearGradient(
          begin: Alignment.topCenter,
          colors: [AppColors.text4, Colors.transparent],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Next',
              style: Txt.button.copyWith(
                color: canContinue ? AppColors.text1 : AppColors.text3,
              ),
            ),
            if (canContinue) ...[
              const SizedBox(width: 8),
              Image.asset('assets/icons/arrow.png', height: 18, width: 18),
            ]
          ],
        ),
      ),
    );
  }
}


class _IconBar extends StatelessWidget {
  final VoidCallback onMic;
  final VoidCallback onVideo;
  const _IconBar({required this.onMic, required this.onVideo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border2),
        color: AppColors.base2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(onTap: onMic, child: Icon(Icons.mic, color: AppColors.text1)),
          Container(width: 1, height: 26, margin: const EdgeInsets.symmetric(horizontal: 18), color: AppColors.border3),
          GestureDetector(onTap: onVideo, child: Icon(Icons.videocam, color: AppColors.text1)),
        ],
      ),
    );
  }
}

class _RecordedTile extends StatefulWidget {
  final File file;
  final String label;
  final VoidCallback onDelete;
  const _RecordedTile({required this.file, required this.label, required this.onDelete});

  @override
  State<_RecordedTile> createState() => _RecordedTileState();
}

class _RecordedTileState extends State<_RecordedTile> {
  late final bool isVideo = widget.file.path.endsWith(".mp4");
  AudioPlayer? player;
  bool playing = false;
  Timer? t;
  List<double> wave = List.filled(40, 8);

  @override
  void initState() {
    super.initState();
    if (!isVideo) {
      player = AudioPlayer()..setFilePath(widget.file.path);
      player!.playerStateStream.listen((s) => setState(() => playing = s.playing));
      t = Timer.periodic(const Duration(milliseconds: 90), (_) {
        if (playing) setState(() => wave = List.generate(40, (_) => 6 + Random().nextDouble() * 20));
      });
    }
  }

  @override
  void dispose() {
    t?.cancel();
    player?.dispose();
    super.dispose();
  }

  void toggle() => playing ? player?.pause() : player?.play();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.label, style: Txt.body.copyWith(color: AppColors.text1))),
              GestureDetector(
                onTap: () async {
                  try { if (await widget.file.exists()) await widget.file.delete(); } catch (_) {}
                  widget.onDelete();
                },
                child: const Icon(Icons.delete_outline, color: AppColors.secondaryAccent),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: isVideo
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _FullScreenVideoPlayer(file: widget.file),
                    ),
                  );
                }
                    : toggle,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Color(0xFF6D5BFF), Color(0xFF8C7BFF)]),
                  ),
                  child: Icon(
                    isVideo ? Icons.play_arrow : (playing ? Icons.pause : Icons.play_arrow),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // ✅ Always show waveform for BOTH audio and video
              Expanded(
                child: CustomPaint(
                  size: const Size(double.infinity, 40),
                  painter: _PlayWavePainter(
                    isVideo
                        ? List.generate(40, (_) => 8 + Random().nextDouble() * 12)  // idle subtle wave for video
                        : (playing ? wave : List.filled(40, 6)),
                  ),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}

class _PlayWavePainter extends CustomPainter {
  final List<double> bars;
  _PlayWavePainter(this.bars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white..strokeWidth = 4..strokeCap = StrokeCap.round;
    final mid = size.height / 2;
    final step = size.width / bars.length;
    for (int i = 0; i < bars.length; i++) canvas.drawLine(Offset(i * step, mid - bars[i]), Offset(i * step, mid + bars[i]), paint);
  }

  @override
  bool shouldRepaint(_) => true;
}

class _FullScreenVideoPlayer extends StatefulWidget {
  final File file;
  const _FullScreenVideoPlayer({required this.file});

  @override
  State<_FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  late VideoPlayerController c;

  @override
  void initState() {
    super.initState();
    c = VideoPlayerController.file(widget.file)..initialize().then((_) => setState(() {}))..play();
  }

  @override
  void dispose() { c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: c.value.isInitialized ? AspectRatio(aspectRatio: c.value.aspectRatio, child: VideoPlayer(c)) : const CircularProgressIndicator()),
    );
  }
}
