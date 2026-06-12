import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {
  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0D2F58),

        centerTitle: true,

        title: const Text("Language"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              "Choose Application Language",

              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,

                color: isDark
                    ? Colors.white
                    : const Color(
                        0xFF0D2F58,
                      ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Select your preferred language",

              style: TextStyle(
                fontSize: 15,

                color: isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),

            const SizedBox(height: 30),

            /// ================= LANGUAGE CARD =================
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color:
                    Theme.of(context).cardColor,

                borderRadius:
                    BorderRadius.circular(22),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),

              child:
                  DropdownButtonFormField<
                      String>(
                value: selectedLanguage,

                decoration:
                    const InputDecoration(
                  border: InputBorder.none,

                  prefixIcon: Icon(
                    Icons.language,
                    color:
                        Color(0xFF0D2F58),
                  ),
                ),

                dropdownColor:
                    Theme.of(context)
                        .cardColor,

                style: TextStyle(
                  fontSize: 18,

                  color: isDark
                      ? Colors.white
                      : Colors.black87,
                ),

                items: const [
                  DropdownMenuItem(
                    value: "English",

                    child: Text(
                      "English",
                    ),
                  ),

                  DropdownMenuItem(
                    value: "Arabic",

                    child: Text(
                      "Arabic",
                    ),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedLanguage =
                        value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}