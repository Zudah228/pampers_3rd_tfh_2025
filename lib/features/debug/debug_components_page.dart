import 'package:app/core/app/components/button/error_button.dart';
import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/button/secondary_button.dart';
import 'package:app/core/app/components/button/tertiary_button.dart';
import 'package:app/core/app/components/dialog/dialog.dart';
import 'package:app/core/app/components/form/field_decorator.dart';
import 'package:app/core/app/components/form/radio/radio_form_field.dart';
import 'package:app/core/app/components/form/select/single_select_form_field.dart';
import 'package:app/core/app/components/snack_bar.dart';
import 'package:app/core/app/components/unfocused_gesture_detecter.dart';
import 'package:flutter/material.dart';

class DebugComponentsPage extends StatelessWidget {
  const DebugComponentsPage._();

  static const routeName = '/debug_components';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugComponentsPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('コンポーネント一覧'),
      ),
      body: UnfocusedGestureDetecter(
        child: Padding(
          padding: const .symmetric(horizontal: 16),
          child: ListView(
            children: [
              // Button
              _Headline(child: Text('Button')),
              Wrap(
                spacing: 16,
                children: [
                  PrimaryButton(
                    child: const Text('Primary Button'),
                    onPressed: () {},
                  ),
                  SecondaryButton(
                    child: const Text('Secondary Button'),
                    onPressed: () {},
                  ),
                  TertiaryButton(
                    child: const Text('Tertiary Button'),
                    onPressed: () {},
                  ),
                ],
              ),

              // Input Field
              _Headline(child: Text('Input Field')),
              FieldDecorator(
                label: Text('Text Field'),
                child: TextFormField(),
              ),
              SizedBox(height: 16),
              FieldDecorator(
                label: Text('Select Field'),
                child: SingleSelectFormField<int>(
                  modalTitle: Text('Select number'),
                  values: [
                    for (var i in _fakeNumbers)
                      SingleSelectValue(value: i, label: i.toString()),
                  ],
                ),
              ),
              SizedBox(height: 16),
              FieldDecorator(
                label: Text('Radio Field'),
                child: RadioFormField<int>(
                  values: [
                    for (var i in _fakeNumbers)
                      RadioValue(value: i, label: i.toString()),
                  ],
                ),
              ),

              // Dialog
              _Headline(child: Text('Dialog')),
              PrimaryButton(
                child: const Text('Show Dialog'),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => CommonDialog(
                      title: Text('Dialog'),
                      content: Text('Dialog content'),
                      primaryAction: CommonDialogAction(
                        label: 'OK',
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SecondaryButton(
                child: const Text('Show Snackbar'),
                onPressed: () {
                  showSnackBar(message: 'Snackbar');
                },
              ),
              SizedBox(height: 16),
              ErrorButton(
                child: const Text('Show Error Snackbar'),
                onPressed: () {
                  showErrorSnackBar(message: 'Error Snackbar');
                },
              ),

              // Card
              _Headline(child: Text('Card')),
              Card(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      color: themeData.colorScheme.primaryContainer,
                      padding: const .all(16),
                      child: FlutterLogo(),
                    ),
                    SizedBox(height: 16),
                    Text('Card'),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

const _fakeNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

class _Headline extends StatelessWidget {
  const _Headline({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(top: 24, bottom: 4),
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.titleLarge,
        child: child,
      ),
    );
  }
}
