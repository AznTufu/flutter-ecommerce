import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';
import 'presentation/router/app_router.dart';
import 'presentation/providers/biometric_provider.dart';
import 'presentation/widgets/biometric_lock_screen.dart';
import 'core/utils/platform_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final biometricState = ref.watch(biometricProvider);
    if (PlatformHelper.isMobile && 
        biometricState.isAvailable && 
        !biometricState.isAuthenticated &&
        !biometricState.isLoading) {
      return MaterialApp(
        title: 'KeyboardShop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6200EA),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: BiometricLockScreen(
          onAuthenticated: () {
            ref.read(biometricProvider.notifier).skip();
          },
          onSkip: () {
            ref.read(biometricProvider.notifier).skip();
          },
        ),
      );
    }

    return MaterialApp.router(
      title: 'KeyboardShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EA),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
