import 'package:app/core/app/components/form/form_listener.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

abstract class CustomFormBase<InitialValue> extends StatefulWidget {
  const CustomFormBase({
    super.key,
    this.initialValue,
    this.listener,
    this.onChanged,
  });

  final InitialValue? initialValue;
  final FormListener? listener;
  final VoidCallback? onChanged;

  @override
  CustomFormBaseState<InitialValue> createState();
}

abstract class CustomFormBaseState<InitialValue>
    extends State<CustomFormBase<InitialValue>>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();

  InitialValue? get initialValue => widget.initialValue;

  @protected
  FormState get formState => _formKey.currentState!;

  bool get isEditing => widget.initialValue != null;

  bool isValid = false;

  void onChanged() {
    setState(() {
      isValid = validate();
      isDirty = true;
    });
    widget.listener?.onChanged();
  }

  /// initState で必ず実行される。
  /// controller の初期化や、初期値の代入に使用。
  @visibleForOverriding
  void applyDefault();

  @visibleForOverriding
  bool validate();

  @visibleForOverriding
  Widget builder(BuildContext context);

  bool get canPop => true;
  PopInvokedWithResultCallback<Object?>? get onPopInvokedWithResult => null;

  bool isDirty = false;

  @override
  void didUpdateWidget(covariant CustomFormBase<InitialValue> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.listener != oldWidget.listener) {
      widget.listener?.attach(this);
    }
  }

  @override
  void initState() {
    super.initState();

    applyDefault();
    widget.listener?.attach(this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Form(
      key: _formKey,
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      onChanged: onChanged,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: builder(context),
      ),
    );
  }
}
