import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/data/repositories/speech_to_text_repository.dart';
import 'package:todo_alarm/data/repositories/todo_list_storage_repository.dart';
import 'package:todo_alarm/routing/app_router.dart';
import 'package:todo_alarm/data/services/interfaces/alarm_service.dart';
import 'package:todo_alarm/ui/alarm/alarm_view_model.dart';
import 'package:todo_alarm/ui/setting/settings_viewmodel.dart';
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
          if (status == 'notListening' || status == 'done') {
            state = state.copyWith(isListening: false);
          }

          _stopAlarm();
        },
        onError: (errorMsg) {
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
      state = state.copyWith(isListening: false, errorMessage: 'リスニングエラー: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      final repository = ref.read(speechToTextRepositoryProvider);
      await repository.stopListening();

      state = state.copyWith(isListening: false);
    } catch (e) {
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
    _matchRecognizedTextWithGoals();
    Future.delayed(Duration(seconds: 3), () {
      clearText();
    });
  }

  void _matchRecognizedTextWithGoals() {
    final threshold = ref.read(settingsViewModelProvider).speechSensitivity;

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

    if (ratio >= threshold) {
      final router = ref.read(appRouterProvider);
      if (router.canPop()) {
        router.pop();
      }
      ref
          .read(alarmServiceProvider)
          .stopAndReschedule(ref.read(alarmViewModelProvider));
    }
  }

  Future<void> emergencyStopTap() async {
    final nextCount = state.emergencyTapCount + 1;
    state = state.copyWith(emergencyTapCount: nextCount);

    if (nextCount >= 30) {
      state = state.copyWith(emergencyTapCount: 0);
      await ref
          .read(alarmServiceProvider)
          .stopAndReschedule(ref.read(alarmViewModelProvider));
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
