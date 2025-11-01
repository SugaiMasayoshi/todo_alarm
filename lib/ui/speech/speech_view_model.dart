import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/speech_to_text_repository.dart';
import 'package:todo_alarm/ui/speech/speech_state.dart';

part '../../generated/ui/speech/speech_view_model.g.dart';

@riverpod
class SpeechViewModel extends _$SpeechViewModel {
  @override
  SpeechState build() {
    return const SpeechState();
  }

  Future<bool> initialize() async {
    try {
      final repository = ref.read(speechToTextRepositoryProvider);
      final success = await repository.initialize();

      if (success) {
        state = state.copyWith(isInitialized: true, errorMessage: null);
      } else {
        state = state.copyWith(
          isInitialized: false,
          errorMessage: '音声認識の初期化に失敗しました',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(isInitialized: false, errorMessage: '初期化エラー: $e');
      return false;
    }
  }

  Future<void> startListening({String? localeId}) async {
    if (!state.isInitialized) {
      state = state.copyWith(errorMessage: '先に初期化してください');
      return;
    }

    try {
      final repository = ref.read(speechToTextRepositoryProvider);

      state = state.copyWith(isListening: true, errorMessage: null);

      await repository.startListening(
        onResult: (String result) {
          state = state.copyWith(recognizedText: result);
        },
        localeId: localeId,
      );
    } catch (e) {
      state = state.copyWith(isListening: false, errorMessage: 'リスニングエラー: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      final repository = ref.read(speechToTextRepositoryProvider);
      await repository.stopListening();

      state = state.copyWith(isListening: false);
    } catch (e) {
      state = state.copyWith(errorMessage: '停止エラー: $e');
    }
  }

  void clearText() {
    state = state.copyWith(recognizedText: '');
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
