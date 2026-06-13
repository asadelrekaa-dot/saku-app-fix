// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DashboardTransaction item) added,
    required TResult Function(DashboardTransaction item) deleted,
    required TResult Function(DashboardTransaction item) settled,
    required TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)
        updated,
    required TResult Function(DashboardTransaction item) editOpened,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DashboardTransaction item)? added,
    TResult? Function(DashboardTransaction item)? deleted,
    TResult? Function(DashboardTransaction item)? settled,
    TResult? Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult? Function(DashboardTransaction item)? editOpened,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DashboardTransaction item)? added,
    TResult Function(DashboardTransaction item)? deleted,
    TResult Function(DashboardTransaction item)? settled,
    TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult Function(DashboardTransaction item)? editOpened,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionAdded value) added,
    required TResult Function(TransactionDeleted value) deleted,
    required TResult Function(TransactionSettled value) settled,
    required TResult Function(TransactionUpdated value) updated,
    required TResult Function(TransactionEditOpened value) editOpened,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionAdded value)? added,
    TResult? Function(TransactionDeleted value)? deleted,
    TResult? Function(TransactionSettled value)? settled,
    TResult? Function(TransactionUpdated value)? updated,
    TResult? Function(TransactionEditOpened value)? editOpened,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionAdded value)? added,
    TResult Function(TransactionDeleted value)? deleted,
    TResult Function(TransactionSettled value)? settled,
    TResult Function(TransactionUpdated value)? updated,
    TResult Function(TransactionEditOpened value)? editOpened,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionEventCopyWith<$Res> {
  factory $TransactionEventCopyWith(
          TransactionEvent value, $Res Function(TransactionEvent) then) =
      _$TransactionEventCopyWithImpl<$Res, TransactionEvent>;
}

/// @nodoc
class _$TransactionEventCopyWithImpl<$Res, $Val extends TransactionEvent>
    implements $TransactionEventCopyWith<$Res> {
  _$TransactionEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TransactionAddedImplCopyWith<$Res> {
  factory _$$TransactionAddedImplCopyWith(_$TransactionAddedImpl value,
          $Res Function(_$TransactionAddedImpl) then) =
      __$$TransactionAddedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardTransaction item});
}

/// @nodoc
class __$$TransactionAddedImplCopyWithImpl<$Res>
    extends _$TransactionEventCopyWithImpl<$Res, _$TransactionAddedImpl>
    implements _$$TransactionAddedImplCopyWith<$Res> {
  __$$TransactionAddedImplCopyWithImpl(_$TransactionAddedImpl _value,
      $Res Function(_$TransactionAddedImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
  }) {
    return _then(_$TransactionAddedImpl(
      null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as DashboardTransaction,
    ));
  }
}

/// @nodoc

class _$TransactionAddedImpl implements TransactionAdded {
  const _$TransactionAddedImpl(this.item);

  @override
  final DashboardTransaction item;

  @override
  String toString() {
    return 'TransactionEvent.added(item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionAddedImpl &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionAddedImplCopyWith<_$TransactionAddedImpl> get copyWith =>
      __$$TransactionAddedImplCopyWithImpl<_$TransactionAddedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DashboardTransaction item) added,
    required TResult Function(DashboardTransaction item) deleted,
    required TResult Function(DashboardTransaction item) settled,
    required TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)
        updated,
    required TResult Function(DashboardTransaction item) editOpened,
  }) {
    return added(item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DashboardTransaction item)? added,
    TResult? Function(DashboardTransaction item)? deleted,
    TResult? Function(DashboardTransaction item)? settled,
    TResult? Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult? Function(DashboardTransaction item)? editOpened,
  }) {
    return added?.call(item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DashboardTransaction item)? added,
    TResult Function(DashboardTransaction item)? deleted,
    TResult Function(DashboardTransaction item)? settled,
    TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult Function(DashboardTransaction item)? editOpened,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(item);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionAdded value) added,
    required TResult Function(TransactionDeleted value) deleted,
    required TResult Function(TransactionSettled value) settled,
    required TResult Function(TransactionUpdated value) updated,
    required TResult Function(TransactionEditOpened value) editOpened,
  }) {
    return added(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionAdded value)? added,
    TResult? Function(TransactionDeleted value)? deleted,
    TResult? Function(TransactionSettled value)? settled,
    TResult? Function(TransactionUpdated value)? updated,
    TResult? Function(TransactionEditOpened value)? editOpened,
  }) {
    return added?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionAdded value)? added,
    TResult Function(TransactionDeleted value)? deleted,
    TResult Function(TransactionSettled value)? settled,
    TResult Function(TransactionUpdated value)? updated,
    TResult Function(TransactionEditOpened value)? editOpened,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(this);
    }
    return orElse();
  }
}

