import 'package:flutter/material.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() =>
      _PaymentsPageState();
}

class _PaymentsPageState
    extends State<PaymentsPage> {
  final TextEditingController
      cardNameController =
      TextEditingController();

  final TextEditingController
      cardNumberController =
      TextEditingController();

  final TextEditingController
      expiryController =
      TextEditingController();

  final TextEditingController
      cvvController =
      TextEditingController();

  bool isLoading = false;

  /// ================= SUCCESS DIALOG =================
  void showSuccessDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(25),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                padding:
                    const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color:
                      Colors.green.shade100,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 50,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Payment Successful",

                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,

                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Your payment has been completed successfully.",

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 15,

                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color,
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context),

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

                  child: const Text(
                    "Done",

                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= PAYMENT =================
  Future<void> makePayment() async {
    if (cardNameController.text.isEmpty ||
        cardNumberController.text
            .isEmpty ||
        expiryController.text.isEmpty ||
        cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Complete all fields"),
        ),
      );

      return;
    }

    if (cardNumberController
                .text.length <
            16 ||
        !RegExp(r'^[0-9]+$').hasMatch(
          cardNumberController.text,
        )) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Invalid card number"),
        ),
      );

      return;
    }

    if (cvvController.text.length !=
            3 ||
        !RegExp(r'^[0-9]+$').hasMatch(
          cvvController.text,
        )) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text("Invalid CVV"),
        ),
      );

      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() => isLoading = false);

    showSuccessDialog();
  }

  /// ================= INPUT FIELD =================
  Widget buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController
        controller,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 18),

      child: TextField(
        controller: controller,

        keyboardType: keyboardType,

        maxLength: maxLength,

        onChanged: (_) {
          setState(() {});
        },

        style: TextStyle(
          color: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.color,
        ),

        decoration: InputDecoration(
          counterText: "",

          hintText: hint,

          prefixIcon: Icon(
            icon,
            color: const Color(
              0xFF0D2F58,
            ),
          ),

          filled: true,

          fillColor:
              Theme.of(context).cardColor,

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 20,
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),

            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),

            borderSide: const BorderSide(
              color: Color(0xFF2563EB),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  /// ================= FORMAT CARD NUMBER =================
  String formatCardNumber(
      String input) {
    if (input.isEmpty) {
      return "****  ****  ****  4589";
    }

    List<String> groups = [];

    for (int i = 0;
        i < input.length;
        i += 4) {
      int end =
          (i + 4 < input.length)
              ? i + 4
              : input.length;

      groups.add(input.substring(i, end));
    }

    return groups.join("  ");
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            const Color(0xFF0D2F58),

        centerTitle: true,

        title: const Text(
          "Payment",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            /// ================= CREDIT CARD =================
            Container(
              height: 190,
              width: double.infinity,

              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  25,
                ),

                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF0D2F58),
                    Color(0xFF2563EB),
                  ],

                  begin: Alignment.topLeft,
                  end:
                      Alignment.bottomRight,
                ),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),

              child: Padding(
                padding:
                    const EdgeInsets.all(
                  20,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: const [
                        Icon(
                          Icons.credit_card,
                          color: Colors.white,
                          size: 30,
                        ),

                        Text(
                          "VISA",

                          style: TextStyle(
                            color:
                                Colors.white,
                            fontSize: 24,
                            fontWeight:
                                FontWeight
                                    .bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Text(
                      formatCardNumber(
                        cardNumberController
                            .text,
                      ),

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 2,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            const Text(
                              "CARD HOLDER",

                              style:
                                  TextStyle(
                                color:
                                    Colors
                                        .white70,
                                fontSize:
                                    10,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              cardNameController
                                      .text
                                      .isEmpty
                                  ? "YOUR NAME"
                                  : cardNameController
                                      .text
                                      .toUpperCase(),

                              style:
                                  const TextStyle(
                                color:
                                    Colors
                                        .white,
                                fontSize:
                                    15,
                                fontWeight:
                                    FontWeight
                                        .w500,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            const Text(
                              "EXPIRES",

                              style:
                                  TextStyle(
                                color:
                                    Colors
                                        .white70,
                                fontSize:
                                    10,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              expiryController
                                      .text
                                      .isEmpty
                                  ? "MM/YY"
                                  : expiryController
                                      .text,

                              style:
                                  const TextStyle(
                                color:
                                    Colors
                                        .white,
                                fontSize:
                                    15,
                                fontWeight:
                                    FontWeight
                                        .w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 35),

            /// ================= TITLE =================
            Text(
              "Card Information",

              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,

                color: isDark
                    ? Colors.white
                    : const Color(
                        0xFF0D2F58,
                      ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Enter your payment details securely",

              style: TextStyle(
                fontSize: 15,

                color: isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),

            const SizedBox(height: 30),

            /// ================= FORM =================
            buildTextField(
              hint: "Card Holder Name",
              icon: Icons.person,
              controller:
                  cardNameController,
            ),

            buildTextField(
              hint: "Card Number",
              icon: Icons.credit_card,
              controller:
                  cardNumberController,
              keyboardType:
                  TextInputType.number,
              maxLength: 16,
            ),

            Row(
              children: [
                Expanded(
                  child: buildTextField(
                    hint: "MM/YY",
                    icon: Icons.date_range,
                    controller:
                        expiryController,
                    maxLength: 5,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: buildTextField(
                    hint: "CVV",
                    icon: Icons.lock,
                    controller:
                        cvvController,
                    keyboardType:
                        TextInputType.number,
                    maxLength: 3,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// ================= SECURITY TEXT =================
            Row(
              children: [
                const Icon(
                  Icons.lock,
                  color: Colors.green,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Text(
                  "Secure encrypted payment",

                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            /// ================= BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : makePayment,

                style:
                    ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,

                  backgroundColor:
                      Colors.transparent,

                  shadowColor:
                      Colors.transparent,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                child: Ink(
                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFF0D2F58),
                        Color(0xFF2563EB),
                      ],
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Container(
                    alignment: Alignment.center,

                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                                color:
                                    Colors
                                        .white,
                              )
                            : const Text(
                                "Confirm Payment",

                                style:
                                    TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  color: Colors
                                      .white,
                                ),
                              ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}