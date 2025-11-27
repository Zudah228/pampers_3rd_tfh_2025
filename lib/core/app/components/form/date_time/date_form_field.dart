import 'package:app/core/app/components/form/date_time/date_field.dart';
import 'package:flutter/material.dart';

class DateFormField extends FormField<DateTime> {
  DateFormField({
    super.key,
    super.validator,
    super.initialValue,
    InputDecoration? decoration,
    DateTime? firstDate,
    DateTime? lastDate,
    String Function(DateTime)? format = DateField.defaultFormat,
  }) : super(
         builder: (field) => DateField(
           value: field.value,
           onChanged: (value) => field.didChange(value),
           decoration: (decoration ?? InputDecoration()).copyWith(
             errorText: field.errorText,
           ),
           firstDate: firstDate,
           lastDate: lastDate,
           format: format ?? DateField.defaultFormat,
         ),
       );
}
