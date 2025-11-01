import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/speech/speech_view_model.dart';

class SpeechPage extends ConsumerWidget {
  const SpeechPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speechViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Speech Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Recognized Speech:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              state.recognizedText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ref.read(speechViewModelProvider.notifier).startListening();
              },
              child: Text('Start Listening'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(speechViewModelProvider.notifier).stopListening();
              },
              child: Text('Stop Listening'),
            ),
          ],
        ),
      ),
    );
  }
}
