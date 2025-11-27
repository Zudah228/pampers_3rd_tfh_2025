import 'package:app/core/app/components/form/custom_form_base.dart';
import 'package:flutter/widgets.dart';

class FormListener<T extends CustomFormBaseState<dynamic>> with ChangeNotifier {
  T? _state;

  T get state => _state!;
  T? get stateOrNull => _state;

  void attach(T state) {
    _state = state;
  }

  void onChanged() {
    notifyListeners();
  }

  bool get isValid => _state?.isValid ?? false;
}
