import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../utils/number_formatter.dart';
import '../utils/smoking_calculations.dart';

class ResultsPage extends StatelessWidget {
  final Map<String, dynamic> calculations;
  final String currency;
  final int smokeFreeDays;
  final VoidCallback onAddDay;
  final VoidCallback onBreakStreak;
  final VoidCallback onRecalculate;
  final VoidCallback showBreakStreakWarning;

  const ResultsPage({
    Key? key,
    required this.calculations,
    required this.currency,
    required this.smokeFreeDays,
    required this.onAddDay,
    required this.onBreakStreak,
    required this.onRecalculate,
    required this.showBreakStreakWarning,
  }) : super(key: key);

  
  String formatIndianNumber(int number) {
    String numStr = number.toString();
    if (numStr.length <= 3) {
      return numStr;
    }

    String result = '';
    int length = numStr.length;

    
    result = numStr.substring(length - 3);
    int remaining = length - 3;

    
    while (remaining > 0) {
      int start = remaining >= 2 ? remaining - 2 : 0;
      result = numStr.substring(start, remaining) + ',' + result;
      remaining = start;
    }

    return result;
  }


  String formatNumberByLocale(int number, String currency) {
    if (currency == 'INR') {
      return formatIndianNumber(number);
    } else {
      
      return formatNumber(number, currency);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alternatives = SmokingCalculations.getAlternativePurchases(
      calculations['totalCost'],
      currency,
    );
    final currencySymbol = currency == 'INR' ? '₹' : '\$';

    return Container(
      color: const Color(0xFFFDFBF7),
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  StatCard(
                    title: 'Years Smoked',
                    value: '${calculations['yearsSmoked']}',
                    icon: Icons.access_time,
                    color: const Color(0xFF264653),
                  ),
                  StatCard(
                    title: 'Total Cigarettes',
                    value: formatNumberByLocale(
                      calculations['totalCigarettes'] as int,
                      currency,
                    ),
                    icon: Icons.smoking_rooms,
                    color: const Color(0xFFE76F51),
                  ),
                  StatCard(
                    title: 'Total Packs',
                    value: formatNumberByLocale(
                      calculations['totalPacks'] as int,
                      currency,
                    ),
                    icon: Icons.inventory_2,
                    color: Colors.amber.shade600,
                  ),
                  StatCard(
                    title: 'Money Spent',
                    value:
                        '$currencySymbol${formatNumberByLocale(calculations['totalCost'] as int, currency)}',
                    icon: Icons.money,
                    color: const Color(0xFF2D9C8A),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildAlternativesCard(alternatives, currency),
              const SizedBox(height: 20),
              _buildSmokeFreeDaysCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlternativesCard(
    List<Map<String, dynamic>> alternatives,
    String currency,
  ) {
    return Card(
      color: const Color(0xFFF4F1EC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'What you could have bought instead:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF264653),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: alternatives.length,
              itemBuilder: (context, index) {
                final alt = alternatives[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(alt['icon'], color: Color(0xFF2D9C8A), size: 40),
                      const SizedBox(height: 8),
                      Text(
                        formatNumberByLocale(alt['quantity'] as int, currency),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF264653),
                        ),
                      ),
                      Text(
                        alt['item'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmokeFreeDaysCard(BuildContext context) {
    return Card(
      color: const Color(0xFFF4F1EC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Your Smoke-Free Journey',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF264653),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFCCEAE6),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$smokeFreeDays',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D9C8A),
                    ),
                  ),
                  const Text(
                    'Days',
                    style: TextStyle(fontSize: 16, color: Color(0xFF2D9C8A)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Smoke-Free Streak',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('Add Day button pressed'); // Debug print
                    onAddDay();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D9C8A),
                  ),
                  child: const Text(
                    '+ Add Day',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Break Streak button pressed'); // Debug print
                    showBreakStreakWarning();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE76F51),
                  ),
                  child: const Text(
                    'Break Streak',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                print('Recalculate Stats button pressed'); // Debug print
                onRecalculate();
              },
              child: const Text(
                'Recalculate Stats',
                style: TextStyle(color: Color(0xFF264653)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
