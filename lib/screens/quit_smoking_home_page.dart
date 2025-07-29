import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../utils/smoking_calculations.dart';
import 'welcome_page.dart';
import 'form_page.dart';
import 'results_page.dart';

class QuitSmokingHomePage extends StatefulWidget {
  @override
  _QuitSmokingHomePageState createState() => _QuitSmokingHomePageState();
}

class _QuitSmokingHomePageState extends State<QuitSmokingHomePage> {
  final PageController _pageController = PageController();

  // Form data
  String ageStarted = '';
  String currentAge = '';
  String packsPerDay = '';
  String costPerPack = '';
  String currency = 'INR';
  int smokeFreeDays = 0;
  Map<String, dynamic>? calculations;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final data = await PreferencesService.loadData();
    setState(() {
      ageStarted = data['ageStarted'];
      currentAge = data['currentAge'];
      packsPerDay = data['packsPerDay'];
      costPerPack = data['costPerPack'];
      currency = data['currency'];
      smokeFreeDays = data['smokeFreeDays'];
      calculations = data['calculations'];
    });
  }

  void _calculateStats() {
    final stats = SmokingCalculations.calculateStats(
      ageStarted: ageStarted,
      currentAge: currentAge,
      packsPerDay: packsPerDay,
      costPerPack: costPerPack,
    );

    setState(() {
      calculations = stats;
    });

    PreferencesService.saveData(
      ageStarted: ageStarted,
      currentAge: currentAge,
      packsPerDay: packsPerDay,
      costPerPack: costPerPack,
      currency: currency,
      smokeFreeDays: smokeFreeDays,
      calculations: calculations,
    );

    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showBreakStreakWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFDFBF7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning, color: Color(0xFFE76F51), size: 30),
              SizedBox(width: 10),
              Text(
                'Warning!',
                style: TextStyle(
                  color: Color(0xFF264653),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'You\'re about to break your $smokeFreeDays-day smoke-free streak. This will reset your progress to 0. Are you sure?',
            style: TextStyle(color: Color(0xFF7D7D7D)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF7D7D7D)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  smokeFreeDays = 0;
                });
                PreferencesService.saveData(
                  ageStarted: ageStarted,
                  currentAge: currentAge,
                  packsPerDay: packsPerDay,
                  costPerPack: costPerPack,
                  currency: currency,
                  smokeFreeDays: smokeFreeDays,
                  calculations: calculations,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFDFBF7),
              ),
              child: const Text('Break Streak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFFFDFBF7),
        body: PageView(
          controller: _pageController,
          physics:
              const NeverScrollableScrollPhysics(), // Disable swipe navigation
          allowImplicitScrolling: false,
          onPageChanged: (index) {
            setState(() {});
          },
          children: [
            WelcomePage(
              hasExistingData: calculations != null,
              onFirstTimeStart:
                  () => _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
              onReturningUser:
                  () => _pageController.animateToPage(
                    2, // Navigate to ResultsPage
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
            ),

            FormPage(
              ageStarted: ageStarted,
              currentAge: currentAge,
              packsPerDay: packsPerDay,
              costPerPack: costPerPack,
              currency: currency,
              onAgeStartedChanged:
                  (value) => setState(() => ageStarted = value),
              onCurrentAgeChanged:
                  (value) => setState(() => currentAge = value),
              onPacksPerDayChanged:
                  (value) => setState(() => packsPerDay = value),
              onCostPerPackChanged:
                  (value) => setState(() => costPerPack = value),
              onCurrencyChanged: (value) => setState(() => currency = value),
              onCalculate: _calculateStats,
            ),
            if (calculations != null)
              ResultsPage(
                calculations: calculations!,
                currency: currency,
                smokeFreeDays: smokeFreeDays,
                onAddDay: () {
                  setState(() => smokeFreeDays++);
                  PreferencesService.saveData(
                    ageStarted: ageStarted,
                    currentAge: currentAge,
                    packsPerDay: packsPerDay,
                    costPerPack: costPerPack,
                    currency: currency,
                    smokeFreeDays: smokeFreeDays,
                    calculations: calculations,
                  );
                },
                onBreakStreak: () {
                  setState(() => smokeFreeDays = 0);
                  PreferencesService.saveData(
                    ageStarted: ageStarted,
                    currentAge: currentAge,
                    packsPerDay: packsPerDay,
                    costPerPack: costPerPack,
                    currency: currency,
                    smokeFreeDays: smokeFreeDays,
                    calculations: calculations,
                  );
                },
                onRecalculate: () {
                  print(
                    'Recalculate button pressed in home page',
                  ); // Debug print
                  // Navigate back to form page to allow user to modify values and recalculate
                  _pageController
                      .animateToPage(
                        1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                      .then((_) {
                        print(
                          'Navigation to form page completed',
                        ); // Debug print
                      });
                },
                showBreakStreakWarning: _showBreakStreakWarning,
              ),
          ],
        ),
      ),
    );
  }
}
