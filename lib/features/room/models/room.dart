import 'package:app/core/utils/json_converter/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
abstract class Room with _$Room {
  const factory Room({
    required String id,
    required String createdBy,
    required String? name,
    @Default([]) List<String> subjects,
    required int maxCount,
    required int currentCount,
    @CreatedAtTimestampConverter() DateTime? createdAt,
    @UpdatedAtTimestampConverter() DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(true)
    bool enabled,
  }) = _Room;

  const Room._();

  factory Room.fromJson(Map<String, Object?> json) => _$RoomFromJson(json);

  /// 今日のお題を取得（日付ベースでランダムに選択）
  String getTodaySubject() {
    final subjectList = subjects.isEmpty ? defaultSubjects : subjects;

    // 今日の日付とルームIDを使ってシード値を生成
    // 同じルーム・同じ日なら必ず同じお題が選ばれる
    final now = DateTime.now();
    final dateSeed = now.year * 10000 + now.month * 100 + now.day;
    final roomSeed = id.hashCode;
    final seed = dateSeed + roomSeed;

    final index = seed.abs() % subjectList.length;
    return subjectList[index];
  }
}

typedef RoomKeys = _$RoomJsonKeys;

/// デフォルトのお題リスト
const defaultSubjects = [
  'お気に入りの飲み物は何ですか？',
  '好きな季節はいつですか？',
  '最近食べたご飯は何でしたか？',
  '今日の一番の出来事は？',
  'お気に入りの場所はどこですか？',
  '最近買ったものは何ですか？',
  '今日の天気はどうでしたか？',
  '最近読んだ本は何ですか？',
  '今日の気分を一言で表すと？',
  '最近見た映画は何ですか？',
];

extension RoomFirestoreExtension on CollectionReference<Map<String, dynamic>> {
  CollectionReference<Room> get withRoomConverter => withConverter<Room>(
    fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
    toFirestore: (room, _) => room.toJson(),
  );
}
