
import 'package:flutter/material.dart';
import 'package:first_1_1/splash/date_page.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Transform.translate(
                offset: Offset(0, -40),
                child: Image.asset('assets/icon.png', width: 400, height: 250),
              ),

              SizedBox(height: 20),

              Text(
                'Welcome to DentaPrint',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 71, 130),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              Text(
                'Your trusted dental clinic\n for a healthy smile',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontFamily: 'Arial',
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Datepage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 71, 130),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
