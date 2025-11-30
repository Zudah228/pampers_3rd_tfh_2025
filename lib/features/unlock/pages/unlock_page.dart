import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/form/image/image_field.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/features/unlock/providers/unlock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnlockPage extends ConsumerWidget {
  const UnlockPage({super.key});
  static const routeName = '/unlock';
  static Route<void> route() {
    return RouteAnimations.swipeBack<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const UnlockPage(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // TODO: appbarをCustomAppBarに変更
      appBar: AppBar(
        title: const Text('ロック解除'),
      ),
      backgroundColor: const Color(0xFFF5EFE7),
      body: SafeArea(
        child: Column(
          children: [
            // 中央のイラスト
            Expanded(
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B7C8C),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 写真のイラスト
                      Positioned(
                        right: 40,
                        bottom: 50,
                        child: Transform.rotate(
                          angle: 0.1,
                          child: Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB8A08A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE8DCC8),
                                width: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //TODO:鍵のイラストに置き換える
                      Positioned(
                        left: 50,
                        top: 60,
                        child: Transform.rotate(
                          angle: -0.3,
                          child: Column(
                            children: [
                              // リボン
                              Container(
                                width: 40,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B9AA8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              // 鍵の本体
                              Container(
                                width: 20,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5A6B7A),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5A6B7A),
                                        border: Border.all(
                                          color: const Color(0xFF8B9AA8),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 下部のボタン
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton.large(
                backgroundColor: const Color(0xFFC9A882),
                foregroundColor: Colors.white,
                onPressed: () async {
                  final image = await showImagePicker(context);
                  if (image == null) return;

                  // TODO: 撮影した画像を処理する。
                  // 画像の解析を行い、二人が写っているかどうかを判断する。
                  // 二人が本人かどうかの解析を行う
                  // 解析が成功した場合は、ロック解除する。
                  // 解析が失敗した場合は、エラーメッセージを表示する。

                  //現在は画像投稿されたかのみを判定
                  await FullScreenLoadingIndicator.show(() async {
                    await ref.read(unlockProvider).unlock(image);
                  });

                  if (!context.mounted) return;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people_outline, size: 24),
                    const SizedBox(width: 8),
                    const Text('二人で写真を撮る'),
                    const SizedBox(width: 8),
                    const Icon(Icons.camera_alt_outlined, size: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
