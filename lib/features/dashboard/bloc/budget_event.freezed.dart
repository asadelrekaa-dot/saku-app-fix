// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loaded,
    required TResult Function(DashboardBudget item) added,
    required TResult Function(DashboardBudget item) deleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loaded,
    TResult? Function(DashboardBudget item)? added,
    TResult? Function(DashboardBudget item)? deleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loaded,
    TResult Function(DashboardBudget item)? added,
    TResult Function(DashboardBudget item)? deleted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BudgetLoaded value) loaded,
    required TResult Function(BudgetAdded value) added,
    required TResult Function(BudgetDeleted value) deleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BudgetLoaded value)? loaded,
    TResult? Function(BudgetAdded value)? added,
    TResult? Function(BudgetDeleted value)? deleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BudgetLoaded value)? loaded,
    TResult Function(BudgetAdded value)? added,
    TResult Function(BudgetDeleted value)? deleted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetEventCopyWith<$Res> {
  factory $BudgetEventCopyWith(
          BudgetEvent value, $Res Function(BudgetEvent) then) =
      _$BudgetEventCopyWithImpl<$Res, BudgetEvent>;
}

/// @nodoc
class _$BudgetEventCopyWithImpl<$Res, $Val extends BudgetEvent>
    implements $BudgetEventCopyWith<$Res> {
  _$BudgetEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BudgetLoadedImplCopyWith<$Res> {
  factory _$$BudgetLoadedImplCopyWith(
          _$BudgetLoadedImpl value, $Res Function(_$BudgetLoadedImpl) then) =
      __$$BudgetLoadedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BudgetLoadedImplCopyWithImpl<$Res>
    extends _$BudgetEventCopyWithImpl<$Res, _$BudgetLoadedImpl>
    implements _$$BudgetLoadedImplCopyWith<$Res> {
  __$$BudgetLoadedImplCopyWithImpl(
      _$BudgetLoadedImpl _value, $Res Function(_$BudgetLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BudgetLoadedImpl implements BudgetLoaded {
  const _$BudgetLoadedImpl();

  @override
  String toString() {
    return 'BudgetEvent.loaded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BudgetLoadedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loaded,
    required TResult Function(DashboardBudget item) added,
    required TResult Function(DashboardBudget item) deleted,
  }) {
    return loaded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loaded,
    TResult? Function(DashboardBudget item)? added,
    TResult? Function(DashboardBudget item)? deleted,
  }) {
    return loaded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loaded,
    TResult Function(DashboardBudget item)? added,
    TResult Function(DashboardBudget item)? deleted,
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
    required TResult Function(BudgetLoaded value) loaded,
    required TResult Function(BudgetAdded value) added,
    required TResult Function(BudgetDeleted value) deleted,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BudgetLoaded value)? loaded,
    TResult? Function(BudgetAdded value)? added,
    TResult? Function(BudgetDeleted value)? deleted,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BudgetLoaded value)? loaded,
    TResult Function(BudgetAdded value)? added,
    TResult Function(BudgetDeleted value)? deleted,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class BudgetLoaded implements BudgetEvent {
  const factory BudgetLoaded() = _$BudgetLoadedImpl;
}

/// @nodoc
abstract class _$$BudgetAddedImplCopyWith<$Res> {
  factory _$$BudgetAddedImplCopyWith(
          _$BudgetAddedImpl value, $Res Function(_$BudgetAddedImpl) then) =
      __$$BudgetAddedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardBudget item});
}

/// @nodoc
class __$$BudgetAddedImplCopyWithImpl<$Res>
    extends _$BudgetEventCopyWithImpl<$Res, _$BudgetAddedImpl>
    implements _$$BudgetAddedImplCopyWith<$Res> {
  __$$BudgetAddedImplCopyWithImpl(
      _$BudgetAddedImpl _value, $Res Function(_$BudgetAddedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
  }) {
    return _then(_$BudgetAddedImpl(
      null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as DashboardBudget,
    ));
  }
}

/// @nodoc

class _$BudgetAddedImpl implements BudgetAdded {
  const _$BudgetAddedImpl(this.item);

  @override
  final DashboardBudget item;

  @override
  String toString() {
    return 'BudgetEvent.added(item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetAddedImpl &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item);

  /// Create a copy of BudgetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetAddedImplCopyWith<_$BudgetAddedImpl> get copyWith =>
      __$$BudgetAddedImplCopyWithImpl<_$BudgetAddedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loaded,
    required TResult Function(DashboardBudget item) added,
    required TResult Function(DashboardBudget item) deleted,
  }) {
    return added(item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loaded,
    TResult? Function(DashboardBudget item)? added,
    TResult? Function(DashboardBudget item)? deleted,
  }) {
    return added?.call(item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loaded,
    TResult Function(DashboardBudget item)? added,
    TResult Function(DashboardBudget item)? deleted,
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
    required TResult Function(BudgetLoaded value) loaded,
    required TResult Function(BudgetAdded value) added,
    required TResult Function(BudgetDeleted value) deleted,
  }) {
    return added(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BudgetLoaded value)? loaded,
    TResult? Function(BudgetAdded value)? added,
    TResult? Function(BudgetDeleted value)? deleted,
  }) {
    return added?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BudgetLoaded value)? loaded,
    TResult Function(BudgetAdded value)? added,
    TResult Function(BudgetDeleted value)? deleted,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(this);
    }
    return orElse();
  }
}

