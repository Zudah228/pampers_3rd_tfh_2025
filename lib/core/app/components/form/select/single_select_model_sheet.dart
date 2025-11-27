import 'package:app/core/app/components/bottom_sheet/selection_bottom_sheet.dart';
import 'package:app/core/app/components/form/select/single_select_field.dart';
import 'package:flutter/material.dart';

Future<SingleSelectValue<T>?> showSingleSelectModalSheet<T>({
  required BuildContext context,
  required List<SingleSelectValue<T>> values,
  bool isScrollControlled = false,
  SingleSelectValue<T>? initialValue,
  Widget? title,
}) {
  return showModalBottomSheet<SingleSelectValue<T>>(
    context: context,
    isScrollControlled: isScrollControlled,
    builder: (context) => SingleSelectModelSheet._(
      title: title,
      initialValue: initialValue,
      values: values,
    ),
  );
}

class SingleSelectModelSheet<T> extends StatelessWidget {
  const SingleSelectModelSheet._({
    this.title,
    this.initialValue,
    required this.values,
  });

  final Widget? title;
  final SingleSelectValue<T>? initialValue;
  final List<SingleSelectValue<T>> values;

  @override
  Widget build(BuildContext context) {
    return SelectionBottomSheet(
      title: title,
      itemCount: values.length,
      itemBuilder: (context, index) {
        final value = values[index];

        return ListTile(
          trailing: initialValue?.value == value.value
              ? Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                )
              : SizedBox.shrink(),
          title: Text(value.label),
          onTap: () {
            Navigator.of(context).pop(value);
          },
        );
      },
    );
  }
}
