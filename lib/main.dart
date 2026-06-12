import 'package:flutter/material.dart';
import 'package:first_1_1/patient/home_page.dart';



ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.light);

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(

      valueListenable: themeNotifier,

      builder: (
          context,
          ThemeMode currentMode,
          child,
          ) {

        return MaterialApp(

          debugShowCheckedModeBanner: false,


          themeMode: currentMode,

    

          theme: ThemeData(

            brightness: Brightness.light,

            scaffoldBackgroundColor:
            const Color(0xffF5F7FB),

            appBarTheme: const AppBarTheme(

              backgroundColor:
              Color(0xFF0D2F58),

              foregroundColor:
              Colors.white,
            ),
          ),

    

          darkTheme: ThemeData(

            brightness: Brightness.dark,

            scaffoldBackgroundColor:
            const Color(0xFF121212),

            cardColor:
            const Color(0xFF1E1E1E),

            appBarTheme: const AppBarTheme(

              backgroundColor:
              Colors.black,

              foregroundColor:
              Colors.white,
            ),
          ),

          home: const HomePage(),
        );
      },
    );
  }
}

