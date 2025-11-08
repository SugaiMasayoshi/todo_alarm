import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/repositories/settings_storage_repository.dart';
import 'package:todo_alarm/ui/setting/settings_viewmodel.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text('設定')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.volume_up),
            title: Text('アラーム音量'),
            subtitle: Slider(
              value: settings.alarmVolume,
              onChanged: (value) {
                ref
                    .read(settingsViewModelProvider.notifier)
                    .setAlarmVolume(value);
              },
            ),
          ),
          Divider(height: 2),
          SwitchListTile.adaptive(
            secondary: Icon(Icons.vibration),
            title: Text('バイブレーション'),
            value: settings.vibrateOnAlarm,
            onChanged: (value) {
              ref
                  .read(settingsViewModelProvider.notifier)
                  .setVibrateOnAlarm(value);
            },
          ),
          Divider(height: 2),
          ListTile(
            leading: Icon(Icons.mic),
            title: Text('音声判定の厳しさ'),
            subtitle: Slider(
              value: settings.speechSensitivity,
              onChanged: (value) {
                ref
                    .read(settingsViewModelProvider.notifier)
                    .setSpeechSensitivity(value);
              },
            ),
          ),
          Divider(height: 2),
          ListTile(
            title: Text('ライセンス情報'),
            leading: Icon(Icons.info),
            onTap: () => showLicensePage(
              context: context,
              applicationIcon: SizedBox(
                width: 128,
                height: 128,
                child: Image.asset('assets/launcher_icon/icon_adaptive.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
