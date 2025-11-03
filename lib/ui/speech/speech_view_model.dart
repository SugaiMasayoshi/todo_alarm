import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/speech_to_text_repository.dart';
import 'package:todo_alarm/ui/speech/speech_state.dart';

part '../../generated/ui/speech/speech_view_model.g.dart';

@Riverpod(keepAlive: true)
class SpeechViewModel extends _$SpeechViewModel {
  @override
  SpeechState build() {
    return const SpeechState();
  }

  Future<bool> initialize() async {
    try {
      final repository = ref.read(speechToTextRepositoryProvider);
      final success = await repository.initialize(
        onStatus: (status) {
          print('🎤 ステータス: $status');

          if (status == 'notListening' || status == 'done') {
            state = state.copyWith(isListening: false);
          }
        },
        onError: (errorMsg) {
          print('❌ 音声認識エラー: $errorMsg');

          state = state.copyWith(
            isListening: false,
            errorMessage: '音声認識エラー: $errorMsg',
          );
        },
      );

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
      final initialized = await initialize();
      if (!initialized) {
        state = state.copyWith(isListening: false);
        return;
      }
    }

    try {
      state = state.copyWith(isListening: true, errorMessage: null);
      final repository = ref.read(speechToTextRepositoryProvider);
      await repository.startListening(
        onResult: (String result) {
          state = state.copyWith(recognizedText: result);
        },
        localeId: localeId,
      );
    } catch (e) {
      print('❌ Error in startListening: $e');
      state = state.copyWith(isListening: false, errorMessage: 'リスニングエラー: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      final repository = ref.read(speechToTextRepositoryProvider);
      await repository.stopListening();

      state = state.copyWith(isListening: false);
    } catch (e) {
      print('❌ Error in stopListening: $e');
      state = state.copyWith(isListening: false, errorMessage: '停止エラー: $e');
    }
  }

  void clearText() {
    state = state.copyWith(recognizedText: '');
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
