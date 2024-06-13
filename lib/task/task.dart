import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}

class Phone with ChangeNotifier, DiagnosticableTreeMixin {
  int _countPhone = 0;
  int get countPhone => _countPhone;

  void increment() {
    _countPhone++;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('countPhone', countPhone));
  }
}
