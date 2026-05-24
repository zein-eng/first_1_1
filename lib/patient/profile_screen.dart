import 'package:flutter/material.dart';


class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // الشريط العلوي
      appBar: AppBar(
        title: Text("Patient Profile"),
        backgroundColor: Color.fromARGB(255, 0, 71, 130),
      ),

      // الـ Side Bar
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            // رأس القائمة
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 71, 130),
              ),

              accountName: Text(
                "Ahmad Mohammad",
                style: TextStyle(fontSize: 18),
              ),

              accountEmail: Text("ahmad@gmail.com"),

              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Color.fromARGB(255, 0, 71, 130),
                ),
              ),
            ),

            // العناصر
            ListTile(
              leading: Icon(Icons.person),
              title: Text("My Profile"),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Appointments"),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.medical_services),
              title: Text("Treatment Plan"),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.payment),
              title: Text("Payments"),
              onTap: () {},
            ),

            Divider(),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),

      // محتوى الصفحة
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 60,
              backgroundColor: Color.fromARGB(255, 0, 71, 130),
              child: Icon(
                Icons.person,
                size: 70,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Ahmad Mohammad",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Patient ID: 1025",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}