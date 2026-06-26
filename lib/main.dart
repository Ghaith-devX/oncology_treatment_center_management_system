import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/routes/app_router.dart';
import 'core/storage/preferences_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controller/auth_controller.dart';

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});

final routerProvider = Provider<GoRouter>((ref) {
  return createRouter(ref);
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = PreferencesService();
  await prefs.init();

  runApp(
    ProviderScope(
      overrides: [preferencesServiceProvider.overrideWithValue(prefs)],
      child: const OncologyCenterApp(),
    ),
  );
}

class OncologyCenterApp extends ConsumerStatefulWidget {
  const OncologyCenterApp({super.key});

  @override
  ConsumerState<OncologyCenterApp> createState() => _OncologyCenterAppState();
}

class _OncologyCenterAppState extends ConsumerState<OncologyCenterApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).tryAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final prefs = ref.watch(preferencesServiceProvider);
    final isDark = prefs.isDarkMode;

    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      if (prev?.status != next.status) {
        router.refresh();
      }
    });

    return MaterialApp.router(
      title: 'نظام إدارة مركز علاج الأورام',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
