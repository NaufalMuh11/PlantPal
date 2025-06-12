import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plants_app/constants.dart';
import 'package:plants_app/ui/root_page.dart';
import 'package:plants_app/ui/screens/signup_page.dart';
import 'package:plants_app/ui/screens/widget/custom_textfield.dart';
import 'package:plants_app/ui/screens/signin_page.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/reset-password.png'),
              const Text(
                'Forgot\nPassword',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 30),
              const CustomTextField(
                obscureText: false,
                hintText: 'Enter Email',
                icon: Icons.alternate_email,
              ),
              GestureDetector(
                onTap: () {
          
                },
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: const Center(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: const SignIn(),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Have an Account? ',
                          style: TextStyle(color: Constants.blackColor),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color:
                                Constants
                                    .primaryColor, // Buat tampak seperti link
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
