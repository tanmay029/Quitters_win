import 'package:flutter/material.dart';
import 'screens/quit_smoking_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuitSmokingApp());
}

class QuitSmokingApp extends StatelessWidget {
  const QuitSmokingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quit Smoking App',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: QuitSmokingHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
