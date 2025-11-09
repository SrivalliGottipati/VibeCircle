import 'dart:io';
import 'package:equatable/equatable.dart';

class QuestionState extends Equatable {
  const QuestionState({this.text = '', this.audio, this.video});

  final String text;
  final File? audio;
  final File? video;

  QuestionState copyWith({String? text, File? audio, File? video}) {
    return QuestionState(
      text: text ?? this.text,
      audio: audio,
      video: video,
    );
  }

  @override
  List<Object?> get props => [text, audio?.path, video?.path];
}
