import 'package:app/core/app/components/form/image/image_field.dart';
import 'package:flutter/material.dart';

import 'image_field_value.dart';

class ImageFormField extends FormField<List<ImageFieldValue>> {
  ImageFormField({
    super.key,
    super.initialValue,
    ValueChanged<List<ImageFieldValue>>? validator,
    int maxCount = 1,
    double? fixedAspectRatio,
    Widget? addButton,
  }) : super(
         builder: (field) => ImageField(
           value: field.value ?? [],
           onChanged: (value) => field.didChange(value),
           maxCount: maxCount,
           fixedAspectRatio: fixedAspectRatio,
           addButton: addButton,
         ),
       );
}
