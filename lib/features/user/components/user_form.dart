import 'package:app/core/app/components/form/custom_form_base.dart';
import 'package:app/core/app/components/form/field_decorator.dart';
import 'package:app/core/app/components/form/image/image_field_value.dart';
import 'package:app/core/app/components/form/image/image_form_field.dart';
import 'package:app/features/user/models/user.dart';
import 'package:flutter/material.dart';

class UserForm extends CustomFormBase<User> {
  const UserForm({
    super.key,
    required super.initialValue,
    super.listener,
    super.onChanged,
  });

  @override
  CustomFormBaseState<User> createState() => UserFormState();
}

class UserFormState extends CustomFormBaseState<User> {
  final _avatarKey = GlobalKey<FormFieldState<List<ImageFieldValue>>>();

  ImageFieldValue? get avatar => _avatarKey.currentState?.value?.firstOrNull;

  late final TextEditingController _nameController;

  String get name => _nameController.text;

  @override
  void applyDefault() {
    _nameController = TextEditingController(text: initialValue?.name);
  }

  @override
  Widget builder(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        ImageFormField(
          key: _avatarKey,
          fixedAspectRatio: 1,
          initialValue: initialValue?.avatarPath != null
              ? [ImageFieldValue.storagePath(initialValue!.avatarPath!)]
              : [],
        ),
        SizedBox(height: 24),
        FieldDecorator(
          label: Text('名前'),
          child: TextFormField(
            controller: _nameController,
          ),
        ),
      ],
    );
  }

  @override
  bool validate() {
    return true;
  }
}
