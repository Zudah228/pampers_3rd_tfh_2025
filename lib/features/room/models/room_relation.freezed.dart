// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_relation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomRelation {

 String get id; String get userId; bool get enabled;@CreatedAtTimestampConverter() DateTime? get createdAt;@UpdatedAtTimestampConverter() DateTime? get updatedAt;
/// Create a copy of RoomRelation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomRelationCopyWith<RoomRelation> get copyWith => _$RoomRelationCopyWithImpl<RoomRelation>(this as RoomRelation, _$identity);

  /// Serializes this RoomRelation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomRelation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,enabled,createdAt,updatedAt);

@override
String toString() {
  return 'RoomRelation(id: $id, userId: $userId, enabled: $enabled, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RoomRelationCopyWith<$Res>  {
  factory $RoomRelationCopyWith(RoomRelation value, $Res Function(RoomRelation) _then) = _$RoomRelationCopyWithImpl;
@useResult
$Res call({
 String id, String userId, bool enabled,@CreatedAtTimestampConverter() DateTime? createdAt,@UpdatedAtTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$RoomRelationCopyWithImpl<$Res>
    implements $RoomRelationCopyWith<$Res> {
  _$RoomRelationCopyWithImpl(this._self, this._then);

  final RoomRelation _self;
  final $Res Function(RoomRelation) _then;

/// Create a copy of RoomRelation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? enabled = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomRelation].
extension RoomRelationPatterns on RoomRelation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomRelation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomRelation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomRelation value)  $default,){
final _that = this;
switch (_that) {
case _RoomRelation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomRelation value)?  $default,){
final _that = this;
switch (_that) {
case _RoomRelation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  bool enabled, @CreatedAtTimestampConverter()  DateTime? createdAt, @UpdatedAtTimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomRelation() when $default != null:
return $default(_that.id,_that.userId,_that.enabled,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  bool enabled, @CreatedAtTimestampConverter()  DateTime? createdAt, @UpdatedAtTimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RoomRelation():
return $default(_that.id,_that.userId,_that.enabled,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  bool enabled, @CreatedAtTimestampConverter()  DateTime? createdAt, @UpdatedAtTimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RoomRelation() when $default != null:
return $default(_that.id,_that.userId,_that.enabled,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomRelation extends RoomRelation {
  const _RoomRelation({required this.id, required this.userId, this.enabled = false, @CreatedAtTimestampConverter() this.createdAt, @UpdatedAtTimestampConverter() this.updatedAt}): super._();
  factory _RoomRelation.fromJson(Map<String, dynamic> json) => _$RoomRelationFromJson(json);

@override final  String id;
@override final  String userId;
@override@JsonKey() final  bool enabled;
@override@CreatedAtTimestampConverter() final  DateTime? createdAt;
@override@UpdatedAtTimestampConverter() final  DateTime? updatedAt;

/// Create a copy of RoomRelation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomRelationCopyWith<_RoomRelation> get copyWith => __$RoomRelationCopyWithImpl<_RoomRelation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomRelationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomRelation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,enabled,createdAt,updatedAt);

@override
String toString() {
  return 'RoomRelation(id: $id, userId: $userId, enabled: $enabled, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RoomRelationCopyWith<$Res> implements $RoomRelationCopyWith<$Res> {
  factory _$RoomRelationCopyWith(_RoomRelation value, $Res Function(_RoomRelation) _then) = __$RoomRelationCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, bool enabled,@CreatedAtTimestampConverter() DateTime? createdAt,@UpdatedAtTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$RoomRelationCopyWithImpl<$Res>
    implements _$RoomRelationCopyWith<$Res> {
  __$RoomRelationCopyWithImpl(this._self, this._then);

  final _RoomRelation _self;
  final $Res Function(_RoomRelation) _then;

/// Create a copy of RoomRelation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? enabled = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_RoomRelation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
