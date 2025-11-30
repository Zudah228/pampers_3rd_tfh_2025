import 'package:app/core/app/components/future/error.dart';
import 'package:app/core/app/components/future/future_switcher.dart';
import 'package:app/core/app/components/future/loading_indicator.dart';
import 'package:app/core/app/components/layout/layout.dart';
import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/core/app/theme/app_colors.dart';
import 'package:app/core/service/firebase_storage/firebase_storage_service.dart';
import 'package:app/features/photo/models/photo_group.dart';
import 'package:app/features/photo/providers/daily_photos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AlbumPage extends ConsumerStatefulWidget {
  const AlbumPage._();

  static const routeName = '/album';

  static Route<void> route() {
    return RouteAnimations.swipeBack<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AlbumPage._(),
    );
  }

  @override
  ConsumerState<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends ConsumerState<AlbumPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyPhotosAsync = ref.watch(dailyPhotosProvider);

    return dailyPhotosAsync.when(
      data: (dailyGroups) {
        if (dailyGroups.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('アルバム確認'),
            ),
            body: const Center(
              child: Text('写真がありません'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: _DateRangeHeader(dailyGroups: dailyGroups),
          ),
          body: Column(
            children: [
              // カルーセル
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: dailyGroups.length,
                  itemBuilder: (context, index) {
                    final group = dailyGroups[index];
                    return _DailyPhotoCard(group: group);
                  },
                ),
              ),
              // ページインジケーターとナビゲーション
              Padding(
                padding: const EdgeInsets.all(16),
                child: _NavigationBar(
                  currentPage: _currentPage,
                  totalPages: dailyGroups.length,
                  onPrevious: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  onNext: _currentPage < dailyGroups.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('アルバム確認'),
        ),
        body: const LoadingIndicator(),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('アルバム確認'),
        ),
        body: ErrorListView(error, stack),
      ),
    );
  }
}

class _DateRangeHeader extends StatelessWidget {
  const _DateRangeHeader({required this.dailyGroups});

  final List<DailyPhotoGroup> dailyGroups;

  @override
  Widget build(BuildContext context) {
    if (dailyGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    final startDate = dailyGroups.last.date;
    final endDate = dailyGroups.first.date;
    final dateFormat = DateFormat('yyyy年M月d日');

    return Text(
      '${dateFormat.format(startDate)}〜${dateFormat.format(endDate)}',
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }
}

class _DailyPhotoCard extends StatelessWidget {
  const _DailyPhotoCard({required this.group});

  final DailyPhotoGroup group;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy年M月d日');
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // 固定ヘッダー部分
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // お題
              Headline2(
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.charcoal,
                ),
                child: Text(group.subject),
              ),
              // 日付
              Text(
                dateFormat.format(group.date),
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              const Divider(),
            ],
          ),
        ),
        // スクロール可能な写真一覧
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Body(
                children: group.photos.map((photoGroup) {
                  return _PhotoItem(photoGroup: photoGroup);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoItem extends ConsumerWidget {
  const _PhotoItem({required this.photoGroup});

  final PhotoGroup photoGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = photoGroup.photo;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 写真または空の状態
            if (photo != null)
              FutureSwitcher(
                fetch: () async {
                  debugPrint('📸 画像パス: ${photo.path}');
                  final url = await ref
                      .read(firebaseStorageServiceProvider)
                      .getDownloadURL(photo.path);
                  debugPrint('📸 ダウンロードURL: $url');
                  return url;
                },
                builder: (url) {
                  debugPrint('📸 Image.networkに渡すURL: $url');
                  return Image.network(
                    url,
                    fit: BoxFit.cover,
                  );
                },
                loadingBuilder: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (error, stackTrace) => const Center(
                  child: Icon(Icons.error),
                ),
              )
            else
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '未投稿',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // ユーザー名表示
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: photo != null
                      ? LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        )
                      : null,
                  color: photo == null
                      ? Theme.of(context).colorScheme.surface.withOpacity(0.9)
                      : null,
                  border: photo == null
                      ? Border(
                          top: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        )
                      : null,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // アバター画像
                    _UserAvatar(
                      avatarPath: photoGroup.user.avatarPath,
                      hasPhoto: photo != null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      photoGroup.user.name ?? 'ユーザー',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: photo != null
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        shadows: photo != null
                            ? const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
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

class _UserAvatar extends ConsumerWidget {
  const _UserAvatar({
    required this.avatarPath,
    required this.hasPhoto,
  });

  final String? avatarPath;
  final bool hasPhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: hasPhoto
            ? Colors.white.withOpacity(0.3)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarPath != null
          ? FutureSwitcher(
              fetch: () => ref
                  .read(firebaseStorageServiceProvider)
                  .getDownloadURL(avatarPath!),
              builder: (url) => Image.network(
                url,
                fit: BoxFit.cover,
              ),
              loadingBuilder: () => Icon(
                Icons.person,
                size: 24,
                color: hasPhoto
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              errorBuilder: (error, stackTrace) => Icon(
                Icons.person,
                size: 24,
                color: hasPhoto
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : Icon(
              Icons.person,
              size: 24,
              color: hasPhoto
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.currentPage,
    required this.totalPages,
    this.onPrevious,
    this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 前へボタン
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
          iconSize: 48,
          style: IconButton.styleFrom(
            backgroundColor: onPrevious != null
                ? Colors.grey.shade400
                : Colors.grey.shade300,
            foregroundColor: Colors.white,
          ),
        ),
        // ページインジケーター
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${currentPage + 1} / $totalPages',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 16),
            ...List.generate(
              totalPages > 4 ? 4 : totalPages,
              (index) {
                final isActive = index == currentPage;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade400,
                  ),
                );
              },
            ),
          ],
        ),
        // 次へボタン
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          iconSize: 48,
          style: IconButton.styleFrom(
            backgroundColor: onNext != null
                ? Colors.brown.shade300
                : Colors.grey.shade300,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}



// 9iWjFqSMG3EQbl96T7OA