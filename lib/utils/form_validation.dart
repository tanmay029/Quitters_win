class FormValidation {
  static bool isValidAge(String value) {
    if (value.isEmpty) return false;
    final age = int.tryParse(value);
    return age != null && age > 0 && age <= 120;
  }

  static bool isValidPacksPerDay(String value) {
    if (value.isEmpty) return false;
    final packs = double.tryParse(value);
    return packs != null && packs > 0 && packs <= 10;
  }

  static bool isValidCostPerPack(String value) {
    if (value.isEmpty) return false;
    final cost = double.tryParse(value);
    return cost != null && cost > 0;
  }

  static String? getAgeError(String value) {
    if (value.isEmpty) return 'Age is required';
    if (!isValidAge(value)) return 'Enter a valid age (1-120)';
    return null;
  }
}
