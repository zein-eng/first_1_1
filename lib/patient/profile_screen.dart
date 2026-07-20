import 'dart:io';
import 'package:project_11/fullImage_screen.dart';
import 'package:flutter/material.dart';
import 'package:project_11/patient/login_screen.dart';
import 'package:project_11/patient/edit_profile_page.dart';
import 'package:project_11/patient/medical_history_page.dart';
import 'package:project_11/patient/payment_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_11/patient/setting_page.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final dynamic image;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.image,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userName;
  late String userEmail;
  dynamic userImage;

  @override
  void initState() {
    super.initState();
    userName = widget.name;
    userEmail = widget.email;
    userImage = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 30, bottom: 30),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D2F58), Color(0xFF174A8B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),

              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),

                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullImageScreen(image: userImage),
                          ),
                        );
                      },

                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userImage is File
                            ? FileImage(userImage)
                            : NetworkImage(userImage) as ImageProvider,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    userEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  ProfileItem(
                    icon: Icons.edit,
                    title: "Edit Profile",
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            name: userName,
                            email: userEmail,
                            image: userImage,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          userName = result["name"];
                          userEmail = result["email"];
                          userImage = result["image"];
                        });
                      }
                    },
                  ),

                  ProfileItem(
                    icon: Icons.medical_information,
                    title: "Medical History",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MedicalHistoryPage(),
                        ),
                      );
                    },
                  ),

                  ProfileItem(
                    icon: Icons.payments,
                    title: "Payments",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentsPage(),
                        ),
                      );
                    },
                  ),

                  ProfileItem(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),

                  ProfileItem(
                    icon: Icons.support_agent,
                    title: "Contact Developers",
                    onTap: () async {
                      final Uri phoneUri = Uri(
                        scheme: 'tel',
                        path: '0958471390',
                      );

                      await launchUrl(phoneUri);
                    },
                  ),

                  ProfileItem(
                    icon: Icons.logout,
                    title: "Logout",
                    isLogout: true,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
  final VoidCallback? onTap;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,
    this.onTap,
  });

  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,

      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 16),

        transform: Matrix4.identity()..scale(isPressed ? 0.97 : 1.0),

        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),

        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 6,
          ),

          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0D2F58).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              widget.icon,
              color: widget.isLogout ? Colors.red : const Color(0xFF0D2F58),
              size: 20,
            ),
          ),

          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,

              color: widget.isLogout
                  ? Colors.red
                  : (isDark ? Colors.white : Colors.black87),
            ),
          ),

          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: isDark ? Colors.white70 : Colors.grey,
          ),
        ),
      ),
    );
  }
}
