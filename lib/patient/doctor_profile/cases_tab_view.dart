import 'package:flutter/material.dart';

class CasesTabView extends StatefulWidget {
  final List<Map<String, dynamic>> cases;

  const CasesTabView({super.key, required this.cases});

  @override
  State<CasesTabView> createState() => _CasesTabViewState();
}

class _CasesTabViewState extends State<CasesTabView> {
  final Map<int, int> _currentPageIndices = {};

  @override
  Widget build(BuildContext context) {
    const Color accentBlue = Color(0xff1565FF);
    const Color textGrey = Color(0xff8FA0B5);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 95),
      itemCount: widget.cases.length,
      itemBuilder: (context, index) {
        return _buildCaseCard(index, widget.cases[index], textGrey, accentBlue);
      },
    );
  }

  Widget _buildCaseCard(int cardIndex, Map<String, dynamic> item, Color textGrey, Color accentBlue) {
    List<String> images = List<String>.from(item["images"] ?? [item["imagePlaceholder"] ?? ""]);
    int activeImageIndex = _currentPageIndices[cardIndex] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (pageIndex) {
                    setState(() {
                      _currentPageIndices[cardIndex] = pageIndex;
                    });
                  },
                  itemBuilder: (context, imgIndex) {
                    return Container(
                      color: const Color(0xffE2E8F0),
                      child: Image.asset(
                        images[imgIndex],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.image, size: 32, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (images.length > 1)
                Positioned(
                  bottom: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (dotIndex) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: activeImageIndex == dotIndex ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: activeImageIndex == dotIndex ? accentBlue : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["title"], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xff021330))),
                const SizedBox(height: 6),
                Text(item["desc"], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text("Duration: ${item["duration"]}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(width: 14),
                    const Icon(Icons.person_outline_rounded, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text("Age: ${item["age"]}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 10),
                Text("#${item["tag"]}", style: TextStyle(color: accentBlue, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}