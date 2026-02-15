import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/generated/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';

class SakaniApp extends ConsumerStatefulWidget {
  const SakaniApp({super.key});

  @override
  ConsumerState<SakaniApp> createState() => _SakaniAppState();
}

class _SakaniAppState extends ConsumerState<SakaniApp> {
  @override
  void initState() {
    super.initState();
    // Check for existing session on app startup
    Future.microtask(
      () => ref.read(authProvider.notifier).checkSession(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';

    return MaterialApp.router(
      routerConfig: router,
      title: isArabic ? 'سكني' : 'Sakani',
      debugShowCheckedModeBanner: false,

      // Localization — use generated delegates
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      // Theme
      theme: AppTheme.light(isArabic: isArabic),
      darkTheme: AppTheme.dark(isArabic: isArabic),
      themeMode: ThemeMode.system,
    );
  }
}

/// Locale provider - defaults to English
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
