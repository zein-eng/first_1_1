import 'dart:async';
import 'package:flutter/material.dart';
import 'package:first_1_1/patient/diagnostic_appointment.dart';
import 'package:first_1_1/patient/doctor_profile/doctor_profile_screen.dart';
import 'package:first_1_1/patient/profile_screen.dart';
import 'package:first_1_1/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _appointmentTitle = "Teeth Cleaning";
  final String _appointmentDate = "15 May 2024";
  final String _appointmentTime = "09:00 AM";
  final int _rewardPoints = 120;
  final double _treatmentProgress = 0.75;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _diagnosticImages = [
    'assets/dental_chair_bg.png',
    'assets/diagnostic2.png',
    'assets/diagnostic3.png',
    'assets/diagnostic4.png',
  ];

  late PageController _pageController;
  int _bannerCurrentIndex = 0;
  Timer? _bannerTimer;

  final List<Map<String, dynamic>> _doctors = [
    {
      "name": "Dr. Ahmad Al-Khatib",
      "specialty": "Orthodontist",
      "experience": "8+ Years Experience",
      "desc": "Specialist in braces and teeth alignment",
      "image": "assets/doctor1.png",
      "phone": "+963911111111",
    },
    {
      "name": "Dr. Sarah Nassar",
      "specialty": "General Dentist",
      "experience": "6+ Years Experience",
      "desc": "Preventive care, fillings and oral health",
      "image": "assets/doctor2.png",
      "phone": "+963922222222",
    },
    {
      "name": "Dr. Rami Haddad",
      "specialty": "Oral Surgeon",
      "experience": "10+ Years Experience",
      "desc": "Wisdom teeth, implants and oral surgery",
      "image": "assets/doctor3.png",
      "phone": "+963933333333",
    },
  ];

  int _currentIndex = 0;

  String _userName = "Guest";
  String _userEmail = "";
  dynamic _userImage = "assets/profile.png";

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadUserProfile();

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerCurrentIndex < _diagnosticImages.length - 1) {
        _bannerCurrentIndex++;
      } else {
        _bannerCurrentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _bannerCurrentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadUserProfile() async {
    final profileData = await Constants.getProfile();
    if (profileData != null && mounted) {
      final data = profileData['data'] ?? profileData;

      final firstName = data['first_name']?.toString().trim() ?? '';
      final lastName = data['last_name']?.toString().trim() ?? '';
      final combinedName = [
        firstName,
        lastName,
      ].where((s) => s.isNotEmpty).join(' ');

      setState(() {
        if (data['name'] != null &&
            data['name'].toString().trim().isNotEmpty) {
          _userName = data['name'];
        } else if (combinedName.isNotEmpty) {
          _userName = combinedName;
        }

        _userEmail = data['email'] ?? _userEmail;
        _userImage = data['image'] ??
            data['photo'] ??
            data['avatar'] ??
            data['profile_image'] ??
            _userImage;
      });
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkNavy = Color(0xff051937);
    const Color cardBlue = Color(0xff0D2F58);
    const Color accentBlue = Color(0xff1565FF);

    return Scaffold(
       key: _scaffoldKey,
      backgroundColor: const Color(0xffFAFAFA),
      endDrawer: ProfileScreen(
  name: _userName,
  email: _userEmail,
  image: _userImage,
),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: AppBar(
          backgroundColor: darkNavy,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () {},
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    children: [
                      TextSpan(
                        text: "Denta",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: "Print",
                        style: TextStyle(color: accentBlue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "DENTAL CENTER",
                  style: TextStyle(
                    color: Colors.white54,
                    letterSpacing: 3,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          actions: [
  Padding(
    padding: const EdgeInsets.only(right: 16.0, top: 16.0),
    child: GestureDetector(
      onTap: () {
        _scaffoldKey.currentState!.openEndDrawer();
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white24,
            child: ClipOval(
              child: Image.asset(
                'assets/profile.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
          const CircleAvatar(
            radius: 5.5,
            backgroundColor: Colors.green,
          ),
        ],
      ),
    ),
  ),
],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildUpcomingAppointment(cardBlue, accentBlue),
                  const SizedBox(height: 16),
                  _buildBookingBanner(cardBlue),
                  const SizedBox(height: 16),
                  _buildStatusRow(cardBlue, accentBlue),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Our Doctors",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkNavy,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            color: accentBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _doctors.length,
                    itemBuilder: (context, index) {
                      return _buildDoctorCard(
                        _doctors[index],
                        accentBlue,
                        darkNavy,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
         onTap: (index) {
  if (index == 3) {
    _scaffoldKey.currentState!.openEndDrawer();
  } else {
    setState(() {
      _currentIndex = index;
    });
  }
},
          type: BottomNavigationBarType.fixed,
          backgroundColor: darkNavy,
          selectedItemColor: accentBlue,
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Appointments",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.biotech_outlined),
              label: "Treatment",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointment(Color bgColor, Color accentColor) {
    const Color imgDarkNavy = Color.fromARGB(255, 2, 28, 73);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: imgDarkNavy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 8, 38, 81),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Upcoming Appointment",
                  style: TextStyle(
                    color: const Color(0xff1565FF).withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _appointmentTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white70,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _appointmentDate,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "•",
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.access_time,
                      color: Colors.white70,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _appointmentTime,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(
                255,
                15,
                49,
                100,
              ).withValues(alpha: 0.8),
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color.fromARGB(255, 15, 99, 255),
              size: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingBanner(Color bgColor) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _diagnosticImages.length,
                onPageChanged: (index) {
                  setState(() {
                    _bannerCurrentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    _diagnosticImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    bgColor.withValues(alpha: 0.5),
                    bgColor.withValues(alpha: 0.95),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Spacer(flex: 1),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Book a Diagnostic Session",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Get a complete oral check-up by our experts.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.only(right: 60),
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DiagnosticBookingScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color.fromARGB(
                                255,
                                2,
                                28,
                                73,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Book Now",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios_rounded, size: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 14,
            right: 20,
            child: Row(
              children: List.generate(
                _diagnosticImages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(left: 4),
                  height: 4,
                  width: _bannerCurrentIndex == index ? 14 : 4,
                  decoration: BoxDecoration(
                    color: _bannerCurrentIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(Color bgColor, Color accentColor) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            height: 95,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 28, 73),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.card_giftcard_rounded,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Reward Points",
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "$_rewardPoints",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Points Available",
                        style: TextStyle(color: Colors.white70, fontSize: 9),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            height: 95,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 28, 73),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        value: _treatmentProgress,
                        strokeWidth: 4,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                      ),
                    ),
                    Text(
                      "${(_treatmentProgress * 100).toInt()}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Progress",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Keep going! Doing great.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(
    Map<String, dynamic> doctor,
    Color accentColor,
    Color darkNavy,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffF1F3F6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorProfileScreen(doctorData: doctor),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 85,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xffE9EFF8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    doctor["image"],
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Icon(Icons.person, color: darkNavy, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor["name"],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkNavy,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor["specialty"],
                      style: TextStyle(
                        fontSize: 12,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          doctor["experience"],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor["desc"],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xffF4F7FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: darkNavy,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}