import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_task_app/features/splash/view/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<SplashCubit>(create: (context) => SplashCubit()),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('ar', ''), // Arabic
            ],
            home: child,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
      child: const SplashScreen(),
    );
  }
}
