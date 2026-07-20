import 'package:flutter/material.dart';
import 'package:teeth_selector/teeth_selector.dart';

class DentalChartScreen extends StatefulWidget {
  const DentalChartScreen({super.key});
  @override
  State<DentalChartScreen> createState() => _DentalChartScreenState();
}

class _DentalChartScreenState extends State<DentalChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  Key selectorKey = UniqueKey();
  String? selectedTooth;

  String patientName = "John Doe";
  String patientID = "P-10293";
  String patientImage = "https://cdn-icons-png.flaticon.com/512/149/149071.png";

  List<Map<String, dynamic>> treatmentPlan = [
    {"title": "Initial Examination", "done": false},
    {"title": "Cleaning & Scaling", "done": false},
    {"title": "Cavity Filling", "done": false},
    {"title": "Root Canal Treatment", "done": false},
    {"title": "Crown Placement", "done": false},
  ];

  double getTreatmentProgress() {
    int done = treatmentPlan.where((t) => t["done"] == true).length;
    return done / treatmentPlan.length;
  }

  Map<String, String> toothStatus = {};
  Map<String, String> toothNotes = {};
  Map<String, String> toothIDs = {};

  final Map<String, Color> statusColors = {
    "Healthy": Colors.green,
    "Caries": Colors.red,
    "Filled": Colors.blue,
    "Missing": Colors.grey,
    "Root Canal": Colors.orange,
  };

  BoxDecoration get card => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() => setState(() {}));
  }

  // ---------------- PATIENT CARD ----------------
  Widget buildPatientHeader() {
    return Container(
      decoration: card,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(radius: 38, backgroundImage: NetworkImage(patientImage)),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        patientName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A86FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Patient",
                        style: TextStyle(
                          color: Color(0xFF3A86FF),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.badge, size: 18, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(
                      "ID: $patientID",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.cake, size: 18, color: Colors.black45),
                    SizedBox(width: 6),
                    Text(
                      "Age: 32",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.phone, size: 18, color: Colors.black45),
                    SizedBox(width: 6),
                    Text(
                      "+1 555 123 4567",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- QUICK INFO ----------------
  Widget buildToothQuickInfo() {
    if (selectedTooth == null) return const SizedBox.shrink();

    final status = toothStatus[selectedTooth] ?? "Healthy";
    final notes = toothNotes[selectedTooth] ?? "No notes added";

    return Container(
      decoration: card,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tooth $selectedTooth",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColors[status]!.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColors[status],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notes,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF3A86FF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => editToothStatus(context, selectedTooth!),
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Color(0xFF3A86FF)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A86FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => viewToothInfo(context, selectedTooth!),
                  child: const Text("View Info"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- TOOTH CHART ----------------
  Widget buildToothChart() {
    final Map<String, Color> colorized = {
      for (var e in toothStatus.entries) e.key: statusColors[e.value]!,
    };

    return Container(
      decoration: card,
      padding: const EdgeInsets.all(28),
      child: TeethSelector(
        key: selectorKey,
        unselectedColor: Colors.black,
        onChange: (selected) {
          if (selected.isNotEmpty) {
            setState(() => selectedTooth = selected.first.toString());
          }
        },
        multiSelect: false,
        colorized: colorized,
        StrokedColorized: const {},
        notation: (iso) => "Tooth ISO: $iso",
        selectedColor: Colors.red,
        showPrimary: false,
      ),
    );
  }

  // ---------------- LEGEND ----------------
  Widget buildToothLegend() {
    return Container(
      decoration: card,
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 12,
        children: [
          _legend("Healthy", Colors.green),
          _legend("Caries", Colors.red),
          _legend("Filled", Colors.blue),
          _legend("Missing", Colors.grey),
          _legend("Root Canal", Colors.orange),
        ],
      ),
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 7, backgroundColor: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 15)),
      ],
    );
  }

  // ---------------- TREATMENT PLAN TAB ----------------
  Widget buildTreatmentPlanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildPatientHeader(),
          const SizedBox(height: 20),
          Container(
            decoration: card,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Treatment Plan",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: getTreatmentProgress()),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey.shade300,
                        color: const Color(0xFF3A86FF),
                        minHeight: 12,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: treatmentPlan.length,
                  itemBuilder: (context, i) {
                    return CheckboxListTile(
                      value: treatmentPlan[i]["done"],
                      title: Text(
                        treatmentPlan[i]["title"],
                        style: const TextStyle(fontSize: 18),
                      ),
                      activeColor: const Color(0xFF3A86FF),
                      onChanged: (v) {
                        setState(() => treatmentPlan[i]["done"] = v);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- EDIT TOOTH ----------------
  void editToothStatus(BuildContext context, String iso) {
    String selectedStatus = toothStatus[iso] ?? "Healthy";
    TextEditingController noteCtrl = TextEditingController(
      text: toothNotes[iso] ?? "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(Icons.edit, color: Color(0xFF3A86FF), size: 26),
                  SizedBox(width: 10),
                  Text(
                    "Edit Tooth",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: noteCtrl,
                decoration: InputDecoration(
                  labelText: "Notes",
                  prefixIcon: const Icon(
                    Icons.note_alt,
                    color: Color(0xFF3A86FF),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: statusColors.keys.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: statusColors[s], size: 14),
                        const SizedBox(width: 10),
                        Text(s),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (v) => selectedStatus = v!,
                decoration: InputDecoration(
                  labelText: "Status",
                  prefixIcon: const Icon(
                    Icons.health_and_safety,
                    color: Color(0xFF3A86FF),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.close, color: Colors.redAccent),
                          SizedBox(width: 6),
                          Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A86FF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          toothStatus[iso] = selectedStatus;
                          toothNotes[iso] = noteCtrl.text;
                          toothIDs[iso] = iso;
                          selectorKey = UniqueKey();
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.save, color: Colors.white),
                          SizedBox(width: 6),
                          Text("Save"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- VIEW TOOTH ----------------
  void viewToothInfo(BuildContext context, String iso) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tooth Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _info(
                Icons.health_and_safety,
                "Status",
                toothStatus[iso] ?? "No status available",
              ),
              const SizedBox(height: 20),
              _info(
                Icons.note_alt,
                "Notes",
                toothNotes[iso] ?? "No notes added",
              ),
              const SizedBox(height: 20),
              _info(Icons.tag, "Tooth ID", toothIDs[iso] ?? "Not set"),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A86FF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _info(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF3A86FF)),
        const SizedBox(width: 10),
        Text(
          "$title:",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  // ---------------- MAIN UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A86FF),
        elevation: 4,
        centerTitle: true,
        title: const Text(
          "Dental Chart",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          // ⭐ FLOATING TAB BAR UNDER APPBAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF3A86FF),
                  borderRadius: BorderRadius.circular(30),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent, // ⭐ removes underline
                dividerColor: Colors.transparent, // ⭐ removes divider line
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(
                    icon: Icon(
                      tabController.index == 0
                          ? Icons.medical_services
                          : Icons.medical_services_outlined,
                    ),
                    text: "Dental Chart",
                  ),
                  Tab(
                    icon: Icon(
                      tabController.index == 1
                          ? Icons.assignment
                          : Icons.assignment_outlined,
                    ),
                    text: "Treatment Plan",
                  ),
                ],
              ),
            ),
          ),

          // ⭐ TAB CONTENT
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      buildPatientHeader(),
                      const SizedBox(height: 20),
                      buildToothChart(),
                      const SizedBox(height: 20),
                      buildToothQuickInfo(),
                      const SizedBox(height: 20),
                      buildToothLegend(),
                    ],
                  ),
                ),
                buildTreatmentPlanTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
