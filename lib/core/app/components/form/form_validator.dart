import 'package:flutter/widgets.dart';

class ValidationBuilder {
  ValidationBuilder._() : validations = [];

  final List<FormFieldValidator<Object>> validations;

  static FormFieldValidator<Object> create(
    ValidationBuilder Function(ValidationBuilder builder) cb,
  ) {
    return cb(ValidationBuilder._()).build();
  }

  static ValidationMessages messages = const DefaultValidationMessages();

  void _add(FormFieldValidator<Object> validator) {
    validations.add(validator);
  }

  void required([String? message]) {
    return _add((Object? v) {
      final result = switch (v) {
        null => true,
        String() => v.isEmpty,
        Iterable() => v.isEmpty,
        _ => false,
      };

      if (result) return message ?? messages.required;

      return null;
    });
  }

  void maxLength(int maxLength, [String? message]) {
    _add((Object? v) {
      if (v == null) return null;
      if (v is! String) throw ArgumentError.value(v);

      return v.length > maxLength ? messages.format : null;
    });
  }

  void url([String? message]) {
    return regExp(RegExp(r'^https?://.*$'), message ?? messages.url);
  }

  void email([String? message]) {
    return regExp(
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
      message ?? messages.format,
    );
  }

  void regExp(RegExp regExp, [String? message]) {
    return _add((Object? v) {
      if (v == null) return null;
      if (v is! String) return null;
      return regExp.hasMatch(v) ? '無効なフォーマットです' : null;
    });
  }

  void integer([String? message]) {
    return _add((Object? v) {
      if (v == null) return null;
      if (v is! String) throw ArgumentError.value(v);

      return int.tryParse(v) == null ? messages.number : null;
    });
  }

  void double([String? message]) {
    return _add((Object? v) {
      if (v == null) return null;
      if (v is! String) throw ArgumentError.value(v);

      return num.tryParse(v) == null ? messages.number : null;
    });
  }

  FormFieldValidator<Object> build() {
    return test;
  }

  String? test(Object? value) {
    for (final validation in validations) {
      final result = validation(value);
      if (result != null) return result;
    }

    return null;
  }
}

class DefaultValidationMessages implements ValidationMessages {
  const DefaultValidationMessages();

  @override
  String get format => '無効なフォーマットです';

  @override
  String maxLength(int maxLength) => '最大長が $maxLength 文字を超えています';

  @override
  String min(num number) => '最小値が $number 未満です';

  @override
  String get number => '数値ではありません';

  @override
  String get required => '必須項目です';

  @override
  String get url => 'URLではありません';
}

abstract interface class ValidationMessages {
  String get required;
  String get number;
  String get format;
  String get url;
  String min(num number);
  String maxLength(int maxLength);
}
