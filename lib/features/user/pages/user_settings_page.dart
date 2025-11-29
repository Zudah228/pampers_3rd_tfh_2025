import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/form/image/image_field_value.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/components/future/error.dart';
import 'package:app/core/app/components/future/future_switcher.dart';
import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/core/service/firebase_storage/firebase_storage_service.dart';
import 'package:app/core/service/firebase_storage/storage_paths.dart';
import 'package:app/features/auth/providers/current_user_provider.dart';
import 'package:app/features/user/components/user_form.dart';
import 'package:app/features/user/models/user.dart';
import 'package:app/features/user/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSettingsPage extends ConsumerWidget {
  const UserSettingsPage._();

  static const routeName = '/user_settings';

  static Route<void> route() {
    return RouteAnimations.swipeBack<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const UserSettingsPage._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalObjectKey<UserFormState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー設定'),
      ),
      body: FutureSwitcher(
        fetch: () => ref.watch(userProvider.future),
        builder: (data) {
          Future<void> save() async {
            FullScreenLoadingIndicator.show(() async {
              final state = formKey.currentState!;
              final image = state.avatar;
              final id = ref.read(currentUserProvider).id!;

              final avatarPath = switch (image) {
                null => null,
                StoragePathImageValue(:var path) => path,
                MemoryImageValue(:var memory) =>
                  await ref
                      .read(firebaseStorageServiceProvider)
                      .uploadImage(
                        StoragePaths.user_avatar(
                          id,
                        ),
                        memory,
                      ),
              };

              final newData = (data ?? User(id: id)).copyWith(
                name: state.name,
                avatarPath: avatarPath,
              );

              await ref.currentUserDocumentReference.set(
                newData,
                SetOptions(merge: true),
              );

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });
          }

          return Padding(
            padding: const .symmetric(horizontal: 16),
            child: Column(
              children: [
                UserForm(
                  key: formKey,
                  initialValue: data,
                ),
                SizedBox(height: 48),
                PrimaryButton.large(
                  onPressed: save,
                  child: Text('保存'),
                ),
              ],
            ),
          );
        },
        errorBuilder: ErrorInline.new,
      ),
    );
  }
}
