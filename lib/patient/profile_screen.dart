import 'dart:io';
import 'dart:typed_data';
import 'package:first_1_1/fullImage_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_1_1/constants.dart';
import 'package:first_1_1/patient/login_screen.dart';
import 'package:first_1_1/patient/edit_profile_page.dart';
import 'package:first_1_1/patient/medical_history_page.dart';
import 'package:first_1_1/patient/payment_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:first_1_1/patient/setting_page.dart';

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
  bool isLoggingOut = false;
  bool isLoadingData = true;

  @override
  void initState() {
    super.initState();
    userName = widget.name;
    userEmail = widget.email;
    userImage = widget.image;

   
    _loadProfileData();
  }
  Future<void> _loadProfileData() async {
    final profileData = await Constants.getProfile();

    if (profileData != null && mounted) {
      setState(() {
        final data = profileData['data'] ?? profileData;

        // الاسم: جرب الحقل 'name' مباشرة، وإلا ركّب first_name + last_name
        final firstName = data['first_name']?.toString().trim() ?? '';
        final lastName = data['last_name']?.toString().trim() ?? '';
        final combinedName = [
          firstName,
          lastName,
        ].where((s) => s.isNotEmpty).join(' ');

        if (data['name'] != null &&
            data['name'].toString().trim().isNotEmpty) {
          userName = data['name'];
        } else if (combinedName.isNotEmpty) {
          userName = combinedName;
        }

        userEmail = data['email'] ?? userEmail;

        // الصورة: جرب أكثر من اسم محتمل للحقل
        userImage = data['image'] ??
            data['photo'] ??
            data['avatar'] ??
            data['profile_image'] ??
            userImage;

        isLoadingData = false;
      });
    } else if (mounted) {
      setState(() {
        isLoadingData = false;
      });
    }
  }
  ImageProvider _buildImageProvider(dynamic image) {
    if (image is Uint8List) {
      return MemoryImage(image);
    } else if (image is File) {
      return FileImage(image);
    } else if (image is String && (image.startsWith('http://') || image.startsWith('https://'))) {
      return NetworkImage(image);
    } else if (image is String && image.isNotEmpty) {
      return AssetImage(image);
    }
    return const AssetImage('assets/profile.png');
  }

  Future<void> _handleLogout() async {
    setState(() => isLoggingOut = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await Constants.logout();
    } catch (e) {
      debugPrint("Logout error: $e");
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }

      if (mounted) {
        setState(() => isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // طول ما البيانات لسا عم تنحمل من الباك اند، منعرض دائرة تحميل
    // بنص الشاشة بس، وما منبني باقي محتوى الدرج إطلاقاً
    if (isLoadingData) {
      return Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0D2F58),
          ),
        ),
      );
    }

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0D2F58),
                    Color(0xFF174A8B),
                  ],
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
                        backgroundImage: _buildImageProvider(userImage),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
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
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
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
                    onTap: isLoggingOut ? null : _handleLogout,
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
              color: widget.isLogout
                  ? Colors.red
                  : const Color(0xFF0D2F58),
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