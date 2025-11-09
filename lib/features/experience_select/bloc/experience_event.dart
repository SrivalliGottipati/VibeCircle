import 'package:equatable/equatable.dart';

abstract class ExperienceEvent extends Equatable {
  const ExperienceEvent();
  @override
  List<Object?> get props => [];
}

class ExperienceRequested extends ExperienceEvent {
  const ExperienceRequested();
}

class ToggleExperience extends ExperienceEvent {
  const ToggleExperience(this.id);
  final int id;
  @override
  List<Object?> get props => [id];
}

class NoteChanged extends ExperienceEvent {
  const NoteChanged(this.note);
  final String note;
  @override
  List<Object?> get props => [note];
}
