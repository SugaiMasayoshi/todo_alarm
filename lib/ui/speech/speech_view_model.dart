import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/alarm_repository.dart';
import 'package:todo_alarm/repositories/speech_to_text_repository.dart';
import 'package:todo_alarm/repositories/todo_list_repository.dart';
import 'package:todo_alarm/routes/app_router.dart';
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

          _stopAlarm();
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

  void _stopAlarm() async {
    print('🔍 認識されたテキスト: ${state.recognizedText}');
    _matchRecognizedTextWithGoals();
    Future.delayed(Duration(seconds: 3), () {
      clearText();
    });
  }

  void _matchRecognizedTextWithGoals() {
    const double threshold = 0.5;

    final recognized = state.recognizedText.trim().toLowerCase();
    if (recognized.isEmpty) return;

    final todoListRepository = ref.read(todoListRepositoryProvider);
    final todoList = todoListRepository.load();

    if (todoList.items.isEmpty) return;

    final first = todoList.items.first;
    final title = first.title.trim().toLowerCase();
    if (title.isEmpty) return;

    final matchedCount = _longestCommonSubsequenceLength(recognized, title);

    final totalLength = title.runes.length + recognized.runes.length;
    final ratio = totalLength == 0 ? 0.0 : (matchedCount * 2) / totalLength;

    print(
      '🔎 比較(先頭のみ, LCSベース): "$title" / matched=$matchedCount ratio=${ratio.toStringAsFixed(2)}',
    );

    if (ratio >= threshold) {
      print(
        '✅ 先頭 todo にマッチ: ${first.title} (ratio=${ratio.toStringAsFixed(2)}) -> アラーム停止',
      );
      ref.read(alarmRepositoryProvider).stop();
      final router = ref.read(appRouterProvider);
      router.pop();
    } else {
      print('❌ 先頭 todo とマッチせず (ratio=${ratio.toStringAsFixed(2)})');
    }
  }

  int _longestCommonSubsequenceLength(String s1, String s2) {
    final a = s1.runes.toList();
    final b = s2.runes.toList();
    final n = a.length;
    final m = b.length;
    if (n == 0 || m == 0) return 0;

    List<int> prev = List.filled(m + 1, 0);
    List<int> cur = List.filled(m + 1, 0);

    for (int i = 1; i <= n; i++) {
      for (int j = 1; j <= m; j++) {
        if (a[i - 1] == b[j - 1]) {
          cur[j] = prev[j - 1] + 1;
        } else {
          cur[j] = prev[j] > cur[j - 1] ? prev[j] : cur[j - 1];
        }
      }
      prev = cur;
      cur = List.filled(m + 1, 0);
    }

    return prev[m];
  }
}
