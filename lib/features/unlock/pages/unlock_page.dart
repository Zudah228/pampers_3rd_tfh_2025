import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/core/app/components/snack_bar.dart';
import 'package:app/features/photo/pages/album_page.dart';
import 'package:app/features/room/use_cases/compare_faces_use_case.dart';
import 'package:app/features/unlock/providers/unlock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UnlockPage extends ConsumerStatefulWidget {
  const UnlockPage({super.key, required this.roomId});

  final String roomId;

  static const routeName = '/unlock';

  static Route<void> route(String roomId) {
    return RouteAnimations.swipeBack<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => UnlockPage(roomId: roomId),
    );
  }

  @override
  ConsumerState<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends ConsumerState<UnlockPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // フェードインアニメーション
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: Curves.easeInOut,
          ),
        );

    // スケールアニメーション
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(
          begin: 0.5,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _scaleController,
            curve: Curves.elasticOut,
          ),
        );

    // 回転アニメーション
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _rotateAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _rotateController,
            curve: Curves.easeInOut,
          ),
        );

    // アニメーション開始
    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _scaleController.forward();
    _rotateController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _fadeAnimation,
                    _scaleAnimation,
                    _rotateAnimation,
                  ]),
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                          angle: _rotateAnimation.value * 0.1,
                          child: Image.asset(
                            'assets/app_icons/app_icon.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
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
                  // カメラで直接撮影
                  final pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedImage == null) return;

                  final image = await pickedImage.readAsBytes();

                  await FullScreenLoadingIndicator.show(() async {
                    final checked = await ref.read(compareFacesUseCaseProvider)(
                      data: image,
                      roomId: widget.roomId,
                    );

                    if (!checked) {
                      showErrorSnackBar(error: '違う人が写っていますね');
                      return;
                    }
                    await ref.read(unlockProvider).unlock(image);
                  });

                  if (!context.mounted) return;
                  Navigator.of(context).push(AlbumPage.route());
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
