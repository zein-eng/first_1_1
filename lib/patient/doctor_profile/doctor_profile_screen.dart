import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cases_tab_view.dart';
import 'doctor_info_tab_view.dart';
import 'booking_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorProfileScreen({super.key, required this.doctorData});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int _selectedTab = 0;
  double _currentDoctorRating = 4.8;
  bool _isSubmittingRating = false;

  final List<Map<String, dynamic>> cases = [
    {
      "id": "#1257",
      "title": "Clear Aligner Transformation",
      "desc": "Full upper & lower alignment.",
      "duration": "10 Months",
      "age": "24",
      "tag": "ClearAligners",
      "images": ["assets/before1.png", "assets/after1.png"],
    },
    {
      "id": "#1256",
      "title": "Gap Closure & Smile Design",
      "desc": "Closing front gaps and reshaping.",
      "duration": "6 Months",
      "age": "28",
      "tag": "CosmeticDentistry",
      "images": ["assets/before2.png", "assets/after2.png"],
    },
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not launch phone dialer"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitRating(double rating) async {
    setState(() => _isSubmittingRating = true);

    dynamic doctorId = widget.doctorData["id"] ?? "no_id_provided";

    Map<String, dynamic> ratingPayload = {
      "doctor_id": doctorId,
      "rating": rating,
    };

    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() {
      _isSubmittingRating = false;
      _currentDoctorRating = rating; 
    });

    if (mounted) {
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⭐ Thank you! Your rating has been submitted."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showRatingBottomSheet() {
    double selectedStars = 5.0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 24),
                  const Text("Rate the Doctor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff051534))),
                  const SizedBox(height: 6),
                  Text("Tap a star to rate ${widget.doctorData["name"] ?? "the doctor"}", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedStars ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 42,
                        ),
                        onPressed: _isSubmittingRating ? null : () {
                          setModalState(() => selectedStars = index + 1.0);
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: _isSubmittingRating ? null : () async {
                      setModalState(() => _isSubmittingRating = true);
                      await _submitRating(selectedStars);
                      setModalState(() => _isSubmittingRating = false);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xff051534),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: _isSubmittingRating
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Submit Rating", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgNavy = Color.fromARGB(255, 5, 21, 52);
    const Color cardNavy = Color.fromARGB(255, 12, 41, 82);
    const Color accentBlue = Color(0xff1565FF);

    return Scaffold(
      backgroundColor: bgNavy,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 355,
                    pinned: false,
                    floating: true,
                    backgroundColor: bgNavy,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.only(top: 55.0, left: 16, right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImagePreviewScreen(
                                      imagePath: widget.doctorData["image"] ?? "",
                                      heroTag: "doctorAvatar",
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: "doctorAvatar",
                                child: CircleAvatar(
                                  radius: 75,
                                  backgroundColor: cardNavy,
                                  backgroundImage: AssetImage(widget.doctorData["image"] ?? ""),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.doctorData["name"] ?? "Dr. Ahmed El-Said",
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (widget.doctorData["specialty"] ?? "Orthodontist").toUpperCase(),
                              style: const TextStyle(color: accentBlue, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: _showRatingBottomSheet,
                                  splashColor: Colors.white10,
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildStatItem(
                                          Icons.star_rounded,
                                          _currentDoctorRating.toString(),
                                          "Rating",
                                          Colors.amber,
                                        ),
                                        Text(
                                          "Rate Now",
                                          style: TextStyle(
                                            color: accentBlue,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                            decorationColor: accentBlue.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _makePhoneCall(widget.doctorData["phone"] ?? "0939849884"),
                                  splashColor: Colors.white10,
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildStatItem(
                                          Icons.phone_in_talk_rounded,
                                          "Call",
                                          "Contact",
                                          accentBlue,
                                        ),
                                        Text(
                                          "Tap to Call",
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  child: _buildStatItem(
                                    Icons.verified_user_rounded,
                                    widget.doctorData["experience"] != null
                                        ? "${widget.doctorData["experience"].toString().split(' ')[0]} YRS"
                                        : "12 YRS",
                                    "Experience",
                                    Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTabButton(Icons.image_outlined, "Cases", 0),
                          _buildTabButton(Icons.person_outline_rounded, "about Doctor", 1),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _selectedTab == 0
                          ? CasesTabView(cases: cases)
                          : DoctorInfoTabView(doctorData: widget.doctorData),
                    ),
                  ],
                ),
              ),
            ),
            _buildBookingButton(bgNavy, cardNavy, accentBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(IconData icon, String title, int index) {
    bool isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: isActive ? const Color(0xff021330) : Colors.grey, size: 19),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? const Color(0xff021330) : Colors.grey,
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: 110,
            height: 2.5,
            color: isActive ? const Color(0xff1565FF) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 26),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 1),
        Text(label, style: const TextStyle(color: Color(0xff8FA0B5), fontSize: 11)),
      ],
    );
  }

  Widget _buildBookingButton(Color bgNavy, Color cardNavy, Color accentBlue) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingScreen(doctorData: widget.doctorData),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: bgNavy, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: cardNavy, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Book Appointment", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text("Choose your preferred date & time", style: TextStyle(color: Colors.white54, fontSize: 10)),
                    ],
                  ),
                ),
                Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: accentBlue),
                  child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  final String heroTag;

  const ImagePreviewScreen({super.key, required this.imagePath, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            clipBehavior: Clip.none,
            maxScale: 4.0,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person_rounded, size: 100, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}