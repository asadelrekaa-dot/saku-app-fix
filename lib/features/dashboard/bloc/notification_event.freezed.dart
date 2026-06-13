// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loaded,
    required TResult Function(String message) added,
    required TResult Function() markAllRead,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loaded,
    TResult? Function(String message)? added,
    TResult? Function()? markAllRead,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loaded,
    TResult Function(String message)? added,
    TResult Function()? markAllRead,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotificationLoaded value) loaded,
    required TResult Function(NotificationAdded value) added,
    required TResult Function(NotificationAllRead value) markAllRead,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotificationLoaded value)? loaded,
    TResult? Function(NotificationAdded value)? added,
    TResult? Function(NotificationAllRead value)? markAllRead,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotificationLoaded value)? loaded,
    TResult Function(NotificationAdded value)? added,
    TResult Function(NotificationAllRead value)? markAllRead,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationEventCopyWith<$Res> {
  factory $NotificationEventCopyWith(
          NotificationEvent value, $Res Function(NotificationEvent) then) =
      _$NotificationEventCopyWithImpl<$Res, NotificationEvent>;
}

/// @nodoc
class _$NotificationEventCopyWithImpl<$Res, $Val extends NotificationEvent>
    implements $NotificationEventCopyWith<$Res> {
  _$NotificationEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$NotificationLoadedImplCopyWith<$Res> {
  factory _$$NotificationLoadedImplCopyWith(_$NotificationLoadedImpl value,
          $Res Function(_$NotificationLoadedImpl) then) =
      __$$NotificationLoadedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotificationLoadedImplCopyWithImpl<$Res>
    extends _$NotificationEventCopyWithImpl<$Res, _$NotificationLoadedImpl>
    implements _$$NotificationLoadedImplCopyWith<$Res> {
  __$$NotificationLoadedImplCopyWithImpl(_$NotificationLoadedImpl _value,
      $Res Function(_$NotificationLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NotificationLoadedImpl implements NotificationLoaded {
  const _$NotificationLoadedImpl();

  @override
  String toString() {
    return 'NotificationEvent.loaded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NotificationLoadedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loaded,
    required TResult Function(String message) added,
    required TResult Function() markAllRead,
  }) {
    return loaded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loaded,
    TResult? Function(String message)? added,
    TResult? Function()? markAllRead,
  }) {
    return loaded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loaded,
    TResult Function(String message)? added,
    TResult Function()? markAllRead,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotificationLoaded value) loaded,
    required TResult Function(NotificationAdded value) added,
    required TResult Function(NotificationAllRead value) markAllRead,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotificationLoaded value)? loaded,
    TResult? Function(NotificationAdded value)? added,
    TResult? Function(NotificationAllRead value)? markAllRead,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotificationLoaded value)? loaded,
    TResult Function(NotificationAdded value)? added,
    TResult Function(NotificationAllRead value)? markAllRead,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class NotificationLoaded implements NotificationEvent {
  const factory NotificationLoaded() = _$NotificationLoadedImpl;
}

/// @nodoc
abstract class _$$NotificationAddedImplCopyWith<$Res> {
  factory _$$NotificationAddedImplCopyWith(_$NotificationAddedImpl value,
          $Res Function(_$NotificationAddedImpl) then) =
      __$$NotificationAddedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NotificationAddedImplCopyWithImpl<$Res>
    extends _$NotificationEventCopyWithImpl<$Res, _$NotificationAddedImpl>
    implements _$$NotificationAddedImplCopyWith<$Res> {
  __$$NotificationAddedImplCopyWithImpl(_$NotificationAddedImpl _value,
      $Res Function(_$NotificationAddedImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$NotificationAddedImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NotificationAddedImpl implements NotificationAdded {
  const _$NotificationAddedImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'NotificationEvent.added(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationAddedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationAddedImplCopyWith<_$NotificationAddedImpl> get copyWith =>
      __$$NotificationAddedImplCopyWithImpl<_$NotificationAddedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loaded,
    required TResult Function(String message) added,
    required TResult Function() markAllRead,
  }) {
    return added(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loaded,
    TResult? Function(String message)? added,
    TResult? Function()? markAllRead,
  }) {
    return added?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loaded,
    TResult Function(String message)? added,
    TResult Function()? markAllRead,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotificationLoaded value) loaded,
    required TResult Function(NotificationAdded value) added,
    required TResult Function(NotificationAllRead value) markAllRead,
  }) {
    return added(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotificationLoaded value)? loaded,
    TResult? Function(NotificationAdded value)? added,
    TResult? Function(NotificationAllRead value)? markAllRead,
  }) {
    return added?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotificationLoaded value)? loaded,
    TResult Function(NotificationAdded value)? added,
    TResult Function(NotificationAllRead value)? markAllRead,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(this);
    }
    return orElse();
  }
}

abstract class NotificationAdded implements NotificationEvent {
  const factory NotificationAdded(final String message) =
      _$NotificationAddedImpl;

  String get message;

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationAddedImplCopyWith<_$NotificationAddedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotificationAllReadImplCopyWith<$Res> {
  factory _$$NotificationAllReadImplCopyWith(_$NotificationAllReadImpl value,
          $Res Function(_$NotificationAllReadImpl) then) =
      __$$NotificationAllReadImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotificationAllReadImplCopyWithImpl<$Res>
    extends _$NotificationEventCopyWithImpl<$Res, _$NotificationAllReadImpl>
    implements _$$NotificationAllReadImplCopyWith<$Res> {
  __$$NotificationAllReadImplCopyWithImpl(_$NotificationAllReadImpl _value,
      $Res Function(_$NotificationAllReadImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NotificationAllReadImpl implements NotificationAllRead {
  const _$NotificationAllReadImpl();

  @override
  String toString() {
    return 'NotificationEvent.markAllRead()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationAllReadImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loaded,
    required TResult Function(String message) added,
    required TResult Function() markAllRead,
  }) {
    return markAllRead();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loaded,
    TResult? Function(String message)? added,
    TResult? Function()? markAllRead,
  }) {
    return markAllRead?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loaded,
    TResult Function(String message)? added,
    TResult Function()? markAllRead,
    required TResult orElse(),
  }) {
    if (markAllRead != null) {
      return markAllRead();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotificationLoaded value) loaded,
    required TResult Function(NotificationAdded value) added,
    required TResult Function(NotificationAllRead value) markAllRead,
  }) {
    return markAllRead(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotificationLoaded value)? loaded,
    TResult? Function(NotificationAdded value)? added,
    TResult? Function(NotificationAllRead value)? markAllRead,
  }) {
    return markAllRead?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotificationLoaded value)? loaded,
    TResult Function(NotificationAdded value)? added,
    TResult Function(NotificationAllRead value)? markAllRead,
    required TResult orElse(),
  }) {
    if (markAllRead != null) {
      return markAllRead(this);
    }
    return orElse();
  }
}

abstract class NotificationAllRead implements NotificationEvent {
  const factory NotificationAllRead() = _$NotificationAllReadImpl;
}
