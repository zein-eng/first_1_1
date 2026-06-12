import 'package:flutter/material.dart';
import 'package:first_1_1/patient/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,

      // ✅ بدل اللون الثابت
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      endDrawer: ProfileScreen(
        name: "Alabdeen",
        email: "alabdeen@gmail.com",
        image: "https://i.pravatar.cc/300",
      ),

      body: SafeArea(
        child: Column(
          children: [

            // ================= TOP BAR =================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // العنوان
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,

                      // ✅ بدل اللون الثابت
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF0D2F58),
                    ),
                  ),

                  // زر القائمة
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black54
                          : Colors.white,

                      borderRadius: BorderRadius.circular(15),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 30,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF0D2F58),
                      ),

                      onPressed: () {
                        _scaffoldKey.currentState!
                            .openEndDrawer();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ================= CONTENT =================
            Expanded(
              child: Center(
                child: Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,

                    color: isDark
                        ? Colors.white
                        : const Color(0xFF0D2F58),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}