
import 'package:flutter/material.dart';
import 'package:first_1_1/splash/case_page.dart';

class Datepage extends StatelessWidget {
  const Datepage({super.key});
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
                offset: Offset(15, -40),
                child: Image.asset(
                  'assets/teethicon.png',
                  width: 400,
                  height: 250,
                ),
              ),

              SizedBox(height: 20),

              Text(
                'Choose the time that suits you',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 71, 130),
                  fontFamily: 'Pacifico',
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              Text(
                'You can choose the time along with selecting the doctor you prefer.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontFamily: 'Ubuntu',
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

    ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:Color.fromARGB(255, 0, 71, 130),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Previous',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),

    SizedBox(width: 20),

    ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Casepage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 0, 71, 130),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        '  Next    ',
        style: TextStyle(color: Colors.white, fontSize: 16),
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
}