abstract class TransactionAdded implements TransactionEvent {
  const factory TransactionAdded(final DashboardTransaction item) =
      _$TransactionAddedImpl;

  DashboardTransaction get item;

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionAddedImplCopyWith<_$TransactionAddedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TransactionDeletedImplCopyWith<$Res> {
  factory _$$TransactionDeletedImplCopyWith(_$TransactionDeletedImpl value,
          $Res Function(_$TransactionDeletedImpl) then) =
      __$$TransactionDeletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardTransaction item});
}

/// @nodoc
class __$$TransactionDeletedImplCopyWithImpl<$Res>
    extends _$TransactionEventCopyWithImpl<$Res, _$TransactionDeletedImpl>
    implements _$$TransactionDeletedImplCopyWith<$Res> {
  __$$TransactionDeletedImplCopyWithImpl(_$TransactionDeletedImpl _value,
      $Res Function(_$TransactionDeletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
  }) {
    return _then(_$TransactionDeletedImpl(
      null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as DashboardTransaction,
    ));
  }
}

/// @nodoc

class _$TransactionDeletedImpl implements TransactionDeleted {
  const _$TransactionDeletedImpl(this.item);

  @override
  final DashboardTransaction item;

  @override
  String toString() {
    return 'TransactionEvent.deleted(item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionDeletedImpl &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionDeletedImplCopyWith<_$TransactionDeletedImpl> get copyWith =>
      __$$TransactionDeletedImplCopyWithImpl<_$TransactionDeletedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DashboardTransaction item) added,
    required TResult Function(DashboardTransaction item) deleted,
    required TResult Function(DashboardTransaction item) settled,
    required TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)
        updated,
    required TResult Function(DashboardTransaction item) editOpened,
  }) {
    return deleted(item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DashboardTransaction item)? added,
    TResult? Function(DashboardTransaction item)? deleted,
    TResult? Function(DashboardTransaction item)? settled,
    TResult? Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult? Function(DashboardTransaction item)? editOpened,
  }) {
    return deleted?.call(item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DashboardTransaction item)? added,
    TResult Function(DashboardTransaction item)? deleted,
    TResult Function(DashboardTransaction item)? settled,
    TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult Function(DashboardTransaction item)? editOpened,
    required TResult orElse(),
  }) {
    if (deleted != null) {
      return deleted(item);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionAdded value) added,
    required TResult Function(TransactionDeleted value) deleted,
    required TResult Function(TransactionSettled value) settled,
    required TResult Function(TransactionUpdated value) updated,
    required TResult Function(TransactionEditOpened value) editOpened,
  }) {
    return deleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionAdded value)? added,
    TResult? Function(TransactionDeleted value)? deleted,
    TResult? Function(TransactionSettled value)? settled,
    TResult? Function(TransactionUpdated value)? updated,
    TResult? Function(TransactionEditOpened value)? editOpened,
  }) {
    return deleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionAdded value)? added,
    TResult Function(TransactionDeleted value)? deleted,
    TResult Function(TransactionSettled value)? settled,
    TResult Function(TransactionUpdated value)? updated,
    TResult Function(TransactionEditOpened value)? editOpened,
    required TResult orElse(),
  }) {
    if (deleted != null) {
      return deleted(this);
    }
    return orElse();
  }
}

abstract class TransactionDeleted implements TransactionEvent {
  const factory TransactionDeleted(final DashboardTransaction item) =
      _$TransactionDeletedImpl;

  DashboardTransaction get item;

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionDeletedImplCopyWith<_$TransactionDeletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TransactionSettledImplCopyWith<$Res> {
  factory _$$TransactionSettledImplCopyWith(_$TransactionSettledImpl value,
          $Res Function(_$TransactionSettledImpl) then) =
      __$$TransactionSettledImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardTransaction item});
}

/// @nodoc
class __$$TransactionSettledImplCopyWithImpl<$Res>
    extends _$TransactionEventCopyWithImpl<$Res, _$TransactionSettledImpl>
    implements _$$TransactionSettledImplCopyWith<$Res> {
  __$$TransactionSettledImplCopyWithImpl(_$TransactionSettledImpl _value,
      $Res Function(_$TransactionSettledImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
  }) {
    return _then(_$TransactionSettledImpl(
      null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as DashboardTransaction,
    ));
  }
}

/// @nodoc

class _$TransactionSettledImpl implements TransactionSettled {
  const _$TransactionSettledImpl(this.item);

  @override
  final DashboardTransaction item;

