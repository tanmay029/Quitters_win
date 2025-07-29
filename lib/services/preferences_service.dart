import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<void> saveData({
    required String ageStarted,
    required String currentAge,
    required String packsPerDay,
    required String costPerPack,
    required String currency,
    required int smokeFreeDays,
    Map<String, dynamic>? calculations,
  }) async {
    final prefs = await _prefs;
    await prefs.setString('ageStarted', ageStarted);
    await prefs.setString('currentAge', currentAge);
    await prefs.setString('packsPerDay', packsPerDay);
    await prefs.setString('costPerPack', costPerPack);
    await prefs.setString('currency', currency);
    await prefs.setInt('smokeFreeDays', smokeFreeDays);

    if (calculations != null) {
      final calculationsString = calculations.entries
          .map((e) => '${e.key}:${e.value}')
          .join(',');
      await prefs.setString('calculations', calculationsString);
    }
  }

  static Future<Map<String, dynamic>> loadData() async {
    final prefs = await _prefs;
    final Map<String, dynamic>? savedCalculations =
        prefs.getString('calculations') != null
            ? Map<String, dynamic>.from(
              Map<String, dynamic>.from(
                prefs
                    .getString('calculations')!
                    .split(',')
                    .map((e) {
                      final parts = e.split(':');
                      return MapEntry(parts[0], int.parse(parts[1]));
                    })
                    .toList()
                    .asMap()
                    .map((_, e) => e),
              ),
            )
            : null;

    return {
      'ageStarted': prefs.getString('ageStarted') ?? '',
      'currentAge': prefs.getString('currentAge') ?? '',
      'packsPerDay': prefs.getString('packsPerDay') ?? '',
      'costPerPack': prefs.getString('costPerPack') ?? '',
      'currency': prefs.getString('currency') ?? 'INR',
      'smokeFreeDays': prefs.getInt('smokeFreeDays') ?? 0,
      'calculations': savedCalculations,
    };
  }
}
