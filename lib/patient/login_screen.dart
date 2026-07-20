import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '/constants.dart';
import '/patient/register_screen.dart';
import '/patient/homepage_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    setState(() {
      isLoading = true;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Missing information"),
            content: Text(
              "Please make sure that you have filled all the fields",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          );
        },
      );

      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      Response response = await Constants.dio.post(
        '${Constants.baseUrl}patient/login',
        data: {
          "email": _emailController.text,
          "password": _passwordController.text,
        },
      );

      // Backend says login success
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Login successful: ${response.data}');
        setState(() => isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Backend responded but login failed (invalid credentials)
        setState(() => isLoading = false);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Login failed"),
            content: Text(response.data["message"] ?? "Invalid credentials"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } on DioException catch (e) {
      setState(() => isLoading = false);

      // Server returned an error (401, 404, etc.)
      if (e.response != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Login failed"),
            content: Text(
              e.response?.data["message"] ?? "Something went wrong",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      } else {
        // Network error or unexpected error
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Network Error"),
            content: Text("Please check your connection."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xff1565FF);
    const Color brandDarkBlue = Color(0xff0D2F58);
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
          physics: const BouncingScrollPhysics(),
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
                        height: screenSize.height * 0.2,
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

              // 2. كرت الإدخال مع الأيقونة الطافية المتداخلة (Stack)
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
                      padding: const EdgeInsets.fromLTRB(25, 55, 25, 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: brandDarkBlue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Sign in to continue to your account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xff848496),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // حقل إدخال البريد الإلكتروني (باستخدام نفس تصميم الـ buildField المتناسق)
                          buildField(
                            "Email or Phone",
                            Icons.person_outline_rounded,
                            controller: _emailController,
                          ),
                          const SizedBox(height: 15),

                          // حقل إدخال كلمة المرور مع ميزة الإخفاء والإظهار التفاعلية
                          buildField(
                            "Password",
                            Icons.lock_outline_rounded,
                            controller: _passwordController,
                            obscom: _obscurePassword,
                            isPasswordField: true,
                            onIconPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),

                          // زر نسيت كلمة المرور الأنيق والمحاذي لليمين
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: brandDarkBlue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // زر تسجيل الدخول المتدرج الأنيق مع حالة الـ Loading الذكية
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [Color(0xff1565FF), Color(0xff003D99)],
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: isLoading ? null : _login,
                                borderRadius: BorderRadius.circular(15),
                                child: Center(
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Sign In",
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
                          const SizedBox(height: 20),

                          // خط الفاصل الأنيق "OR"
                          Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Color(0xffE2E8F0),
                                  thickness: 1.2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Color(0xff848496),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Color(0xffE2E8F0),
                                  thickness: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // زر الدخول كزائر المفرغ (Outlined) ليتناسب مع فخامة الهوية البصرية
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: brandDarkBlue,
                                side: const BorderSide(
                                  color: brandDarkBlue,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 20,
                                    color: brandDarkBlue,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Continue as Guest",
                                    style: TextStyle(
                                      color: brandDarkBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // رابط الانتقال لإنشاء حساب جديد
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: primaryBlue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // الأيقونة الدائرية الطافية المتداخلة مع الحافة العلوية للكرت الأبيض (مطابقة للـ Register تماماً)
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
                              colors: [Color(0xff4D8BFD), Color(0xff063484)],
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .lock_outline_rounded, // أيقونة القفل الفخمة لتناسب شاشة تسجيل الدخول
                            color: Colors.white,
                            size: 30,
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

  // استخدام نفس دالة بناء الحقول المعتمدة لديك مع تخصيصها لشاشة اللوج إن
  Widget buildField(
    String hint,
    IconData icon, {
    bool obscom = false,
    TextEditingController? controller,
    bool isPasswordField = false,
    VoidCallback? onIconPressed,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscom,
      keyboardType: hint == "Email or Phone"
          ? TextInputType.emailAddress
          : TextInputType.text,
      style: const TextStyle(color: Color(0xff0D2F58), fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xff848496), fontSize: 15),
        prefixIcon: Icon(icon, color: const Color(0xff0D2F58)),
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  obscom
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xff848496),
                ),
                onPressed: onIconPressed,
              )
            : null,
        filled: true,
        fillColor: const Color(0xffF8FAFD),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
