import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routers/app_router.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/experience_repository.dart';
import '../../../widgets/wave_progress.dart';
import '../bloc/experience_bloc.dart';
import '../bloc/experience_event.dart';
import '../bloc/experience_state.dart';
import '../widgets/experience_card.dart';
import '../widgets/multi_line_field.dart';
import 'package:glassmorphism/glassmorphism.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExperienceBloc(context.read<ExperienceRepository>())
        ..add(const ExperienceRequested()),
      child: const _ExperienceView(),
    );
  }
}

class _ExperienceView extends StatefulWidget {
  const _ExperienceView();

  @override
  State<_ExperienceView> createState() => _ExperienceViewState();
}

class _ExperienceViewState extends State<_ExperienceView> {
  bool showGrid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base1,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),

      // CLOSE KEYBOARD ON TAP OUTSIDE
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<ExperienceBloc, ExperienceState>(
              builder: (context, state) {
                if (state is ExperienceLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ExperienceError) {
                  return Center(child: Text(state.message, style: Txt.body));
                }

                final s = state as ExperienceLoaded;
                final canContinue =
                    s.selectedIds.isNotEmpty || s.note.trim().isNotEmpty;
                final hasSelectedAnyCard = s.selectedIds.isNotEmpty;

                return AnimatedPadding(
                  duration: const Duration(milliseconds: 290),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),

                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        const WaveProgress(step: 1),
                        const SizedBox(height: 28),

                        Text(
                          'What kind of hotspots do you want to host?',
                          style: Txt.h1.copyWith(color: AppColors.text1),
                        ),

                        const SizedBox(height: 8),

                        GestureDetector(
                          onTap: () => setState(() => showGrid = !showGrid),
                          child: Text(
                            showGrid ? "Show less" : "See all",
                            style: Txt.body.copyWith(color: AppColors.text2),
                          ),
                        ),

                        const SizedBox(height: 22),

                        showGrid
                            ? AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: s.items.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (ctx, i) {
                              final it = s.items[i];
                              return ExperienceCard(
                                index: i,
                                title: it.name,
                                imageUrl: it.imageUrl,
                                selected: s.selectedIds.contains(it.id),
                                onTap: () => context
                                    .read<ExperienceBloc>()
                                    .add(ToggleExperience(it.id)),
                              );
                            },
                          ),
                        )
                            : SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: s.items.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                            itemBuilder: (ctx, i) {
                              final it = s.items[i];
                              return ExperienceCard(
                                index: i,
                                title: it.name,
                                imageUrl: it.imageUrl,
                                selected: s.selectedIds.contains(it.id),
                                onTap: () => context
                                    .read<ExperienceBloc>()
                                    .add(ToggleExperience(it.id)),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 34),

                        MultiLineField(
                          hint: 'Describe your perfect hotspot',
                          value: s.note,
                          maxWords: 250,              // <<<< HERE
                          onChanged: (v) =>
                              context.read<ExperienceBloc>().add(NoteChanged(v)),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.darken,
                                shaderCallback: (Rect bounds) {
                                  return RadialGradient(
                                    center: const Alignment(0, -1.0),
                                    radius: 1.35,
                                    colors: [
                                      AppColors.surfaceBlack2,
                                      Colors.transparent,
                                    ],
                                  ).createShader(bounds);
                                },
                                child: GlassmorphicContainer(
                                  width: double.infinity,
                                  height: 56,
                                  borderRadius: 16,
                                  blur: 18,
                                  alignment: Alignment.center,
                                  border: 1.4,
                                  linearGradient: const LinearGradient(
                                    begin: Alignment.center,
                                    colors: [
                                      AppColors.border1,
                                      AppColors.border2,
                                      AppColors.border1,
                                    ],
                                    stops: [0.0, 1.0, 0.0],
                                  ),
                                  borderGradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    colors: [
                                      AppColors.text4,
                                      Colors.transparent,
                                    ],
                                    stops: [1.0, 1.0],
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: canContinue
                                    ? () {
                                  Navigator.of(context).pushNamed(
                                    AppRouter.question,
                                    arguments: {
                                      'selected': s.selectedIds,
                                      'note': s.note,
                                    },
                                  );
                                }
                                    : null,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Next',
                                      style: Txt.button.copyWith(
                                        color: canContinue
                                            ? AppColors.text1
                                            : AppColors.text3,
                                      ),
                                    ),

                                    if (hasSelectedAnyCard) ...[
                                      const SizedBox(width: 10),
                                      Image.asset(
                                        canContinue
                                            ? 'assets/icons/arrow.png'
                                            : 'assets/icons/arrow_grey.png',
                                        height: canContinue ? 22 : 18,
                                        width: canContinue ? 22 : 18,
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
