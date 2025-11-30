import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/features/photo/models/photo.dart';
import 'package:app/features/photo/models/photo_group.dart';
import 'package:app/features/photo/providers/photos_provider.dart';
import 'package:app/features/room/models/room.dart';
import 'package:app/features/room/providers/my_room_provider.dart';
import 'package:app/features/user/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

/// 日付ごとにグループ化された写真一覧を取得するプロバイダー
final dailyPhotosProvider = FutureProvider.autoDispose<List<DailyPhotoGroup>>((
  ref,
) async {
  debugPrint('📸 dailyPhotosProvider: 開始');

  final photosAsync = await ref.watch(photosProvider.future);
  debugPrint('📸 photosAsync取得完了: ${photosAsync.items.length}件');

  final room = ref.watch(myRoomProvider).value;
  debugPrint('📸 room: ${room?.id ?? "null"}');

  // TODO: メンバーの読み込み待ちの実装
  // final membersAsync = ref.watch(roomMembersProvider);

  if (room == null) {
    debugPrint('📸 roomがnullのため空配列を返す');
    return [];
  }

  // TODO: 仮実装 - 後でメンバー情報を正しく取得する
  // final members = <dynamic>[];

  final photos = photosAsync.items;
  debugPrint('📸 写真の数: ${photos.length}');

  // 写真を日付ごとにグループ化
  final Map<String, List<Photo>> photosByDate = {};

  for (final photoDoc in photos) {
    final photo = photoDoc.data;
    final date = photo.createdAt;

    if (date != null) {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      photosByDate.putIfAbsent(dateKey, () => []).add(photo);
    }
  }

  debugPrint('📸 日付ごとのグループ数: ${photosByDate.length}');

  // TODO: 写真がない場合の処理は後で実装
  if (photosByDate.isEmpty) {
    debugPrint('📸 photosByDateが空のため空配列を返す');
    return [];
  }

  // 日付順にソート（新しい順）
  final sortedDates = photosByDate.keys.toList()
    ..sort((a, b) => b.compareTo(a));

  // 各日付のグループを作成
  final List<DailyPhotoGroup> dailyGroups = [];

  for (final dateKey in sortedDates) {
    final datePhotos = photosByDate[dateKey]!;
    final date = datePhotos.first.createdAt!;

    // その日のお題を取得
    final subject = _getSubjectForDate(room, date);

    // 各写真に対してPhotoGroupを作成
    final List<PhotoGroup> photoGroups = [];
    final firestore = ref.read(firebaseFirestoreServiceProvider).firestore;

    debugPrint('📸 ${datePhotos.length}枚の写真のユーザー情報を取得中...');

    for (final photo in datePhotos) {
      debugPrint('📸 ユーザーID: ${photo.userId} の情報を取得');

      // Firestoreからユーザー情報を取得
      final userDoc = await firestore
          .collection('users')
          .withUserConverter
          .doc(photo.userId)
          .get();

      final user = userDoc.data() ?? User(id: photo.userId);
      debugPrint('📸 ユーザー取得完了: ${user.name ?? "名前なし"} (${user.id})');

      photoGroups.add(
        PhotoGroup(
          user: user,
          photo: photo,
        ),
      );
    }

    debugPrint('📸 全ユーザー情報取得完了: ${photoGroups.length}件');

    dailyGroups.add(
      DailyPhotoGroup(
        date: date,
        subject: subject,
        photos: photoGroups,
      ),
    );
  }

  debugPrint('📸 dailyGroups作成完了: ${dailyGroups.length}グループ');
  return dailyGroups;
});

/// 指定された日付のお題を取得
String _getSubjectForDate(Room room, DateTime date) {
  final subjectList = room.subjects.isEmpty ? defaultSubjects : room.subjects;

  // 日付とルームIDを使ってシード値を生成
  final dateSeed = date.year * 10000 + date.month * 100 + date.day;
  final roomSeed = room.id.hashCode;
  final seed = dateSeed + roomSeed;

  final index = seed.abs() % subjectList.length;
  return subjectList[index];
}
