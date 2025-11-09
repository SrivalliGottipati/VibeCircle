import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/experience.dart';
import '../../../data/repositories/experience_repository.dart';
import 'experience_event.dart';
import 'experience_state.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  ExperienceBloc(this._repo) : super(const ExperienceLoading()) {
    on<ExperienceRequested>(_onRequested);
    on<ToggleExperience>(_onToggle);
    on<NoteChanged>(_onNote);
  }

  final ExperienceRepository _repo;

  Future<void> _onRequested(
      ExperienceRequested event,
      Emitter<ExperienceState> emit,
      ) async {
    emit(const ExperienceLoading());
    try {
      final items = await _repo.fetch();
      emit(ExperienceLoaded(items: items));
    } catch (e) {
      emit(ExperienceError(e.toString()));
    }
  }

  void _onToggle(ToggleExperience e, Emitter<ExperienceState> emit) {
    final s = state;
    if (s is ExperienceLoaded) {
      final selected = List<int>.from(s.selectedIds);
      if (selected.contains(e.id)) {
        selected.remove(e.id);
      } else {
        selected.add(e.id);
      }
      // Move selected to front (animation handled by AnimatedSwitcher)
      final sorted = List<Experience>.from(s.items)
        ..sort((a, b) {
          final ai = selected.contains(a.id) ? 0 : 1;
          final bi = selected.contains(b.id) ? 0 : 1;
          return ai.compareTo(bi);
        });
      emit(s.copyWith(selectedIds: selected, items: sorted));
    }
  }

  void _onNote(NoteChanged e, Emitter<ExperienceState> emit) {
    final s = state;
    if (s is ExperienceLoaded) {
      emit(s.copyWith(note: e.note));
    }
  }
}
