import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/alarm/alarm_view_model.dart';

class AlarmDisplay extends ConsumerWidget {
  const AlarmDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(alarmViewModelProvider);
    final alarmTimeString = ref
        .watch(alarmViewModelProvider.notifier)
        .alarmTimeString;

    return Padding(
      padding: EdgeInsetsGeometry.only(left: 16, right: 16),
      child: Card(
        elevation: 7,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            ref
                .read(alarmViewModelProvider.notifier)
                .openTimePickerDialog(context);
          },
          child: ListTile(
            title: Center(
              child: Text(
                alarmTimeString,
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
