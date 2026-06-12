import 'package:flutter/material.dart';

class MedicalHistoryPage extends StatefulWidget {
  const MedicalHistoryPage({super.key});

  @override
  State<MedicalHistoryPage> createState() =>
      _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController allergyController = TextEditingController();
  final TextEditingController diseasesController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();
  final TextEditingController doctorEmailController = TextEditingController();

  bool isLoading = false;
  bool isSaved = false;
  bool isEditing = true;

  static String savedAllergy = "";
  static String savedDiseases = "";
  static String savedMedications = "";
  static String savedDoctorEmail = "";

  @override
  void initState() {
    super.initState();

    allergyController.text = savedAllergy;
    diseasesController.text = savedDiseases;
    medicationsController.text = savedMedications;
    doctorEmailController.text = savedDoctorEmail;

    if (savedAllergy.isNotEmpty ||
        savedDiseases.isNotEmpty ||
        savedMedications.isNotEmpty) {
      isSaved = true;
      isEditing = false;
    }
  }

  Future<void> saveMedicalHistory() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      await Future.delayed(const Duration(seconds: 1));

      savedAllergy = allergyController.text;
      savedDiseases = diseasesController.text;
      savedMedications = medicationsController.text;
      savedDoctorEmail = doctorEmailController.text;

      setState(() {
        isLoading = false;
        isSaved = true;
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Medical History Saved"),
          backgroundColor: Color(0xFF0D2F58),
        ),
      );
    }
  }

  Widget buildInfoTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D2F58).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: const Color(0xFF0D2F58)),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D2F58),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  value.isEmpty ? "Not Provided" : value,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration customField(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF0D2F58)),
      filled: true,

      fillColor: Theme.of(context).cardColor,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2F58),
        centerTitle: true,
        title: const Text("Medical History"),

        actions: [
          if (isSaved && !isEditing)
            IconButton(
              onPressed: () => setState(() => isEditing = true),
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: isSaved && !isEditing
            ? Column(
                children: [
                  buildInfoTile(
                    title: "Allergies",
                    value: savedAllergy,
                    icon: Icons.warning_amber,
                  ),

                  buildInfoTile(
                    title: "Chronic Diseases",
                    value: savedDiseases,
                    icon: Icons.health_and_safety,
                  ),

                  buildInfoTile(
                    title: "Current Medications",
                    value: savedMedications,
                    icon: Icons.medication,
                  ),
                ],
              )
            : Form(
                key: formKey,

                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),

                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(25),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.medical_information,
                                color: Color(0xFF0D2F58),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Medical Information",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D2F58),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          TextFormField(
                            controller: allergyController,
                            maxLines: 2,
                            decoration: customField(
                              "Penicillin, Latex...",
                              Icons.warning_amber,
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller: diseasesController,
                            maxLines: 2,
                            decoration: customField(
                              "Diabetes, Heart Disease...",
                              Icons.health_and_safety,
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller: medicationsController,
                            maxLines: 3,
                            decoration: customField(
                              "Write medications here...",
                              Icons.medication,
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller: doctorEmailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Doctor email required";
                              }
                              if (!value.contains("@")) {
                                return "Enter valid email";
                              }
                              return null;
                            },
                            decoration: customField(
                              "doctor@gmail.com",
                              Icons.email,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        onPressed: isLoading ? null : saveMedicalHistory,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D2F58),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Save Medical History",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}