  @override
  String toString() {
    return 'TransactionEvent.settled(item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionSettledImpl &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionSettledImplCopyWith<_$TransactionSettledImpl> get copyWith =>
      __$$TransactionSettledImplCopyWithImpl<_$TransactionSettledImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DashboardTransaction item) added,
    required TResult Function(DashboardTransaction item) deleted,
    required TResult Function(DashboardTransaction item) settled,
    required TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)
        updated,
    required TResult Function(DashboardTransaction item) editOpened,
  }) {
    return settled(item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DashboardTransaction item)? added,
    TResult? Function(DashboardTransaction item)? deleted,
    TResult? Function(DashboardTransaction item)? settled,
    TResult? Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult? Function(DashboardTransaction item)? editOpened,
  }) {
    return settled?.call(item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DashboardTransaction item)? added,
    TResult Function(DashboardTransaction item)? deleted,
    TResult Function(DashboardTransaction item)? settled,
    TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult Function(DashboardTransaction item)? editOpened,
    required TResult orElse(),
  }) {
    if (settled != null) {
      return settled(item);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionAdded value) added,
    required TResult Function(TransactionDeleted value) deleted,
    required TResult Function(TransactionSettled value) settled,
    required TResult Function(TransactionUpdated value) updated,
    required TResult Function(TransactionEditOpened value) editOpened,
  }) {
    return settled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionAdded value)? added,
    TResult? Function(TransactionDeleted value)? deleted,
    TResult? Function(TransactionSettled value)? settled,
    TResult? Function(TransactionUpdated value)? updated,
    TResult? Function(TransactionEditOpened value)? editOpened,
  }) {
    return settled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionAdded value)? added,
    TResult Function(TransactionDeleted value)? deleted,
    TResult Function(TransactionSettled value)? settled,
    TResult Function(TransactionUpdated value)? updated,
    TResult Function(TransactionEditOpened value)? editOpened,
    required TResult orElse(),
  }) {
    if (settled != null) {
      return settled(this);
    }
    return orElse();
  }
}

abstract class TransactionSettled implements TransactionEvent {
  const factory TransactionSettled(final DashboardTransaction item) =
      _$TransactionSettledImpl;

  DashboardTransaction get item;

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionSettledImplCopyWith<_$TransactionSettledImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TransactionUpdatedImplCopyWith<$Res> {
  factory _$$TransactionUpdatedImplCopyWith(_$TransactionUpdatedImpl value,
          $Res Function(_$TransactionUpdatedImpl) then) =
      __$$TransactionUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardTransaction oldItem, DashboardTransaction newItem});
}

/// @nodoc
class __$$TransactionUpdatedImplCopyWithImpl<$Res>
    extends _$TransactionEventCopyWithImpl<$Res, _$TransactionUpdatedImpl>
    implements _$$TransactionUpdatedImplCopyWith<$Res> {
  __$$TransactionUpdatedImplCopyWithImpl(_$TransactionUpdatedImpl _value,
      $Res Function(_$TransactionUpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldItem = null,
    Object? newItem = null,
  }) {
    return _then(_$TransactionUpdatedImpl(
      oldItem: null == oldItem
          ? _value.oldItem
          : oldItem // ignore: cast_nullable_to_non_nullable
              as DashboardTransaction,
      newItem: null == newItem
          ? _value.newItem
          : newItem // ignore: cast_nullable_to_non_nullable
              as DashboardTransaction,
    ));
  }
}

/// @nodoc

class _$TransactionUpdatedImpl implements TransactionUpdated {
  const _$TransactionUpdatedImpl(
      {required this.oldItem, required this.newItem});

  @override
  final DashboardTransaction oldItem;
  @override
  final DashboardTransaction newItem;

  @override
  String toString() {
    return 'TransactionEvent.updated(oldItem: $oldItem, newItem: $newItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionUpdatedImpl &&
            (identical(other.oldItem, oldItem) || other.oldItem == oldItem) &&
            (identical(other.newItem, newItem) || other.newItem == newItem));
  }

  @override
  int get hashCode => Object.hash(runtimeType, oldItem, newItem);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionUpdatedImplCopyWith<_$TransactionUpdatedImpl> get copyWith =>
      __$$TransactionUpdatedImplCopyWithImpl<_$TransactionUpdatedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DashboardTransaction item) added,
    required TResult Function(DashboardTransaction item) deleted,
    required TResult Function(DashboardTransaction item) settled,
    required TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)
        updated,
    required TResult Function(DashboardTransaction item) editOpened,
  }) {
    return updated(oldItem, newItem);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DashboardTransaction item)? added,
    TResult? Function(DashboardTransaction item)? deleted,
    TResult? Function(DashboardTransaction item)? settled,
    TResult? Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult? Function(DashboardTransaction item)? editOpened,
  }) {
    return updated?.call(oldItem, newItem);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DashboardTransaction item)? added,
    TResult Function(DashboardTransaction item)? deleted,
    TResult Function(DashboardTransaction item)? settled,
    TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult Function(DashboardTransaction item)? editOpened,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated(oldItem, newItem);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionAdded value) added,
    required TResult Function(TransactionDeleted value) deleted,
    required TResult Function(TransactionSettled value) settled,
    required TResult Function(TransactionUpdated value) updated,
    required TResult Function(TransactionEditOpened value) editOpened,
  }) {
    return updated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionAdded value)? added,
    TResult? Function(TransactionDeleted value)? deleted,
    TResult? Function(TransactionSettled value)? settled,
    TResult? Function(TransactionUpdated value)? updated,
    TResult? Function(TransactionEditOpened value)? editOpened,
  }) {
    return updated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionAdded value)? added,
    TResult Function(TransactionDeleted value)? deleted,
    TResult Function(TransactionSettled value)? settled,
    TResult Function(TransactionUpdated value)? updated,
    TResult Function(TransactionEditOpened value)? editOpened,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated(this);
    }
    return orElse();
  }
}

