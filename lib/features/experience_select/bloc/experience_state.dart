import 'package:equatable/equatable.dart';
import '../../../data/models/experience.dart';

abstract class ExperienceState extends Equatable {
  const ExperienceState();
  @override
  List<Object?> get props => [];
}

class ExperienceLoading extends ExperienceState {
  const ExperienceLoading();
}

class ExperienceError extends ExperienceState {
  const ExperienceError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ExperienceLoaded extends ExperienceState {
  const ExperienceLoaded({
    required this.items,
    this.selectedIds = const [],
    this.note = '',
  });

  final List<Experience> items;
  final List<int> selectedIds;
  final String note;

  ExperienceLoaded copyWith({
    List<Experience>? items,
    List<int>? selectedIds,
    String? note,
  }) {
    return ExperienceLoaded(
      items: items ?? this.items,
      selectedIds: selectedIds ?? this.selectedIds,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [items, selectedIds, note];
}
