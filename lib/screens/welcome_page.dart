import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onFirstTimeStart;
  final VoidCallback onReturningUser;
  final bool hasExistingData;

  const WelcomePage({
    Key? key,
    required this.onFirstTimeStart,
    required this.onReturningUser,
    required this.hasExistingData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFDFBF7), 
        child: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Image.asset(
                  hasExistingData
                      ? 'assets/images/welcome_back.png'
                      : 'assets/images/onboarding.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),

                
                Positioned(
                  bottom: 40, 
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: hasExistingData ? onReturningUser : onFirstTimeStart,
                      child: Container(
                        width: 180,
                        height: 80,
                        color: Colors.transparent,
                      ),
                    ),
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
