import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/speech/speech_view_model.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

class SpeechPage extends ConsumerWidget {
  const SpeechPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speechViewModelProvider);
    final speechViewModel = ref.watch(speechViewModelProvider.notifier);
    speechViewModel.initialize();

    final todo = ref.watch(
      todoListViewModelProvider.select(
        (state) => state.items.isNotEmpty ? state.items[0] : null,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Speech Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '今日やることは「${todo?.title ?? "目標を設定"}」です',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              state.recognizedText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: state.isListening
            ? speechViewModel.stopListening
            : speechViewModel.startListening,
        child: state.isListening ? Icon(Icons.stop) : Icon(Icons.mic),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