abstract class BudgetAdded implements BudgetEvent {
  const factory BudgetAdded(final DashboardBudget item) = _$BudgetAddedImpl;

  DashboardBudget get item;

  /// Create a copy of BudgetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetAddedImplCopyWith<_$BudgetAddedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BudgetDeletedImplCopyWith<$Res> {
  factory _$$BudgetDeletedImplCopyWith(
          _$BudgetDeletedImpl value, $Res Function(_$BudgetDeletedImpl) then) =
      __$$BudgetDeletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DashboardBudget item});
}

/// @nodoc
class __$$BudgetDeletedImplCopyWithImpl<$Res>
    extends _$BudgetEventCopyWithImpl<$Res, _$BudgetDeletedImpl>
    implements _$$BudgetDeletedImplCopyWith<$Res> {
  __$$BudgetDeletedImplCopyWithImpl(
      _$BudgetDeletedImpl _value, $Res Function(_$BudgetDeletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
  }) {
    return _then(_$BudgetDeletedImpl(
      null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as DashboardBudget,
    ));
  }
}

/// @nodoc

class _$BudgetDeletedImpl implements BudgetDeleted {
  const _$BudgetDeletedImpl(this.item);

  @override
  final DashboardBudget item;

  @override
  String toString() {
    return 'BudgetEvent.deleted(item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetDeletedImpl &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item);

  /// Create a copy of BudgetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetDeletedImplCopyWith<_$BudgetDeletedImpl> get copyWith =>
      __$$BudgetDeletedImplCopyWithImpl<_$BudgetDeletedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loaded,
    required TResult Function(DashboardBudget item) added,
    required TResult Function(DashboardBudget item) deleted,
  }) {
    return deleted(item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loaded,
    TResult? Function(DashboardBudget item)? added,
    TResult? Function(DashboardBudget item)? deleted,
  }) {
    return deleted?.call(item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loaded,
    TResult Function(DashboardBudget item)? added,
    TResult Function(DashboardBudget item)? deleted,
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
    required TResult Function(BudgetLoaded value) loaded,
    required TResult Function(BudgetAdded value) added,
    required TResult Function(BudgetDeleted value) deleted,
  }) {
    return deleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BudgetLoaded value)? loaded,
    TResult? Function(BudgetAdded value)? added,
    TResult? Function(BudgetDeleted value)? deleted,
  }) {
    return deleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BudgetLoaded value)? loaded,
    TResult Function(BudgetAdded value)? added,
    TResult Function(BudgetDeleted value)? deleted,
    required TResult orElse(),
  }) {
    if (deleted != null) {
      return deleted(this);
    }
    return orElse();
  }
}

abstract class BudgetDeleted implements BudgetEvent {
  const factory BudgetDeleted(final DashboardBudget item) = _$BudgetDeletedImpl;

  DashboardBudget get item;

  /// Create a copy of BudgetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetDeletedImplCopyWith<_$BudgetDeletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
