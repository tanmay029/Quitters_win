import 'package:flutter/material.dart';
import '../utils/form_validation.dart';

class FormPage extends StatelessWidget {
  final String ageStarted;
  final String currentAge;
  final String packsPerDay;
  final String costPerPack;
  final String currency;
  final Function(String) onAgeStartedChanged;
  final Function(String) onCurrentAgeChanged;
  final Function(String) onPacksPerDayChanged;
  final Function(String) onCostPerPackChanged;
  final Function(String) onCurrencyChanged;
  final VoidCallback onCalculate;

  const FormPage({
    Key? key,
    required this.ageStarted,
    required this.currentAge,
    required this.packsPerDay,
    required this.costPerPack,
    required this.currency,
    required this.onAgeStartedChanged,
    required this.onCurrentAgeChanged,
    required this.onPacksPerDayChanged,
    required this.onCostPerPackChanged,
    required this.onCurrencyChanged,
    required this.onCalculate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show warning dialog when user tries to go back
        final shouldPop = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                  'Your progress will be lost if you go back.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Stay'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Go Back'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
        );
        return shouldPop ?? false;
      },
      child: Center(
        child: Container(
          color: const Color(0xFFFDFBF7),
          child: SafeArea(
            minimum: const EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Card(
                color: const Color(0xFFF4F1EC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Tell us about your smoking history',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF264653),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      // Age fields with initial values
                      Column(
                        children: [
                          TextFormField(
                            initialValue: ageStarted,
                            decoration: InputDecoration(
                              labelText: 'Age when you started smoking',
                              hintText: 'e.g., 18',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorText:
                                  ageStarted.isNotEmpty
                                      ? FormValidation.getAgeError(ageStarted)
                                      : null,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: onAgeStartedChanged,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: currentAge,
                            decoration: InputDecoration(
                              labelText: 'Your current age',
                              hintText: 'e.g., 30',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorText:
                                  currentAge.isNotEmpty
                                      ? FormValidation.getAgeError(currentAge)
                                      : null,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: onCurrentAgeChanged,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: packsPerDay,
                        decoration: InputDecoration(
                          labelText: 'Packs per day',
                          hintText: 'e.g., 1.5',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText:
                              packsPerDay.isNotEmpty &&
                                      !FormValidation.isValidPacksPerDay(
                                        packsPerDay,
                                      )
                                  ? 'Enter a valid number (0.1–10)'
                                  : null,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: onPacksPerDayChanged,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Currency',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              value: currency,
                              items: const [
                                DropdownMenuItem(
                                  value: 'INR',
                                  child: Text('INR (₹)'),
                                ),
                                DropdownMenuItem(
                                  value: 'USD',
                                  child: Text('USD (\$)'),
                                ),
                              ],
                              onChanged: (value) => onCurrencyChanged(value!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              initialValue: costPerPack,
                              decoration: InputDecoration(
                                labelText: 'Cost per pack ($currency)',
                                hintText:
                                    currency == 'INR' ? 'e.g., 150' : 'e.g., 8',
                                prefixText: currency == 'INR' ? '₹' : '\$',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText:
                                    costPerPack.isNotEmpty &&
                                            !FormValidation.isValidCostPerPack(
                                              costPerPack,
                                            )
                                        ? 'Enter a valid amount'
                                        : null,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              onChanged: onCostPerPackChanged,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              (FormValidation.isValidAge(ageStarted) &&
                                      FormValidation.isValidAge(currentAge) &&
                                      int.parse(currentAge) >
                                          int.parse(ageStarted) &&
                                      FormValidation.isValidPacksPerDay(
                                        packsPerDay,
                                      ) &&
                                      FormValidation.isValidCostPerPack(
                                        costPerPack,
                                      ))
                                  ? () {
                                    print(
                                      'Calculate button pressed from form',
                                    ); // Debug print
                                    onCalculate();
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D9C8A),
                            disabledBackgroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Calculate My Smoking Impact',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
