import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/ui/speech/speech_state.freezed.dart';

@freezed
abstract class SpeechState with _$SpeechState {
  const factory SpeechState({
    @Default('') String recognizedText,
    @Default(false) bool isListening,
    @Default(false) bool isInitialized,
    @Default(0) int emergencyTapCount,
    String? errorMessage,
  }) = _SpeechState;
}
