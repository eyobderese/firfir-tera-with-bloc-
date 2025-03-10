import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoarding_2 extends StatefulWidget {
  const OnBoarding_2({super.key});

  @override
  State<OnBoarding_2> createState() => _OnBoarding_2State();
}

class _OnBoarding_2State extends State<OnBoarding_2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/images/onboard_2.png'),
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      Text(
                        "Find your Dream food here",
                        style: GoogleFonts.firaSans(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Here you can Find a Chef or dish for every taste and color. Enjoy",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        key: const Key('onboarding2_next_button'),
                        onPressed: () {
                          context.goNamed("/onBoarding_3");
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                            minimumSize:
                                MaterialStateProperty.all(const Size(130, 60)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(40.0)))),
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
