import 'package:flutter/material.dart';

class SmokingCalculations {
  static Map<String, dynamic> calculateStats({
    required String ageStarted,
    required String currentAge,
    required String packsPerDay,
    required String costPerPack,
  }) {
    final yearsSmoked = int.parse(currentAge) - int.parse(ageStarted);
    final totalDays = yearsSmoked * 365;
    final totalPacks = totalDays * double.parse(packsPerDay);
    final totalCost = totalPacks * double.parse(costPerPack);
    final cigarettesPerPack = 20;
    final totalCigarettes = totalPacks * cigarettesPerPack;

    return {
      'yearsSmoked': yearsSmoked,
      'totalDays': totalDays,
      'totalPacks': totalPacks.round(),
      'totalCost': totalCost.round(),
      'totalCigarettes': totalCigarettes.round(),
    };
  }

  static List<Map<String, dynamic>> getAlternativePurchases(
    int totalCost,
    String currency,
  ) {
    List<Map<String, dynamic>> alternatives = [];

    final prices =
        currency == 'INR'
            ? {'movie': 300, 'smartphone': 25000, 'car': 500000, 'coffee': 50}
            : {'movie': 15, 'smartphone': 800, 'car': 25000, 'coffee': 5};

    if (totalCost >= prices['coffee']!) {
      alternatives.add({
        'item': 'Coffee cups',
        'quantity': (totalCost / prices['coffee']!).floor(),
        'icon': Icons.coffee,
      });
    }

    if (totalCost >= prices['movie']!) {
      alternatives.add({
        'item': 'Movie tickets',
        'quantity': (totalCost / prices['movie']!).floor(),
        'icon': Icons.movie,
      });
    }

    if (totalCost >= prices['smartphone']!) {
      alternatives.add({
        'item': 'Smartphones',
        'quantity': (totalCost / prices['smartphone']!).floor(),
        'icon': Icons.smartphone,
      });
    }

    if (totalCost >= prices['car']!) {
      alternatives.add({
        'item': 'Cars',
        'quantity': (totalCost / prices['car']!).floor(),
        'icon': Icons.directions_car,
      });
    }

    return alternatives;
  }
}
