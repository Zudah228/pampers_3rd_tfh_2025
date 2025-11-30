import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/button/secondary_button.dart';
import 'package:app/core/app/components/form/image/image_field.dart';
import 'package:app/core/app/components/form/image/image_field_value.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/components/snack_bar.dart';
import 'package:app/core/service/firebase_functions/firebase_functions_service.dart';
import 'package:app/features/room/components/room_card.dart';
import 'package:app/features/room/providers/my_room_provider.dart';
import 'package:app/features/room/use_cases/compare_faces_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DebugCompareFacesPage extends HookConsumerWidget {
  const DebugCompareFacesPage._();

  static const routeName = '/debug_compare_faces';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugCompareFacesPage._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageNotifier = useState<ImageFieldValue?>(null);
    final data = switch (imageNotifier.value) {
      MemoryImageValue(:final memory) => memory,
      _ => null,
    };

    final myRoom = ref.watch(myRoomProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('顔比較を試す'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (myRoom != null) RoomCard(room: myRoom),
                ImageField(
                  value: [?imageNotifier.value],
                  onChanged: (images) {
                    imageNotifier.value = images.firstOrNull;
                  },
                  width: 200,
                  height: 200,
                ),
                PrimaryButton(
                  onPressed: data != null && myRoom != null
                      ? () async {
                          await FullScreenLoadingIndicator.show(
                            () async {
                              final result = await ref
                                  .read(compareFacesUseCaseProvider)
                                  .call(
                                    roomId: myRoom.id,
                                    data: data,
                                  );
                              if (result) {
                                showSnackBar(message: '同一人物です');
                              } else {
                                showErrorSnackBar(error: '別の人物です');
                              }
                            },
                          );
                        }
                      : null,
                  child: Text('顔比較'),
                ),

                SecondaryButton(
                  onPressed: () async {
                    await FullScreenLoadingIndicator.show(() async {
                      final result = await ref
                          .read(firebaseFunctionsServiceProvider)
                          .call('helloWorld');

                      showSnackBar(message: result['message'].toString());
                    });
                  },
                  child: Text('Confirm Connect'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
