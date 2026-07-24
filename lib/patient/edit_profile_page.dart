import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:first_1_1/fullImage_screen.dart';
import 'package:first_1_1/constants.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String? phone;
  final String? dateOfBirth;
  final dynamic image;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    this.phone,
    this.dateOfBirth,
    required this.image,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthController = TextEditingController();

  DateTime? _selectedBirthDate;
  Uint8List? _pickedImageBytes;
  String? _pickedImageName;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final parts = widget.name.trim().split(RegExp(r'\s+'));
    firstNameController.text = parts.isNotEmpty ? parts.first : '';
    lastNameController.text =
        parts.length > 1 ? parts.sublist(1).join(' ') : '';

    emailController.text = widget.email;
    phoneController.text = widget.phone ?? '';
    if (widget.dateOfBirth != null && widget.dateOfBirth!.isNotEmpty) {
      birthController.text = widget.dateOfBirth!;
      final parsedDate = DateTime.tryParse(widget.dateOfBirth!);
      if (parsedDate != null) {
        _selectedBirthDate = parsedDate;
      }
    }
  }

  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, 
    );

    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        _pickedImageBytes = bytes;
        _pickedImageName = pickedImage.name;
      });
    }
  }

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedBirthDate = pickedDate;
        birthController.text =
            "${pickedDate.year.toString().padLeft(4, '0')}-"
            "${pickedDate.month.toString().padLeft(2, '0')}-"
            "${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

 Future<void> saveChanges() async {
  if (formKey.currentState!.validate()) {
    setState(() => isLoading = true);

    // 1. تعريف updatedName (مثلاً دمج الاسم الأول والأخير)
    final updatedName = "${firstNameController.text.trim()} ${lastNameController.text.trim()}";

    // 2. استقبال نتيجة حفظ البيانات من الـ API بمتغير اسمه success
    final bool success = await Constants.updateProfile(
      // البيانات المرسلة للـ API...
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    // 3. الآن سينجح الشرط دون أخطاء
    if (success) {
      Navigator.pop(context, {
        "name": updatedName,
        "email": emailController.text,
        "phone": phoneController.text.trim(),
        "dateOfBirth": birthController.text.trim(),
        "image": _pickedImageBytes ?? widget.image,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }
}

  ImageProvider? _currentImageProvider() {
    if (_pickedImageBytes != null) {
      return MemoryImage(_pickedImageBytes!);
    }
    if (widget.image is String && widget.image.isNotEmpty) {
      if (widget.image.startsWith('http://') ||
          widget.image.startsWith('https://')) {
        return NetworkImage(widget.image);
      }
      if (widget.image.startsWith('assets/')) {
        return AssetImage(widget.image);
      }
      return NetworkImage(Constants.resolveImageUrl(widget.image));
    }
    return null;
  }

  InputDecoration customDecoration({
    required String text,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Theme.of(context).cardColor,
      labelText: text,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF0D2F58),
      ),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFF0D2F58),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _currentImageProvider();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2F58),
        centerTitle: true,
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0D2F58),
                        width: 3,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullImageScreen(
                              image: _pickedImageBytes ?? widget.image,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).cardColor,
                        backgroundImage: imageProvider,
                        child: imageProvider == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0D2F58),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              TextFormField(
                controller: firstNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter first name";
                  }
                  return null;
                },
                decoration: customDecoration(
                  text: "First Name",
                  icon: Icons.person,
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: lastNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter last name";
                  }
                  return null;
                },
                decoration: customDecoration(
                  text: "Last Name",
                  icon: Icons.person_outline,
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                readOnly: true,
                enabled: false,
                decoration: customDecoration(
                  text: "Email (not editable here)",
                  icon: Icons.email,
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: customDecoration(
                  text: "Phone Number",
                  icon: Icons.phone,
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: birthController,
                readOnly: true,
                onTap: selectDate,
                decoration: customDecoration(
                  text: "Birth Date",
                  icon: Icons.calendar_month,
                ),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D2F58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Save Changes",
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