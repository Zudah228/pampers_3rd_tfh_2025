import 'package:app/core/app/components/button/tertiary_button.dart';
import 'package:app/core/app/components/expanded_single_child_scroll_view.dart';
import 'package:app/core/app/components/form/hooks/use_form_listener.dart';
import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/features/debug_form/components/debug_form.dart';
import 'package:app/features/debug_form/models/debug_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DebugFormPage extends HookWidget {
  const DebugFormPage._();

  static const routeName = '/debug_form';

  static Route<void> route() {
    return RouteAnimations.swipeBack<void>(
      fullscreenDialog: true,
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugFormPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listener = useFormListener<DebugFormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('フォーム'),
        actions: [
          TertiaryButton(
            onPressed: listener.isValid
                ? () {
                    Navigator.of(context).pop();
                  }
                : null,
            child: const Text('保存'),
          ),
        ],
      ),
      body: ExpandedSingleChildScrollView(
        padding: const .symmetric(horizontal: 16),
        child: DebugForm(
          listener: listener,
          initialValue: const DebugFormModel(
            name: '田中太郎',
            email: '',
            password: 'パスワード',
            gender: DebugModelGender.male,
          ),
        ),
      ),
    );
  }
}
