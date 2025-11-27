import 'package:app/core/app/components/form/select/single_select_field.dart';
import 'package:flutter/material.dart';

export 'single_select_field.dart';

class SingleSelectFormField<T> extends FormField<SingleSelectValue<T>> {
  SingleSelectFormField({
    super.key,
    super.validator,
    super.initialValue,
    InputDecoration? decoration,
    Widget? modalTitle,
    required List<SingleSelectValue<T>> values,
  }) : super(
         builder: (field) => SingleSelectField(
           modalTitle: modalTitle,
           value: field.value,
           onChanged: (value) => field.didChange(value),
           decoration: (decoration ?? InputDecoration()).copyWith(
             errorText: field.errorText,
           ),
           values: values,
         ),
       );
}
