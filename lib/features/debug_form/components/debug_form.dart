import 'package:app/core/app/components/dialog/confirm_dialog.dart';
import 'package:app/core/app/components/form/custom_form_base.dart';
import 'package:app/core/app/components/form/date_time/date_form_field.dart';
import 'package:app/core/app/components/form/field_decorator.dart';
import 'package:app/core/app/components/form/form_validator.dart';
import 'package:app/core/app/components/form/obscure_toggle_button.dart';
import 'package:app/core/app/components/form/radio/radio_form_field.dart';
import 'package:app/core/app/components/form/select/single_select_form_field.dart';
import 'package:app/core/utils/prefectures.dart';
import 'package:app/features/debug_form/models/debug_form_model.dart';
import 'package:flutter/material.dart';

class DebugForm extends CustomFormBase<DebugFormModel> {
  const DebugForm({
    super.key,
    required super.initialValue,
    required super.listener,
  });

  @override
  CustomFormBaseState<DebugFormModel> createState() => DebugFormState();
}

class DebugFormState extends CustomFormBaseState<DebugFormModel> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _genderFieldKey = GlobalKey<FormFieldState<DebugModelGender>>();
  final _prefectureFieldKey =
      GlobalKey<FormFieldState<SingleSelectValue<String>>>();

  bool _obscurePassword = true;

  String get name => _nameController.text;
  String get email => _emailController.text;
  String get password => _passwordController.text;

  @override
  void applyDefault() {
    _nameController = TextEditingController(text: initialValue?.name);
    _emailController = TextEditingController(text: initialValue?.email);
    _passwordController = TextEditingController(text: initialValue?.password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        const SizedBox(height: 16),
        FieldDecorator(
          label: Text('名前'),
          showRequiredLabel: true,
          child: TextFormField(
            controller: _nameController,
            validator: ValidationBuilder.create(
              (builder) => builder..required(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        FieldDecorator(
          label: Text('メールアドレス'),
          showRequiredLabel: true,
          child: TextFormField(
            controller: _emailController,
            validator: ValidationBuilder.create(
              (builder) => builder
                ..email()
                ..required(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        FieldDecorator(
          label: Text('パスワード'),
          showRequiredLabel: true,
          child: TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              suffixIcon: Padding(
                padding: const .only(right: 8),
                child: ObscureToggleButton(
                  obscureText: _obscurePassword,
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            validator: ValidationBuilder.create(
              (builder) => builder..required(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        FieldDecorator(
          label: Text('性別'),
          showRequiredLabel: true,
          child: RadioFormField<DebugModelGender>(
            key: _genderFieldKey,
            initialValue: initialValue?.gender,
            validator: ValidationBuilder.create(
              (builder) => builder..required(),
            ),
            values: [
              RadioValue(value: DebugModelGender.male, label: '男性'),
              RadioValue(value: DebugModelGender.female, label: '女性'),
              RadioValue(value: DebugModelGender.other, label: 'その他'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FieldDecorator(
          label: Text('都道府県'),
          child: SingleSelectFormField<String>(
            key: _prefectureFieldKey,
            decoration: InputDecoration(
              hintText: '都道府県を選択',
            ),
            values: prefectures
                .map(
                  (prefecture) =>
                      SingleSelectValue(value: prefecture, label: prefecture),
                )
                .toList(),
            initialValue: SingleSelectValue.fromValue(
              initialValue?.prefecture,
            ),
          ),
        ),
        const SizedBox(height: 24),
        FieldDecorator(
          label: Text('生年月日'),
          child: DateFormField(
            initialValue: initialValue?.birthday,
          ),
        ),
      ],
    );
  }

  @override
  bool validate() {
    return formState.validate();
  }

  @override
  bool get canPop => !isDirty;

  @override
  PopInvokedWithResultCallback<Object?>? get onPopInvokedWithResult =>
      (didPop, result) async {
        if (didPop) {
          return;
        }

        if (isDirty) {
          final confirmed = await showConfirmDialog(
            context,
            title: Text('変更内容は破棄されます'),
          );

          if (confirmed && mounted) {
            Navigator.of(context).pop(result);
            return;
          }
        }
      };
}
