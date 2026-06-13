// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardState {
  int get currentIndex => throw _privateConstructorUsedError;
  DashboardSurface get surface => throw _privateConstructorUsedError;
  DashboardTransaction? get editingTransaction =>
      throw _privateConstructorUsedError;
  List<DashboardTransaction> get transactions =>
      throw _privateConstructorUsedError;
  List<DashboardBudget> get budgets => throw _privateConstructorUsedError;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStateCopyWith<DashboardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
          DashboardState value, $Res Function(DashboardState) then) =
      _$DashboardStateCopyWithImpl<$Res, DashboardState>;
  @useResult
  $Res call(
      {int currentIndex,
      DashboardSurface surface,
      DashboardTransaction? editingTransaction,
      List<DashboardTransaction> transactions,
      List<DashboardBudget> budgets});
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res, $Val extends DashboardState>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentIndex = null,
    Object? surface = null,
    Object? editingTransaction = freezed,
    Object? transactions = null,
    Object? budgets = null,
  }) {
    return _then(_value.copyWith(
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      surface: null == surface
          ? _value.surface
          : surface // ignore: cast_nullable_to_non_nullable
              as DashboardSurface,
      editingTransaction: freezed == editingTransaction
          ? _value.editingTransaction
          : editingTransaction // ignore: cast_nullable_to_non_nullable
              as DashboardTransaction?,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<DashboardTransaction>,
      budgets: null == budgets
          ? _value.budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<DashboardBudget>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardStateImplCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory _$$DashboardStateImplCopyWith(_$DashboardStateImpl value,
          $Res Function(_$DashboardStateImpl) then) =
      __$$DashboardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentIndex,
      DashboardSurface surface,
      DashboardTransaction? editingTransaction,
      List<DashboardTransaction> transactions,
      List<DashboardBudget> budgets});
}

/// @nodoc
class __$$DashboardStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardStateImpl>
    implements _$$DashboardStateImplCopyWith<$Res> {
  __$$DashboardStateImplCopyWithImpl(
      _$DashboardStateImpl _value, $Res Function(_$DashboardStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentIndex = null,
    Object? surface = null,
    Object? editingTransaction = freezed,
    Object? transactions = null,
    Object? budgets = null,
  }) {
    return _then(_$DashboardStateImpl(
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      surface: null == surface
          ? _value.surface
          : surface // ignore: cast_nullable_to_non_nullable
              as DashboardSurface,
      editingTransaction: freezed == editingTransaction
          ? _value.editingTransaction
          : editingTransaction // ignore: cast_nullable_to_non_nullable
              as DashboardTransaction?,
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<DashboardTransaction>,
      budgets: null == budgets
          ? _value._budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<DashboardBudget>,
    ));
  }
}

/// @nodoc

class _$DashboardStateImpl extends _DashboardState {
  const _$DashboardStateImpl(
      {required this.currentIndex,
      required this.surface,
      this.editingTransaction,
      required final List<DashboardTransaction> transactions,
      required final List<DashboardBudget> budgets})
      : _transactions = transactions,
        _budgets = budgets,
        super._();

  @override
  final int currentIndex;
  @override
  final DashboardSurface surface;
  @override
  final DashboardTransaction? editingTransaction;
  final List<DashboardTransaction> _transactions;
  @override
  List<DashboardTransaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  final List<DashboardBudget> _budgets;
  @override
  List<DashboardBudget> get budgets {
    if (_budgets is EqualUnmodifiableListView) return _budgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgets);
  }

  @override
  String toString() {
    return 'DashboardState(currentIndex: $currentIndex, surface: $surface, editingTransaction: $editingTransaction, transactions: $transactions, budgets: $budgets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStateImpl &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.surface, surface) || other.surface == surface) &&
            (identical(other.editingTransaction, editingTransaction) ||
                other.editingTransaction == editingTransaction) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions) &&
            const DeepCollectionEquality().equals(other._budgets, _budgets));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentIndex,
      surface,
      editingTransaction,
      const DeepCollectionEquality().hash(_transactions),
      const DeepCollectionEquality().hash(_budgets));

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      __$$DashboardStateImplCopyWithImpl<_$DashboardStateImpl>(
          this, _$identity);
}

abstract class _DashboardState extends DashboardState {
  const factory _DashboardState(
      {required final int currentIndex,
      required final DashboardSurface surface,
      final DashboardTransaction? editingTransaction,
      required final List<DashboardTransaction> transactions,
      required final List<DashboardBudget> budgets}) = _$DashboardStateImpl;
  const _DashboardState._() : super._();

  @override
  int get currentIndex;
  @override
  DashboardSurface get surface;
  @override
  DashboardTransaction? get editingTransaction;
  @override
  List<DashboardTransaction> get transactions;
  @override
  List<DashboardBudget> get budgets;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
