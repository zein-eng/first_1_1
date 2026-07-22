import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'homepage_screen.dart';
import 'login_screen.dart';
import 'package:project_11/constants.dart';
import 'package:dio/dio.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await Constants.dio.post(
        '${Constants.baseUrl}patient/register',
        data: {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'date_of_birth': _dobController.text.trim(),
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController.text,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (mounted &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data != null && response.data['token'] != null) {
          Constants.token = response.data['token'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on DioException catch (e) {
      String errorMessage = "An error occurred during registration.";

      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        } else if (data is Map && data.containsKey('errors')) {
          final errors = data['errors'] as Map;
          errorMessage = errors.values.first[0].toString();
        }
      } else {
        errorMessage = "Connection error. Please check your network.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unexpected error: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xff1565FF);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff0D2F58), Color(0xff051937)],
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SafeArea(
                bottom: false,
                child: SizedBox(
                  height: screenSize.height * 0.32,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/iconwhite.png',
                        height: screenSize.height * 0.16,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: [
                            TextSpan(
                              text: "Denta",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: "Print",
                              style: TextStyle(color: primaryBlue),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "DENTAL CENTER",
                        style: TextStyle(
                          color: Colors.white54,
                          letterSpacing: 5,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 20,
                      top: 10,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(25, 55, 25, 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Create Patient Account",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0D2F58),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Join DentaPrint and take care of your smile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff848496),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // First Name
                            buildField(
                              "First Name",
                              Icons.person_outline,
                              controller: _firstNameController,
                            ),
                            const SizedBox(height: 15),

                            // Last Name
                            buildField(
                              "Last Name",
                              Icons.person_outline,
                              controller: _lastNameController,
                            ),
                            const SizedBox(height: 15),

                            // Email
                            buildField(
                              "Email Address",
                              Icons.email_outlined,
                              controller: _emailController,
                            ),
                            const SizedBox(height: 15),

                            // Phone
                            buildField(
                              "Phone Number",
                              Icons.phone_outlined,
                              controller: _phoneController,
                            ),
                            const SizedBox(height: 15),

                            // Date of Birth
                            buildField(
                              "Date of Birth",
                              Icons.calendar_today_outlined,
                              controller: _dobController,
                              readOnly: true,
                              onIconPressed: () => _selectDate(context),
                              isDatePicker: true,
                            ),
                            const SizedBox(height: 15),

                            // Password
                            buildField(
                              "Password",
                              Icons.lock_outline,
                              controller: _passwordController,
                              obscom: _isPasswordObscured,
                              isPasswordField: true,
                              onIconPressed: () {
                                setState(
                                  () => _isPasswordObscured =
                                      !_isPasswordObscured,
                                );
                              },
                            ),
                            SizedBox(height: 15),

                            // Confirm Password
                            buildField(
                              "Confirm Password",
                              Icons.lock_outline,
                              controller: _confirmPasswordController,
                              obscom: _isConfirmPasswordObscured,
                              isPasswordField: true,
                              onIconPressed: () {
                                setState(
                                  () => _isConfirmPasswordObscured =
                                      !_isConfirmPasswordObscured,
                                );
                              },
                            ),
                            const SizedBox(height: 35),

                            // Submit Button
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff1565FF),
                                    Color(0xff003D99),
                                  ],
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _isLoading ? null : _register,
                                  borderRadius: BorderRadius.circular(15),
                                  child: Center(
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Create Account",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Color(0xff1565FF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -15,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(1.2),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xff4D8BFD), Color(0xff063284)],
                            ),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(
    String hint,
    IconData icon, {
    bool obscom = false,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onIconPressed,
    bool isPasswordField = false,
    bool isDatePicker = false,
  }) {
    TextInputType keyboardType = TextInputType.text;
    if (hint == "Email Address") {
      keyboardType = TextInputType.emailAddress;
    } else if (hint == "Phone Number") {
      keyboardType = TextInputType.phone;
    }

    return TextFormField(
      controller: controller,
      obscureText: obscom,
      readOnly: readOnly,
      onTap: isDatePicker ? onIconPressed : null,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field is required";
        }
        if (hint == "Email Address") {
          bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ).hasMatch(value);
          if (!emailValid) {
            return "Please enter a valid email address";
          }
        }
        if (hint == "Password" && value.length < 8) {
          return "Password must be at least 8 characters";
        }
        if (hint == "Confirm Password" && value != _passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xff0D2F58)),
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(obscom ? Icons.visibility_off : Icons.visibility),
                onPressed: onIconPressed,
              )
            : isDatePicker
            ? const Icon(Icons.calendar_month)
            : null,
        filled: true,
        fillColor: const Color(0xffF8FAFD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
