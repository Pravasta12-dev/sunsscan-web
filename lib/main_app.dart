import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/theme/app_theme.dart';
import 'package:sun_scan/features/event/bloc/event/event_bloc.dart';
import 'package:sun_scan/features/guest/bloc/guest/guest_bloc.dart';
import 'package:sun_scan/features/splash/pages/splash_page.dart';

import 'features/guest/bloc/bloc/guest_category_bloc.dart';
import 'features/web/bloc/event_web/event_web_bloc.dart';
import 'features/web/bloc/guest_web/guest_web_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EventBloc()..loadEvents()),
        BlocProvider(create: (_) => GuestBloc()),
        BlocProvider(create: (_) => GuestCategoryBloc()),
        BlocProvider(create: (context) => EventWebBloc()),
        BlocProvider(create: (context) => GuestWebBloc()),
      ],
      child: Builder(
        builder: (context) {
          final mediaQuery = MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0));
          return MediaQuery(
            data: mediaQuery,
            child: MaterialApp(
              title: 'SUN SCAN',
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.dark,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              home: const SplashPage(),
            ),
          );
        },
      ),
    );
  }
}
