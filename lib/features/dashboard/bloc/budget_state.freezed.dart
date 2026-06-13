// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetState {
  List<DashboardBudget> get budgets => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetStateCopyWith<BudgetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetStateCopyWith<$Res> {
  factory $BudgetStateCopyWith(
          BudgetState value, $Res Function(BudgetState) then) =
      _$BudgetStateCopyWithImpl<$Res, BudgetState>;
  @useResult
  $Res call(
      {List<DashboardBudget> budgets, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$BudgetStateCopyWithImpl<$Res, $Val extends BudgetState>
    implements $BudgetStateCopyWith<$Res> {
  _$BudgetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgets = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      budgets: null == budgets
          ? _value.budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<DashboardBudget>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetStateImplCopyWith<$Res>
    implements $BudgetStateCopyWith<$Res> {
  factory _$$BudgetStateImplCopyWith(
          _$BudgetStateImpl value, $Res Function(_$BudgetStateImpl) then) =
      __$$BudgetStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<DashboardBudget> budgets, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$BudgetStateImplCopyWithImpl<$Res>
    extends _$BudgetStateCopyWithImpl<$Res, _$BudgetStateImpl>
    implements _$$BudgetStateImplCopyWith<$Res> {
  __$$BudgetStateImplCopyWithImpl(
      _$BudgetStateImpl _value, $Res Function(_$BudgetStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgets = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$BudgetStateImpl(
      budgets: null == budgets
          ? _value._budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<DashboardBudget>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BudgetStateImpl extends _BudgetState {
  const _$BudgetStateImpl(
      {final List<DashboardBudget> budgets = const <DashboardBudget>[],
      this.isLoading = false,
      this.errorMessage})
      : _budgets = budgets,
        super._();

  final List<DashboardBudget> _budgets;
  @override
  @JsonKey()
  List<DashboardBudget> get budgets {
    if (_budgets is EqualUnmodifiableListView) return _budgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgets);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'BudgetState(budgets: $budgets, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetStateImpl &&
            const DeepCollectionEquality().equals(other._budgets, _budgets) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_budgets), isLoading, errorMessage);

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetStateImplCopyWith<_$BudgetStateImpl> get copyWith =>
      __$$BudgetStateImplCopyWithImpl<_$BudgetStateImpl>(this, _$identity);
}

abstract class _BudgetState extends BudgetState {
  const factory _BudgetState(
      {final List<DashboardBudget> budgets,
      final bool isLoading,
      final String? errorMessage}) = _$BudgetStateImpl;
  const _BudgetState._() : super._();

  @override
  List<DashboardBudget> get budgets;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of BudgetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetStateImplCopyWith<_$BudgetStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
