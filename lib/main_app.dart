import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/app_bootstrap.dart';
import 'package:sun_scan/core/theme/app_theme.dart';
import 'package:sun_scan/features/event/bloc/event/event_bloc.dart';
import 'package:sun_scan/features/guest/bloc/guest/guest_bloc.dart';
import 'package:sun_scan/features/splash/pages/splash_page.dart';

import 'features/guest/bloc/greeting/greeting_bloc.dart';
import 'features/guest/bloc/guest_category/guest_category_bloc.dart';
import 'features/guest/bloc/guest_session/guest_session_bloc.dart';
import 'features/guest/bloc/guest_tab/guest_tab_cubit.dart';
import 'features/guest/bloc/souvenir/souvenir_bloc.dart';
import 'features/web/bloc/event_web/event_web_bloc.dart';
import 'features/web/bloc/guest_web/guest_web_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppBootstrap.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      AppBootstrap.dispose();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EventBloc()..loadEvents()),
        BlocProvider(create: (_) => GuestBloc()),
        BlocProvider(create: (_) => GuestSessionBloc()),
        BlocProvider(create: (_) => GuestCategoryBloc()),
        BlocProvider(create: (_) => EventWebBloc()),
        BlocProvider(create: (_) => GuestTabCubit()),
        BlocProvider(create: (_) => GuestWebBloc()),
        BlocProvider(create: (_) => SouvenirBloc()),
        BlocProvider(create: (_) => GreetingBloc()),
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
