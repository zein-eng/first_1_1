import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const BookingScreen({super.key, required this.doctorData});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  bool _isLoading = true;
  bool _isSubmitting = false;

  final List<DateTime> _availableDays = [];

  final List<String> _monthsNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  final List<String> _weekDaysNames = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];

  List<Map<String, String>> _clinicAvailability = [];
  List<String> _alreadyBookedSlots = [];

  final List<String> _morningSlots = [
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 PM",
  ];

  final List<String> _afternoonSlots = [
    "12:30 PM",
    "01:00 PM",
    "01:30 PM",
    "02:00 PM",
    "02:30 PM",
    "03:00 PM",
    "03:30 PM",
    "04:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    _generateBookingDays();
    _fetchDoctorAvailability();
  }

  void _generateBookingDays() {
    DateTime today = DateTime.now();
    for (int i = 0; i < 30; i++) {
      _availableDays.add(today.add(Duration(days: i)));
    }
  }

  Future<void> _fetchDoctorAvailability() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 1500));

    _clinicAvailability = [
      {"day": "Mon", "fullName": "Monday", "time": "10:00 AM - 03:00 PM"},
      {"day": "Tue", "fullName": "Tuesday", "time": "09:00 AM - 02:00 PM"},
      {"day": "Thu", "fullName": "Thursday", "time": "03:00 PM - 08:00 PM"},
    ];

    _alreadyBookedSlots = ["10:00 AM", "01:30 PM", "04:00 PM"];

    setState(() => _isLoading = false);
  }

  Future<void> _confirmAppointment(String timeSlot) async {
    setState(() => _isSubmitting = true);

    DateTime selectedDate = _availableDays[_selectedDateIndex];
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    dynamic doctorId = widget.doctorData["id"] ?? "no_id_provided";

    Map<String, dynamic> bookingPayload = {
      "doctor_id": doctorId,
      "booking_date": formattedDate,
      "booking_time": timeSlot,
    };

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            " Your booking request has been sent! We will confirm it shortly.",
          ),
          backgroundColor: Color(0xff1565FF),
        ),
      );
      Navigator.pop(context);
    }
  }

  bool _isSlotAvailable(String slotTime) {
    if (_availableDays.isEmpty || _isLoading) return false;

    DateTime selectedDate = _availableDays[_selectedDateIndex];
    String selectedDayName = _weekDaysNames[selectedDate.weekday % 7];

    if (_alreadyBookedSlots.contains(slotTime)) {
      return false;
    }

    Map<String, String>? dayConfig;
    for (var availability in _clinicAvailability) {
      if (availability["day"] == selectedDayName) {
        dayConfig = availability;
        break;
      }
    }

    if (dayConfig == null) return false;

    try {
      List<String> parts = dayConfig["time"]!.split(" - ");
      DateFormat format = DateFormat("hh:mm a");

      DateTime startTime = format.parse(parts[0]);
      DateTime endTime = format.parse(parts[1]);
      DateTime currentSlot = format.parse(slotTime);

      return (currentSlot.isAfter(startTime) ||
              currentSlot.isAtSameMomentAs(startTime)) &&
          (currentSlot.isBefore(endTime) ||
              currentSlot.isAtSameMomentAs(endTime));
    } catch (e) {
      return false;
    }
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
          "Book Appointment",
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Availability at the Clinic",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: _clinicAvailability
                            .map(
                              (info) => _buildAvailabilityRow(info, cardNavy),
                            )
                            .toList(),
                      ),
              ],
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
                        _isLoading
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                    color: accentBlue,
                                  ),
                                ),
                              )
                            : _buildTimeGrid(
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
                        _isLoading
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                    color: accentBlue,
                                  ),
                                ),
                              )
                            : _buildTimeGrid(
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

  Widget _buildAvailabilityRow(Map<String, String> info, Color cardNavy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardNavy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xff1A365D),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              info["day"]!,
              style: const TextStyle(
                color: Color(0xff63B3ED),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            info["fullName"]!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(Icons.access_time, color: Colors.white54, size: 14),
          const SizedBox(width: 6),
          Text(
            info["time"]!,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
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
    DateTime dayDate = _availableDays.isNotEmpty
        ? _availableDays[index]
        : DateTime.now();

    String weekdayName = _weekDaysNames[dayDate.weekday % 7];
    String dayNum = dayDate.day.toString();
    String monthName = _monthsNames[dayDate.month - 1];

    bool isDoctorWorkingThisDay = _clinicAvailability.any(
      (availability) => availability["day"] == weekdayName,
    );
    bool isDisabled =
        dayDate.weekday == DateTime.friday ||
        (!isDoctorWorkingThisDay && !_isLoading);

    return GestureDetector(
      onTap: isDisabled || _isLoading
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
              : (isDisabled ? Colors.white : lightGreyBg),
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
                    : (isDisabled ? Colors.grey.shade300 : Colors.grey),
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
                    : (isDisabled
                          ? Colors.grey.shade300
                          : const Color(0xff051534)),
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
                    : (isDisabled ? Colors.grey.shade300 : Colors.grey),
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

        bool isAvailable = _isSlotAvailable(slots[index]);

        return GestureDetector(
          onTap: !isAvailable || _isLoading
              ? null
              : () => setState(() => _selectedTimeIndex = actualIndex),
          child: Container(
            width: (MediaQuery.of(context).size.width - 70) / 4,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentBlue
                  : (!isAvailable ? Colors.grey.shade100 : Colors.white),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? accentBlue
                    : (!isAvailable ? Colors.grey.shade200 : borderGrey),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              slots[index],
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white
                    : (!isAvailable
                          ? Colors.grey.shade400
                          : const Color(0xff051534)),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                decoration: !isAvailable
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
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
    DateTime selectedDateTime = _availableDays.isNotEmpty
        ? _availableDays[_selectedDateIndex]
        : DateTime.now();

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
                        Text(
                          "With ${widget.doctorData["name"] ?? "Dr. Ahmed El-Said"}",
                          style: const TextStyle(
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
                      color: hasValidTime
                          ? const Color(0xff3182CE)
                          : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: !hasValidTime || _isSubmitting
                  ? null
                  : () => _confirmAppointment(selectedTime),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: hasValidTime && !_isSubmitting
                      ? accentBlue
                      : Colors.grey.shade300,
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
                              color: hasValidTime
                                  ? Colors.white
                                  : Colors.grey.shade500,
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
