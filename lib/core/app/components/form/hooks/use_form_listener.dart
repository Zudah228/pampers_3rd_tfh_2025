import 'package:app/core/app/components/form/custom_form_base.dart';
import 'package:app/core/app/components/form/form_listener.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

FormListener<T> useFormListener<T extends CustomFormBaseState<dynamic>>() {
  final listener = use(_FormListerHook<T>());

  useListenable(listener);

  return listener;
}

class _FormListerHook<T extends CustomFormBaseState<dynamic>>
    extends Hook<FormListener<T>> {
  @override
  HookState<FormListener<T>, Hook<FormListener<T>>> createState() {
    return _FormListerHookState();
  }
}

class _FormListerHookState<T extends CustomFormBaseState<dynamic>>
    extends HookState<FormListener<T>, Hook<FormListener<T>>> {
  late FormListener<T> _listener;

  @override
  void initHook() {
    super.initHook();

    _listener = FormListener();
  }

  @override
  FormListener<T> build(BuildContext context) {
    return _listener;
  }
}
