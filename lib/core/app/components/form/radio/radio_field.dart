import 'package:flutter/material.dart';

class RadioValue<T> {
  const RadioValue({required this.value, required this.label});

  final T value;
  final String label;
}

class RadioField<T> extends StatelessWidget {
  const RadioField({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.values,
    this.errorText,
  });

  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final List<RadioValue<T>> values;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioGroup(
          groupValue: groupValue,
          onChanged: onChanged,
          child: Wrap(
            spacing: 16,
            children: values
                .map(
                  (value) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                        value: value.value,
                        toggleable: true,
                      ),
                      Text(value.label),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsetsGeometry.directional(start: 16),
            child: Text(
              errorText!,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
