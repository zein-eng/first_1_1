import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:first_1_1/fullImage_screen.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final dynamic image;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.image,
  });

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController birthController =
      TextEditingController();

  File? profileImage;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.name;
    emailController.text = widget.email;
  }

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
      });
    }
  }

  Future<void> selectDate() async {
    DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> saveChanges() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      await Future.delayed(
        const Duration(seconds: 2),
      );

      setState(() => isLoading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile Updated Successfully",
          ),
          backgroundColor:
              Color(0xFF0D2F58),
        ),
      );

      Navigator.pop(context, {
        "name": nameController.text,
        "email": emailController.text,
        "image":
            profileImage ?? widget.image,
      });
    }
  }

  InputDecoration customDecoration({
    required String text,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,

      fillColor:
          Theme.of(context).cardColor,

      labelText: text,

      prefixIcon: Icon(
        icon,
        color: const Color(0xFF0D2F58),
      ),

      suffixIcon: suffixIcon,

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: const BorderSide(
          color: Color(0xFF0D2F58),
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0D2F58),

        centerTitle: true,

        title: const Text(
          "Edit Profile",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [
              const SizedBox(height: 10),

              /// ================= PROFILE IMAGE =================
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      border: Border.all(
                        color: const Color(
                          0xFF0D2F58,
                        ),
                        width: 3,
                      ),
                    ),

                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    FullImageScreen(
                              image:
                                  profileImage ??
                                      widget
                                          .image,
                            ),
                          ),
                        );
                      },

                      child: CircleAvatar(
                        radius: 60,

                        backgroundColor:
                            Theme.of(
                              context,
                            ).cardColor,

                        backgroundImage:
                            profileImage !=
                                    null
                                ? FileImage(
                                    profileImage!,
                                  )
                                : widget.image
                                        is File
                                    ? FileImage(
                                        widget
                                            .image,
                                      )
                                    : widget.image !=
                                            null
                                        ? NetworkImage(
                                            widget
                                                .image,
                                          )
                                        : null,

                        child:
                            profileImage ==
                                        null &&
                                    widget
                                            .image ==
                                        null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color:
                                        Colors
                                            .grey,
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
                        padding:
                            const EdgeInsets.all(
                          10,
                        ),

                        decoration:
                            const BoxDecoration(
                          color: Color(
                            0xFF0D2F58,
                          ),
                          shape:
                              BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.camera_alt,
                          color:
                              Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              /// ================= NAME =================
              TextFormField(
                controller: nameController,

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Please enter name";
                  }

                  return null;
                },

                decoration: customDecoration(
                  text: "Name",
                  icon: Icons.person,
                ),
              ),

              const SizedBox(height: 20),

              /// ================= EMAIL =================
              TextFormField(
                controller: emailController,

                keyboardType:
                    TextInputType.emailAddress,

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Please enter email";
                  }

                  if (!value.contains("@")) {
                    return "Enter valid email";
                  }

                  return null;
                },

                decoration: customDecoration(
                  text: "Email",
                  icon: Icons.email,
                ),
              ),

              const SizedBox(height: 20),

              /// ================= PASSWORD =================
              TextFormField(
                controller:
                    passwordController,

                obscureText:
                    obscurePassword,

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Please enter password";
                  }

                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }

                  return null;
                },

                decoration: customDecoration(
                  text: "Password",
                  icon: Icons.lock,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },

                    icon: Icon(
                      obscurePassword
                          ? Icons
                              .visibility_off
                          : Icons.visibility,

                      color:
                          const Color(
                        0xFF0D2F58,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ================= CONFIRM PASSWORD =================
              TextFormField(
                controller:
                    confirmPasswordController,

                obscureText:
                    obscureConfirmPassword,

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Please confirm password";
                  }

                  if (value !=
                      passwordController
                          .text) {
                    return "Passwords do not match";
                  }

                  return null;
                },

                decoration: customDecoration(
                  text: "Confirm Password",
                  icon:
                      Icons.lock_outline,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword =
                            !obscureConfirmPassword;
                      });
                    },

                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons
                              .visibility_off
                          : Icons.visibility,

                      color:
                          const Color(
                        0xFF0D2F58,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ================= PHONE =================
              TextFormField(
                controller: phoneController,

                keyboardType:
                    TextInputType.phone,

                decoration: customDecoration(
                  text: "Phone Number",
                  icon: Icons.phone,
                ),
              ),

              const SizedBox(height: 20),

              /// ================= BIRTH DATE =================
              TextFormField(
                controller: birthController,

                readOnly: true,

                onTap: selectDate,

                decoration: customDecoration(
                  text: "Birth Date",
                  icon:
                      Icons.calendar_month,
                ),
              ),

              const SizedBox(height: 40),

              /// ================= SAVE BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : saveChanges,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF0D2F58,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  child:
                      isLoading
                          ? const CircularProgressIndicator(
                              color:
                                  Colors.white,
                            )
                          : const Text(
                              "Save Changes",

                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                color:
                                    Colors.white,
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