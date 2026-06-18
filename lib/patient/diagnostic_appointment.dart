import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiagnosticBookingScreen extends StatefulWidget {
  const DiagnosticBookingScreen({super.key});

  @override
  State<DiagnosticBookingScreen> createState() => _DiagnosticBookingScreenState();
}

class _DiagnosticBookingScreenState extends State<DiagnosticBookingScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  bool _isSubmitting = false;

  final List<DateTime> _availableDays = [];

  final List<String> _monthsNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ];

  final List<String> _weekDaysNames = [
    "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
  ];

  // أوقات الدوام الثابتة للعيادة
  final String _workingHoursDisplay = "09:00 AM - 04:00 PM";

  // فترات المواعيد المتاحة بناءً على دوام العيادة
  final List<String> _morningSlots = [
    "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM",
    "11:00 AM", "11:30 AM", "12:00 PM",
  ];

  final List<String> _afternoonSlots = [
    "12:30 PM", "01:00 PM", "01:30 PM", "02:00 PM",
    "02:30 PM", "03:00 PM", "03:30 PM", "04:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    _generateBookingDays();
  }

  // توليد 30 يوم من اليوم للحجز
  void _generateBookingDays() {
    DateTime today = DateTime.now();
    for (int i = 0; i < 30; i++) {
      _availableDays.add(today.add(Duration(days: i)));
    }
  }

  Future<void> _confirmAppointment(String timeSlot) async {
    setState(() => _isSubmitting = true);

    DateTime selectedDate = _availableDays[_selectedDateIndex];
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    Map<String, dynamic> bookingPayload = {
      "appointment_type": "diagnostic",
      "booking_date": formattedDate,
      "booking_time": timeSlot,
    };

    // محاكاة الإرسال للسيرفر
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Your diagnostic session booking request has been confirmed!",
          ),
          backgroundColor: Color(0xff1565FF),
        ),
      );
      Navigator.pop(context);
    }
  }

  // التابع يفحص إذا كان اليوم هو الجمعة لتعطيله
  bool _isSlotAvailable(DateTime date) {
    if (date.weekday == DateTime.friday) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    const Color bgNavy = Color(0xff051534);
    const Color cardNavy = Color(0xff0c2952);
    const Color accentBlue = Color(0xff1565FF);
    const Color lightGreyBg = Color(0xffF8FAFC);
    const Color borderGrey = Color(0xffE2E8F0);

    String currentSelectedMonth = _availableDays.isNotEmpty
        ? _monthsNames[_availableDays[_selectedDateIndex].month - 1]
        : _monthsNames[DateTime.now().month - 1];

    int currentSelectedYear = _availableDays.isNotEmpty
        ? _availableDays[_selectedDateIndex].year
        : DateTime.now().year;

    return Scaffold(
      backgroundColor: bgNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Book Diagnostic Session",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // قسم عرض مواعيد عمل العيادة بتصميم عمودي واضح ومقروء جداً لمنع الـ Overflow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardNavy,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xff1A365D), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xff63B3ED),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Working Days",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Saturday - Thursday (Friday Off)",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xff63B3ED),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Working Hours",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _workingHoursDisplay,
                            style: const TextStyle(
                              color: Color(0xff63B3ED),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 280),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$currentSelectedMonth $currentSelectedYear",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff051534),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSectionHeader("1", "Select Day"),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _availableDays.length,
                            itemBuilder: (context, index) => _buildDayItem(
                              index,
                              accentBlue,
                              borderGrey,
                              lightGreyBg,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildSectionHeader("2", "Select Time"),
                        const SizedBox(height: 16),
                        const Text(
                          "Morning",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildTimeGrid(
                          _morningSlots,
                          0,
                          accentBlue,
                          borderGrey,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Afternoon",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildTimeGrid(
                          _afternoonSlots,
                          _morningSlots.length,
                          accentBlue,
                          borderGrey,
                        ),
                      ],
                    ),
                  ),
                  _buildBottomStickyPanel(
                    bgNavy,
                    cardNavy,
                    accentBlue,
                    lightGreyBg,
                    borderGrey,
                    currentSelectedMonth,
                    currentSelectedYear,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String number, String title) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff1A365D),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff051534),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDayItem(
    int index,
    Color accentBlue,
    Color borderGrey,
    Color lightGreyBg,
  ) {
    bool isSelected = _selectedDateIndex == index;
    DateTime dayDate = _availableDays.isNotEmpty ? _availableDays[index] : DateTime.now();

    String weekdayName = _weekDaysNames[dayDate.weekday % 7];
    String dayNum = dayDate.day.toString();
    String monthName = _monthsNames[dayDate.month - 1];

    bool isAvailable = _isSlotAvailable(dayDate);

    return GestureDetector(
      onTap: !isAvailable
          ? null
          : () {
              setState(() {
                _selectedDateIndex = index;
                _selectedTimeIndex = -1;
              });
            },
      child: Container(
        width: 54,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? accentBlue
              : (!isAvailable ? Colors.white : lightGreyBg),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentBlue : borderGrey,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekdayName,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white70
                    : (!isAvailable ? Colors.grey.shade300 : Colors.grey),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dayNum,
              style: TextStyle(
                fontSize: 15,
                color: isSelected
                    ? Colors.white
                    : (!isAvailable ? Colors.grey.shade300 : const Color(0xff051534)),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              monthName,
              style: TextStyle(
                fontSize: 9,
                color: isSelected
                    ? Colors.white70
                    : (!isAvailable ? Colors.grey.shade300 : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeGrid(
    List<String> slots,
    int offset,
    Color accentBlue,
    Color borderGrey,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(slots.length, (index) {
        int actualIndex = index + offset;
        bool isSelected = _selectedTimeIndex == actualIndex;

        return GestureDetector(
          onTap: () => setState(() => _selectedTimeIndex = actualIndex),
          child: Container(
            width: (MediaQuery.of(context).size.width - 70) / 4,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? accentBlue : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? accentBlue : borderGrey,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              slots[index],
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white : const Color(0xff051534),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomStickyPanel(
    Color bgNavy,
    Color cardNavy,
    Color accentBlue,
    Color lightGreyBg,
    Color borderGrey,
    String month,
    int year,
  ) {
    DateTime selectedDateTime = _availableDays.isNotEmpty ? _availableDays[_selectedDateIndex] : DateTime.now();

    String selectedDayName = _weekDaysNames[selectedDateTime.weekday % 7];
    String selectedDayNum = selectedDateTime.day.toString();

    bool hasValidTime = _selectedTimeIndex != -1;
    String selectedTime = "Select Time";

    if (hasValidTime) {
      selectedTime = _selectedTimeIndex < _morningSlots.length
          ? _morningSlots[_selectedTimeIndex]
          : _afternoonSlots[_selectedTimeIndex - _morningSlots.length];
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: lightGreyBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderGrey),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffEBF8FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xff3182CE),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Appointment",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "$selectedDayName, $selectedDayNum $month $year",
                          style: const TextStyle(
                            color: Color(0xff051534),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          "General Diagnostic Session",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    selectedTime,
                    style: TextStyle(
                      color: hasValidTime ? const Color(0xff3182CE) : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: !hasValidTime || _isSubmitting ? null : () => _confirmAppointment(selectedTime),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: hasValidTime && !_isSubmitting ? accentBlue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Confirm Appointment",
                            style: TextStyle(
                              color: hasValidTime ? Colors.white : Colors.grey.shade500,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "We'll send you a reminder",
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}