import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.decoration,
    this.firstDate,
    this.lastDate,
    this.format = defaultFormat,
  });

  final DateTime? value;
  final String Function(DateTime) format;
  final InputDecoration? decoration;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  static String defaultFormat(DateTime date) {
    return DateFormat.yMEd().format(date);
  }

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
        final selectedDateTime = await showDatePicker(
          context: context,
          initialDate: value ?? clock.now(),
          locale: Locale(Intl.defaultLocale?.split('_').first ?? 'ja'),
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
        );

        if (selectedDateTime != null) {
          onChanged(selectedDateTime);
        }
      },
      child: InputDecorator(
        decoration: effectiveDecoration,
        isEmpty: value == null,
        child: Text(value != null ? format(value!) : ''),
      ),
    );
  }
}
