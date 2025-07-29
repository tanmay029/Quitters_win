String formatNumber(int number, String currency) {
  if (currency == 'INR') {
    // Indian number system (e.g., 1,50,000)
    String num = number.toString();
    String result = '';
    int count = 0;
    for (int i = num.length - 1; i >= 0; i--) {
      if (count == 3 && result.isEmpty) {
        result = ',' + result;
        count = 0;
      } else if (count == 2 && result.isNotEmpty) {
        result = ',' + result;
        count = 0;
      }
      result = num[i] + result;
      count++;
    }
    return result;
  } else {
    // International number system (e.g., 150,000)
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
