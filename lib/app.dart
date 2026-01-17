import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_jury/core/router/app_router.dart';

import 'core/env/env.dart';
import 'core/theme/theme.dart';

class FoodJuryApp extends ConsumerWidget {
  const FoodJuryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: Env.appName,
      debugShowCheckedModeBanner: Env.isDev,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