abstract class TransactionUpdated implements TransactionEvent {
  const factory TransactionUpdated(
      {required final DashboardTransaction oldItem,
      required final DashboardTransaction newItem}) = _$TransactionUpdatedImpl;

  DashboardTransaction get oldItem;
  DashboardTransaction get newItem;

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionUpdatedImplCopyWith<_$TransactionUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TransactionEditOpenedImplCopyWith<$Res> {
  factory _$$TransactionEditOpenedImplCopyWith(
          _$TransactionEditOpenedImpl value,
          $Res Function(_$TransactionEditOpenedImpl) then) =
      __$$TransactionEditOpenedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardTransaction item});
}

/// @nodoc
class __$$TransactionEditOpenedImplCopyWithImpl<$Res>
    extends _$TransactionEventCopyWithImpl<$Res, _$TransactionEditOpenedImpl>
    implements _$$TransactionEditOpenedImplCopyWith<$Res> {
  __$$TransactionEditOpenedImplCopyWithImpl(_$TransactionEditOpenedImpl _value,
      $Res Function(_$TransactionEditOpenedImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
  }) {
    return _then(_$TransactionEditOpenedImpl(
      null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as DashboardTransaction,
    ));
  }
}

/// @nodoc

class _$TransactionEditOpenedImpl implements TransactionEditOpened {
  const _$TransactionEditOpenedImpl(this.item);

  @override
  final DashboardTransaction item;

  @override
  String toString() {
    return 'TransactionEvent.editOpened(item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionEditOpenedImpl &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionEditOpenedImplCopyWith<_$TransactionEditOpenedImpl>
      get copyWith => __$$TransactionEditOpenedImplCopyWithImpl<
          _$TransactionEditOpenedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DashboardTransaction item) added,
    required TResult Function(DashboardTransaction item) deleted,
    required TResult Function(DashboardTransaction item) settled,
    required TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)
        updated,
    required TResult Function(DashboardTransaction item) editOpened,
  }) {
    return editOpened(item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DashboardTransaction item)? added,
    TResult? Function(DashboardTransaction item)? deleted,
    TResult? Function(DashboardTransaction item)? settled,
    TResult? Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult? Function(DashboardTransaction item)? editOpened,
  }) {
    return editOpened?.call(item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DashboardTransaction item)? added,
    TResult Function(DashboardTransaction item)? deleted,
    TResult Function(DashboardTransaction item)? settled,
    TResult Function(
            DashboardTransaction oldItem, DashboardTransaction newItem)?
        updated,
    TResult Function(DashboardTransaction item)? editOpened,
    required TResult orElse(),
  }) {
    if (editOpened != null) {
      return editOpened(item);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionAdded value) added,
    required TResult Function(TransactionDeleted value) deleted,
    required TResult Function(TransactionSettled value) settled,
    required TResult Function(TransactionUpdated value) updated,
    required TResult Function(TransactionEditOpened value) editOpened,
  }) {
    return editOpened(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionAdded value)? added,
    TResult? Function(TransactionDeleted value)? deleted,
    TResult? Function(TransactionSettled value)? settled,
    TResult? Function(TransactionUpdated value)? updated,
    TResult? Function(TransactionEditOpened value)? editOpened,
  }) {
    return editOpened?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionAdded value)? added,
    TResult Function(TransactionDeleted value)? deleted,
    TResult Function(TransactionSettled value)? settled,
    TResult Function(TransactionUpdated value)? updated,
    TResult Function(TransactionEditOpened value)? editOpened,
    required TResult orElse(),
  }) {
    if (editOpened != null) {
      return editOpened(this);
    }
    return orElse();
  }
}

abstract class TransactionEditOpened implements TransactionEvent {
  const factory TransactionEditOpened(final DashboardTransaction item) =
      _$TransactionEditOpenedImpl;

  DashboardTransaction get item;

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionEditOpenedImplCopyWith<_$TransactionEditOpenedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
