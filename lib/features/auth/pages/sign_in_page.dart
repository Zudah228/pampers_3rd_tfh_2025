import 'package:app/core/app/components/bottom_sheet/bottom_sheet_scaffold.dart';
import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/button/secondary_button.dart';
import 'package:app/core/app/components/form/field_decorator.dart';
import 'package:app/core/app/components/form/form_validator.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/components/unfocused_gesture_detecter.dart';
import 'package:app/features/auth/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage._();

  static const routeName = '/sign_in';

  static Route<void> route() {
    return ModalBottomSheetRoute<void>(
      isScrollControlled: true,
      useSafeArea: true,
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SignInPage._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return UnfocusedGestureDetecter(
      child: BottomSheetScaffold(
        title: Text('ログイン'),
        child: Padding(
          padding: .symmetric(horizontal: 16),
          child: SafeArea(
            minimum: EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: .min,
              children: [
                FieldDecorator(
                  label: Text('メールアドレス'),
                  child: TextFormField(
                    controller: emailController,
                    validator: ValidationBuilder.create(
                      (builder) => builder
                        ..email()
                        ..required(),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                FieldDecorator(
                  label: Text('パスワード'),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: ValidationBuilder.create(
                      (builder) => builder..required(),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton.large(
                        child: Text('登録'),
                        onPressed: () {
                          FullScreenLoadingIndicator.show(() async {
                            await ref
                                .read(currentUserProvider.notifier)
                                .signUp(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
      
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: PrimaryButton.large(
                        child: Text('ログイン'),
                        onPressed: () {
                          FullScreenLoadingIndicator.show(() async {
                            await ref
                                .read(currentUserProvider.notifier)
                                .signIn(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
      
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
