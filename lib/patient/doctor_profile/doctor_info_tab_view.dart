import 'package:flutter/material.dart';

class DoctorInfoTabView extends StatelessWidget {
  final Map<String, dynamic> doctorData;

  const DoctorInfoTabView({super.key, required this.doctorData});

  @override
  Widget build(BuildContext context) {

    final List<dynamic> educationData = doctorData["education"] ?? [
      {"type": "school", "title": "BDS - Cairo University", "subtitle": "Faculty of Dentistry"},
      {"type": "premium", "title": "MSc in Orthodontics", "subtitle": "Ain Shams University"},
      {"type": "verified", "title": "Board Certified Orthodontist", "subtitle": "Egyptian Orthodontic Society"},
      {"type": "safety", "title": "Invisalign® Certified Provider", "subtitle": "Align Technology"}
    ];

    final List<dynamic> expertiseData = doctorData["expertise"] ?? [
      "Orthodontics", "Clear Aligners", "Braces", "Smile Design", "Teeth Whitening", "Cosmetic Dentistry"
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Section
          Text(
            "About ${doctorData["name"] ?? "Dr. Ahmed El-Said"}",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xff021330)),
          ),
          const SizedBox(height: 10),
          Text(
            doctorData["bio"] ?? "Dr. Ahmed El-Said is a board certified orthodontist with over 12 years of experience...",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),

          // Education Section
          const Text(
            "Education & Certifications",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xff021330)),
          ),
          const SizedBox(height: 16),
          ...educationData.map((item) {
            return _buildInfoItem(
              item["type"] ?? "default",
              item["title"] ?? "",
              item["subtitle"] ?? "",
            );
          }),
          const SizedBox(height: 24),

          // Expertise Section
          const Text(
            "Areas of Expertise",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xff021330)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: expertiseData.map((label) => _buildExpertiseChip(label.toString())).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String iconName, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_getIconFromString(iconName), color: const Color(0xff1565FF), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff021330))),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'school': return Icons.school_outlined;
      case 'premium': return Icons.workspace_premium_outlined;
      case 'verified': return Icons.verified_outlined;
      case 'safety': return Icons.health_and_safety_outlined;
      default: return Icons.info_outline_rounded;
    }
  }

  Widget _buildExpertiseChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xff475569), fontWeight: FontWeight.w500)),
    );
  }
}