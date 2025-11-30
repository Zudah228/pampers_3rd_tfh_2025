import 'package:app/features/photo/models/photo.dart';
import 'package:app/features/user/models/user.dart';

/// 写真をユーザーごとにグループ化したデータ
class PhotoGroup {
  const PhotoGroup({
    required this.user,
    this.photo,
  });

  final User user;
  final Photo? photo;
}

/// 日付ごとの写真グループ
class DailyPhotoGroup {
  const DailyPhotoGroup({
    required this.date,
    required this.subject,
    required this.photos,
  });

  final DateTime date;
  final String subject;
  final List<PhotoGroup> photos;
}

