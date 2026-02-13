import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotufy/core/providers/current_user_notifier.dart';
import 'package:spotufy/core/theme/theme.dart';
import 'package:spotufy/features/auth/view/pages/signup_page.dart';
import 'package:spotufy/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:spotufy/features/home/view/pages/home_page.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path; 
  final container = ProviderContainer();
  await container.read(authViewmodelProvider.notifier).initSharedPreference();
  final usermodel = await container.read(authViewmodelProvider.notifier).getData();
  print(usermodel);
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignupPage() : const HomePage(),
    );
  }
}
