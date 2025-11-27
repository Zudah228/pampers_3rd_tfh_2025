import 'package:app/core/app/components/form/select/single_select_model_sheet.dart';
import 'package:flutter/material.dart';

class SingleSelectValue<T> {
  const SingleSelectValue({required this.value, required this.label});

  static SingleSelectValue<T>? fromValue<T>(
    T? value, [
    String Function(T)? format,
  ]) {
    if (value == null) {
      return null;
    }
    return SingleSelectValue(
      value: value,
      label: format?.call(value) ?? value.toString(),
    );
  }

  final T value;
  final String label;
}

class SingleSelectField<T> extends StatelessWidget {
  const SingleSelectField({
    super.key,
    this.modalTitle,
    this.value,
    required this.onChanged,
    required this.values,
    this.decoration,
  });

  final Widget? modalTitle;
  final SingleSelectValue<T>? value;
  final List<SingleSelectValue<T>> values;
  final ValueChanged<SingleSelectValue<T>> onChanged;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    var effectiveDecoration = decoration ?? InputDecoration();

    if (effectiveDecoration.suffixIcon == null) {
      effectiveDecoration = effectiveDecoration.copyWith(
        suffixIcon: Icon(Icons.arrow_drop_down),
      );
    }

    return InkWell(
      onTap: () async {
        final selectedValue = await showSingleSelectModalSheet<T>(
          context: context,
          values: values,
          initialValue: value,
          title: modalTitle,
        );

        if (selectedValue != null) {
          onChanged(selectedValue);
        }
      },
      child: InputDecorator(
        decoration: effectiveDecoration,
        isEmpty: value == null,
        child: Text(value?.label ?? ''),
      ),
    );
  }
}
