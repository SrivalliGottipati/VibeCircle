import 'package:flutter_bloc/flutter_bloc.dart';
import 'question_event.dart';
import 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(const QuestionState()) {
    on<QuestionTextChanged>((e, emit) => emit(state.copyWith(text: e.text)));
    on<QuestionAttachAudio>((e, emit) => emit(state.copyWith(audio: e.file)));
    on<QuestionAttachVideo>((e, emit) => emit(state.copyWith(video: e.file)));
    on<QuestionDeleteAudio>((e, emit) => emit(state.copyWith(audio: null)));
    on<QuestionDeleteVideo>((e, emit) => emit(state.copyWith(video: null)));
  }
}
