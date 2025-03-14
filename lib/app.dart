import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syscost/common/constants/routes.dart';
import 'package:syscost/common/themes/default_theme.dart';
import 'package:syscost/features/cut/cut_page.dart';
import 'package:syscost/features/home/home_page.dart';
import 'package:syscost/features/login/login_page.dart';
import 'package:syscost/features/person/person_page.dart';
import 'package:syscost/features/title/title_page.dart';
import 'package:syscost/features/user/user_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale("pt", "BR"),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("pt", "BR"),
      ],
      theme: defaultTheme,
      initialRoute: NamedRoute.loginPage,
      routes: {
        NamedRoute.loginPage: (context) => const LoginPage(),
        NamedRoute.homePage: (context) => const HomePage(),
        NamedRoute.userPage: (context) => const UserPage(),
        NamedRoute.personPage: (context) => const PersonPage(),
        NamedRoute.cutPage: (context) => const CutPage(),
        NamedRoute.titlePage: (context) => const TitlePage(),
      },
    );
  }
}
