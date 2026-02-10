import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

part '../../generated/data/repositories/speech_to_text_repository.g.dart';

abstract class ISpeechToTextRepository {
  Future<bool> initialize({
    Function(String)? onStatus,
    Function(String)? onError,
  });
  Future<void> startListening({
    required Function(String) onResult,
    String? localeId,
  });
  Future<void> stopListening();
  bool isListening();
  bool isAvailable();
}

@riverpod
ISpeechToTextRepository speechToTextRepository(Ref ref) {
  final stt.SpeechToText speechToText = stt.SpeechToText();
  final repository = SpeechToTextRepository(speechToText);

  return repository;
}

class SpeechToTextRepository implements ISpeechToTextRepository {
  final stt.SpeechToText _speechToText;

  SpeechToTextRepository(this._speechToText);

  @override
  Future<bool> initialize({
    Function(String)? onStatus,
    Function(String)? onError,
  }) async {
    try {
      return await _speechToText.initialize(
        onStatus: (status) {
          if (kDebugMode) {
            print('音声認識ステータス: $status');
          }
          onStatus?.call(status);
        },
        onError: (error) {
          if (kDebugMode) {
            print('音声認識エラー: ${error.errorMsg}');
          }
          onError?.call(error.errorMsg);
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('初期化エラー: $e');
      }
      return false;
    }
  }

  @override
  Future<void> startListening({
    required Function(String) onResult,
    String? localeId,
  }) async {
    if (!_speechToText.isAvailable) {
      throw Exception('音声認識が利用できません。先に initialize() を呼んでください。');
    }

    await _speechToText.listen(
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          onResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      localeId: localeId ?? 'ja_JP',
    );
  }

  @override
  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  @override
  bool isListening() {
    return _speechToText.isListening;
  }

  @override
  bool isAvailable() {
    return _speechToText.isAvailable;
  }
}
