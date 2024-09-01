import 'package:flutter/material.dart';
import 'package:identify_attendance_app/components/rounded_button.dart';

import '../components/profile_container.dart';

class ViewProfileScreen extends StatelessWidget {
  static const String routeName = 'view_profile_screen';

  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 90.0),
          child: Text(
            'Edit Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        titleSpacing: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileContainer(
              text1: 'Name',
              text2: 'Peter Olusefun Damilola',
            ),
            ProfileContainer(
              text1: 'Email',
              text2: 'peter@john.com',
            ),
            ProfileContainer(
              text1: 'password',
              text2: 'password',
            ),
            SizedBox(
              height: 40.0,
            ),
            RoundedButton(
              onPress: () {},
              label: 'Save Changes',
              colour: Colors.indigo,
            )
          ],
        ),
      ),
    );
  }
}
