import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlarmDisplay extends ConsumerWidget {
  const AlarmDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 16, right: 16),
      child: Card(
        elevation: 7,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            showTimePicker(context: context, initialTime: TimeOfDay.now());
          },
          child: ListTile(
            title: Center(
              child: Text(
                '6:30',
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
