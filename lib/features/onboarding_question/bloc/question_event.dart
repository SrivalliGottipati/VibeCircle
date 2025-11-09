import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();
  @override
  List<Object?> get props => [];
}

class QuestionTextChanged extends QuestionEvent {
  const QuestionTextChanged(this.text);
  final String text;
  @override
  List<Object?> get props => [text];
}

class QuestionAttachAudio extends QuestionEvent {
  const QuestionAttachAudio(this.file);
  final File file;
  @override
  List<Object?> get props => [file.path];
}

class QuestionAttachVideo extends QuestionEvent {
  const QuestionAttachVideo(this.file);
  final File file;
  @override
  List<Object?> get props => [file.path];
}

class QuestionDeleteAudio extends QuestionEvent {
  const QuestionDeleteAudio();
}

class QuestionDeleteVideo extends QuestionEvent {
  const QuestionDeleteVideo();
}
