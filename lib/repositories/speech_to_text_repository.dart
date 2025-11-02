import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

part '../generated/repositories/speech_to_text_repository.g.dart';

abstract class ISpeechToTextRepository {
  Future<bool> initialize();
  Future<void> startListening({
    required Function(String) onResult,
    String? localeId,
  });
  Future<void> stopListening();
  bool isListening();
  bool isAvailable();
}

@Riverpod(keepAlive: true)
ISpeechToTextRepository speechToTextRepository(Ref ref) {
  return SpeechToTextRepository();
}

class SpeechToTextRepository implements ISpeechToTextRepository {
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  @override
  Future<bool> initialize() async {
    try {
      return await _speechToText.initialize(
        onError: (error) => throw Exception('音声認識エラー: ${error.errorMsg}'),
        onStatus: (status) => print('音声認識ステータス: $status'),
      );
    } catch (e) {
      print('初期化エラー: $e');
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
