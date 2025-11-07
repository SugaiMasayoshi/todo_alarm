import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_alarm/repositories/alarm_plugin_repository.dart';
import 'package:todo_alarm/repositories/shared_preferences_repository.dart';
import 'package:todo_alarm/routes/app_router.dart';
import 'package:alarm/utils/alarm_set.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  await Alarm.init();

  final openSpeechOnLaunch = await _shouldOpenSpeechOnLaunch();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MainApp(openSpeechOnLaunch: openSpeechOnLaunch),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key, required this.openSpeechOnLaunch});

  final bool openSpeechOnLaunch;
  static bool _initialNavigationHandled = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AlarmSet>>(alarmRingingStreamProvider, (_, next) {
      next.whenData((event) {
        final router = ref.read(appRouterProvider);
        router.goNamed(RouteName.speech);
      });
    });

    final router = ref.watch(appRouterProvider);

    if (openSpeechOnLaunch && !_initialNavigationHandled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentRouter = ref.read(appRouterProvider);
        currentRouter.goNamed(RouteName.speech);
      });
      _initialNavigationHandled = true;
    }

    return MaterialApp.router(
      title: 'Todo Alarm',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
    );
  }
}

Future<bool> _shouldOpenSpeechOnLaunch() async {
  try {
    return await Alarm.isRinging();
  } catch (_) {
    return false;
  }
}
