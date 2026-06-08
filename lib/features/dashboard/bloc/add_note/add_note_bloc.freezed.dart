// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_note_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddNoteEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddNoteMode initialMode) started,
    required TResult Function(AddNoteMode mode) modeChanged,
    required TResult Function(String category) categoryChanged,
    required TResult Function(String key) keypadTapped,
    required TResult Function(String name, String note) saveSubmitted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddNoteMode initialMode)? started,
    TResult? Function(AddNoteMode mode)? modeChanged,
    TResult? Function(String category)? categoryChanged,
    TResult? Function(String key)? keypadTapped,
    TResult? Function(String name, String note)? saveSubmitted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddNoteMode initialMode)? started,
    TResult Function(AddNoteMode mode)? modeChanged,
    TResult Function(String category)? categoryChanged,
    TResult Function(String key)? keypadTapped,
    TResult Function(String name, String note)? saveSubmitted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ModeChanged value) modeChanged,
    required TResult Function(_CategoryChanged value) categoryChanged,
    required TResult Function(_KeypadTapped value) keypadTapped,
    required TResult Function(_SaveSubmitted value) saveSubmitted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ModeChanged value)? modeChanged,
    TResult? Function(_CategoryChanged value)? categoryChanged,
    TResult? Function(_KeypadTapped value)? keypadTapped,
    TResult? Function(_SaveSubmitted value)? saveSubmitted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ModeChanged value)? modeChanged,
    TResult Function(_CategoryChanged value)? categoryChanged,
    TResult Function(_KeypadTapped value)? keypadTapped,
    TResult Function(_SaveSubmitted value)? saveSubmitted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddNoteEventCopyWith<$Res> {
  factory $AddNoteEventCopyWith(
          AddNoteEvent value, $Res Function(AddNoteEvent) then) =
      _$AddNoteEventCopyWithImpl<$Res, AddNoteEvent>;
}

/// @nodoc
class _$AddNoteEventCopyWithImpl<$Res, $Val extends AddNoteEvent>
    implements $AddNoteEventCopyWith<$Res> {
  _$AddNoteEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StartedImplCopyWith<$Res> {
  factory _$$StartedImplCopyWith(
          _$StartedImpl value, $Res Function(_$StartedImpl) then) =
      __$$StartedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AddNoteMode initialMode});
}

/// @nodoc
class __$$StartedImplCopyWithImpl<$Res>
    extends _$AddNoteEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
      _$StartedImpl _value, $Res Function(_$StartedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialMode = null,
  }) {
    return _then(_$StartedImpl(
      null == initialMode
          ? _value.initialMode
          : initialMode // ignore: cast_nullable_to_non_nullable
              as AddNoteMode,
    ));
  }
}

/// @nodoc

class _$StartedImpl implements _Started {
  const _$StartedImpl(this.initialMode);

  @override
  final AddNoteMode initialMode;

  @override
  String toString() {
    return 'AddNoteEvent.started(initialMode: $initialMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartedImpl &&
            (identical(other.initialMode, initialMode) ||
                other.initialMode == initialMode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, initialMode);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartedImplCopyWith<_$StartedImpl> get copyWith =>
      __$$StartedImplCopyWithImpl<_$StartedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddNoteMode initialMode) started,
    required TResult Function(AddNoteMode mode) modeChanged,
    required TResult Function(String category) categoryChanged,
    required TResult Function(String key) keypadTapped,
    required TResult Function(String name, String note) saveSubmitted,
  }) {
    return started(initialMode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddNoteMode initialMode)? started,
    TResult? Function(AddNoteMode mode)? modeChanged,
    TResult? Function(String category)? categoryChanged,
    TResult? Function(String key)? keypadTapped,
    TResult? Function(String name, String note)? saveSubmitted,
  }) {
    return started?.call(initialMode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddNoteMode initialMode)? started,
    TResult Function(AddNoteMode mode)? modeChanged,
    TResult Function(String category)? categoryChanged,
    TResult Function(String key)? keypadTapped,
    TResult Function(String name, String note)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(initialMode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ModeChanged value) modeChanged,
    required TResult Function(_CategoryChanged value) categoryChanged,
    required TResult Function(_KeypadTapped value) keypadTapped,
    required TResult Function(_SaveSubmitted value) saveSubmitted,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ModeChanged value)? modeChanged,
    TResult? Function(_CategoryChanged value)? categoryChanged,
    TResult? Function(_KeypadTapped value)? keypadTapped,
    TResult? Function(_SaveSubmitted value)? saveSubmitted,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ModeChanged value)? modeChanged,
    TResult Function(_CategoryChanged value)? categoryChanged,
    TResult Function(_KeypadTapped value)? keypadTapped,
    TResult Function(_SaveSubmitted value)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements AddNoteEvent {
  const factory _Started(final AddNoteMode initialMode) = _$StartedImpl;

  AddNoteMode get initialMode;

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartedImplCopyWith<_$StartedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ModeChangedImplCopyWith<$Res> {
  factory _$$ModeChangedImplCopyWith(
          _$ModeChangedImpl value, $Res Function(_$ModeChangedImpl) then) =
      __$$ModeChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AddNoteMode mode});
}

/// @nodoc
class __$$ModeChangedImplCopyWithImpl<$Res>
    extends _$AddNoteEventCopyWithImpl<$Res, _$ModeChangedImpl>
    implements _$$ModeChangedImplCopyWith<$Res> {
  __$$ModeChangedImplCopyWithImpl(
      _$ModeChangedImpl _value, $Res Function(_$ModeChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
  }) {
    return _then(_$ModeChangedImpl(
      null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as AddNoteMode,
    ));
  }
}

/// @nodoc

class _$ModeChangedImpl implements _ModeChanged {
  const _$ModeChangedImpl(this.mode);

  @override
  final AddNoteMode mode;

  @override
  String toString() {
    return 'AddNoteEvent.modeChanged(mode: $mode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModeChangedImpl &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModeChangedImplCopyWith<_$ModeChangedImpl> get copyWith =>
      __$$ModeChangedImplCopyWithImpl<_$ModeChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddNoteMode initialMode) started,
    required TResult Function(AddNoteMode mode) modeChanged,
    required TResult Function(String category) categoryChanged,
    required TResult Function(String key) keypadTapped,
    required TResult Function(String name, String note) saveSubmitted,
  }) {
    return modeChanged(mode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddNoteMode initialMode)? started,
    TResult? Function(AddNoteMode mode)? modeChanged,
    TResult? Function(String category)? categoryChanged,
    TResult? Function(String key)? keypadTapped,
    TResult? Function(String name, String note)? saveSubmitted,
  }) {
    return modeChanged?.call(mode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddNoteMode initialMode)? started,
    TResult Function(AddNoteMode mode)? modeChanged,
    TResult Function(String category)? categoryChanged,
    TResult Function(String key)? keypadTapped,
    TResult Function(String name, String note)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (modeChanged != null) {
      return modeChanged(mode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ModeChanged value) modeChanged,
    required TResult Function(_CategoryChanged value) categoryChanged,
    required TResult Function(_KeypadTapped value) keypadTapped,
    required TResult Function(_SaveSubmitted value) saveSubmitted,
  }) {
    return modeChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ModeChanged value)? modeChanged,
    TResult? Function(_CategoryChanged value)? categoryChanged,
    TResult? Function(_KeypadTapped value)? keypadTapped,
    TResult? Function(_SaveSubmitted value)? saveSubmitted,
  }) {
    return modeChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ModeChanged value)? modeChanged,
    TResult Function(_CategoryChanged value)? categoryChanged,
    TResult Function(_KeypadTapped value)? keypadTapped,
    TResult Function(_SaveSubmitted value)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (modeChanged != null) {
      return modeChanged(this);
    }
    return orElse();
  }
}

abstract class _ModeChanged implements AddNoteEvent {
  const factory _ModeChanged(final AddNoteMode mode) = _$ModeChangedImpl;

  AddNoteMode get mode;

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModeChangedImplCopyWith<_$ModeChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CategoryChangedImplCopyWith<$Res> {
  factory _$$CategoryChangedImplCopyWith(_$CategoryChangedImpl value,
          $Res Function(_$CategoryChangedImpl) then) =
      __$$CategoryChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String category});
}

/// @nodoc
class __$$CategoryChangedImplCopyWithImpl<$Res>
    extends _$AddNoteEventCopyWithImpl<$Res, _$CategoryChangedImpl>
    implements _$$CategoryChangedImplCopyWith<$Res> {
  __$$CategoryChangedImplCopyWithImpl(
      _$CategoryChangedImpl _value, $Res Function(_$CategoryChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
  }) {
    return _then(_$CategoryChangedImpl(
      null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CategoryChangedImpl implements _CategoryChanged {
  const _$CategoryChangedImpl(this.category);

  @override
  final String category;

  @override
  String toString() {
    return 'AddNoteEvent.categoryChanged(category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryChangedImpl &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryChangedImplCopyWith<_$CategoryChangedImpl> get copyWith =>
      __$$CategoryChangedImplCopyWithImpl<_$CategoryChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddNoteMode initialMode) started,
    required TResult Function(AddNoteMode mode) modeChanged,
    required TResult Function(String category) categoryChanged,
    required TResult Function(String key) keypadTapped,
    required TResult Function(String name, String note) saveSubmitted,
  }) {
    return categoryChanged(category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddNoteMode initialMode)? started,
    TResult? Function(AddNoteMode mode)? modeChanged,
    TResult? Function(String category)? categoryChanged,
    TResult? Function(String key)? keypadTapped,
    TResult? Function(String name, String note)? saveSubmitted,
  }) {
    return categoryChanged?.call(category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddNoteMode initialMode)? started,
    TResult Function(AddNoteMode mode)? modeChanged,
    TResult Function(String category)? categoryChanged,
    TResult Function(String key)? keypadTapped,
    TResult Function(String name, String note)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (categoryChanged != null) {
      return categoryChanged(category);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ModeChanged value) modeChanged,
    required TResult Function(_CategoryChanged value) categoryChanged,
    required TResult Function(_KeypadTapped value) keypadTapped,
    required TResult Function(_SaveSubmitted value) saveSubmitted,
  }) {
    return categoryChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ModeChanged value)? modeChanged,
    TResult? Function(_CategoryChanged value)? categoryChanged,
    TResult? Function(_KeypadTapped value)? keypadTapped,
    TResult? Function(_SaveSubmitted value)? saveSubmitted,
  }) {
    return categoryChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ModeChanged value)? modeChanged,
    TResult Function(_CategoryChanged value)? categoryChanged,
    TResult Function(_KeypadTapped value)? keypadTapped,
    TResult Function(_SaveSubmitted value)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (categoryChanged != null) {
      return categoryChanged(this);
    }
    return orElse();
  }
}

abstract class _CategoryChanged implements AddNoteEvent {
  const factory _CategoryChanged(final String category) = _$CategoryChangedImpl;

  String get category;

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryChangedImplCopyWith<_$CategoryChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$KeypadTappedImplCopyWith<$Res> {
  factory _$$KeypadTappedImplCopyWith(
          _$KeypadTappedImpl value, $Res Function(_$KeypadTappedImpl) then) =
      __$$KeypadTappedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String key});
}

/// @nodoc
class __$$KeypadTappedImplCopyWithImpl<$Res>
    extends _$AddNoteEventCopyWithImpl<$Res, _$KeypadTappedImpl>
    implements _$$KeypadTappedImplCopyWith<$Res> {
  __$$KeypadTappedImplCopyWithImpl(
      _$KeypadTappedImpl _value, $Res Function(_$KeypadTappedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
  }) {
    return _then(_$KeypadTappedImpl(
      null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$KeypadTappedImpl implements _KeypadTapped {
  const _$KeypadTappedImpl(this.key);

  @override
  final String key;

  @override
  String toString() {
    return 'AddNoteEvent.keypadTapped(key: $key)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeypadTappedImpl &&
            (identical(other.key, key) || other.key == key));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeypadTappedImplCopyWith<_$KeypadTappedImpl> get copyWith =>
      __$$KeypadTappedImplCopyWithImpl<_$KeypadTappedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddNoteMode initialMode) started,
    required TResult Function(AddNoteMode mode) modeChanged,
    required TResult Function(String category) categoryChanged,
    required TResult Function(String key) keypadTapped,
    required TResult Function(String name, String note) saveSubmitted,
  }) {
    return keypadTapped(key);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddNoteMode initialMode)? started,
    TResult? Function(AddNoteMode mode)? modeChanged,
    TResult? Function(String category)? categoryChanged,
    TResult? Function(String key)? keypadTapped,
    TResult? Function(String name, String note)? saveSubmitted,
  }) {
    return keypadTapped?.call(key);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddNoteMode initialMode)? started,
    TResult Function(AddNoteMode mode)? modeChanged,
    TResult Function(String category)? categoryChanged,
    TResult Function(String key)? keypadTapped,
    TResult Function(String name, String note)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (keypadTapped != null) {
      return keypadTapped(key);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ModeChanged value) modeChanged,
    required TResult Function(_CategoryChanged value) categoryChanged,
    required TResult Function(_KeypadTapped value) keypadTapped,
    required TResult Function(_SaveSubmitted value) saveSubmitted,
  }) {
    return keypadTapped(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ModeChanged value)? modeChanged,
    TResult? Function(_CategoryChanged value)? categoryChanged,
    TResult? Function(_KeypadTapped value)? keypadTapped,
    TResult? Function(_SaveSubmitted value)? saveSubmitted,
  }) {
    return keypadTapped?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ModeChanged value)? modeChanged,
    TResult Function(_CategoryChanged value)? categoryChanged,
    TResult Function(_KeypadTapped value)? keypadTapped,
    TResult Function(_SaveSubmitted value)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (keypadTapped != null) {
      return keypadTapped(this);
    }
    return orElse();
  }
}

abstract class _KeypadTapped implements AddNoteEvent {
  const factory _KeypadTapped(final String key) = _$KeypadTappedImpl;

  String get key;

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeypadTappedImplCopyWith<_$KeypadTappedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SaveSubmittedImplCopyWith<$Res> {
  factory _$$SaveSubmittedImplCopyWith(
          _$SaveSubmittedImpl value, $Res Function(_$SaveSubmittedImpl) then) =
      __$$SaveSubmittedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name, String note});
}

/// @nodoc
class __$$SaveSubmittedImplCopyWithImpl<$Res>
    extends _$AddNoteEventCopyWithImpl<$Res, _$SaveSubmittedImpl>
    implements _$$SaveSubmittedImplCopyWith<$Res> {
  __$$SaveSubmittedImplCopyWithImpl(
      _$SaveSubmittedImpl _value, $Res Function(_$SaveSubmittedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? note = null,
  }) {
    return _then(_$SaveSubmittedImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SaveSubmittedImpl implements _SaveSubmitted {
  const _$SaveSubmittedImpl({required this.name, required this.note});

  @override
  final String name;
  @override
  final String note;

  @override
  String toString() {
    return 'AddNoteEvent.saveSubmitted(name: $name, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveSubmittedImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, note);

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveSubmittedImplCopyWith<_$SaveSubmittedImpl> get copyWith =>
      __$$SaveSubmittedImplCopyWithImpl<_$SaveSubmittedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddNoteMode initialMode) started,
    required TResult Function(AddNoteMode mode) modeChanged,
    required TResult Function(String category) categoryChanged,
    required TResult Function(String key) keypadTapped,
    required TResult Function(String name, String note) saveSubmitted,
  }) {
    return saveSubmitted(name, note);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddNoteMode initialMode)? started,
    TResult? Function(AddNoteMode mode)? modeChanged,
    TResult? Function(String category)? categoryChanged,
    TResult? Function(String key)? keypadTapped,
    TResult? Function(String name, String note)? saveSubmitted,
  }) {
    return saveSubmitted?.call(name, note);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddNoteMode initialMode)? started,
    TResult Function(AddNoteMode mode)? modeChanged,
    TResult Function(String category)? categoryChanged,
    TResult Function(String key)? keypadTapped,
    TResult Function(String name, String note)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (saveSubmitted != null) {
      return saveSubmitted(name, note);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ModeChanged value) modeChanged,
    required TResult Function(_CategoryChanged value) categoryChanged,
    required TResult Function(_KeypadTapped value) keypadTapped,
    required TResult Function(_SaveSubmitted value) saveSubmitted,
  }) {
    return saveSubmitted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ModeChanged value)? modeChanged,
    TResult? Function(_CategoryChanged value)? categoryChanged,
    TResult? Function(_KeypadTapped value)? keypadTapped,
    TResult? Function(_SaveSubmitted value)? saveSubmitted,
  }) {
    return saveSubmitted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ModeChanged value)? modeChanged,
    TResult Function(_CategoryChanged value)? categoryChanged,
    TResult Function(_KeypadTapped value)? keypadTapped,
    TResult Function(_SaveSubmitted value)? saveSubmitted,
    required TResult orElse(),
  }) {
    if (saveSubmitted != null) {
      return saveSubmitted(this);
    }
    return orElse();
  }
}

abstract class _SaveSubmitted implements AddNoteEvent {
  const factory _SaveSubmitted(
      {required final String name,
      required final String note}) = _$SaveSubmittedImpl;

  String get name;
  String get note;

  /// Create a copy of AddNoteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveSubmittedImplCopyWith<_$SaveSubmittedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AddNoteState {
  AddNoteMode get mode => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get expenseCategory => throw _privateConstructorUsedError;
  String get incomeCategory => throw _privateConstructorUsedError;
  AddNoteStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of AddNoteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddNoteStateCopyWith<AddNoteState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddNoteStateCopyWith<$Res> {
  factory $AddNoteStateCopyWith(
          AddNoteState value, $Res Function(AddNoteState) then) =
      _$AddNoteStateCopyWithImpl<$Res, AddNoteState>;
  @useResult
  $Res call(
      {AddNoteMode mode,
      String amount,
      String expenseCategory,
      String incomeCategory,
      AddNoteStatus status,
      String? errorMessage});
}

/// @nodoc
class _$AddNoteStateCopyWithImpl<$Res, $Val extends AddNoteState>
    implements $AddNoteStateCopyWith<$Res> {
  _$AddNoteStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddNoteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? amount = null,
    Object? expenseCategory = null,
    Object? incomeCategory = null,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as AddNoteMode,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      expenseCategory: null == expenseCategory
          ? _value.expenseCategory
          : expenseCategory // ignore: cast_nullable_to_non_nullable
              as String,
      incomeCategory: null == incomeCategory
          ? _value.incomeCategory
          : incomeCategory // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AddNoteStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddNoteStateImplCopyWith<$Res>
    implements $AddNoteStateCopyWith<$Res> {
  factory _$$AddNoteStateImplCopyWith(
          _$AddNoteStateImpl value, $Res Function(_$AddNoteStateImpl) then) =
      __$$AddNoteStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AddNoteMode mode,
      String amount,
      String expenseCategory,
      String incomeCategory,
      AddNoteStatus status,
      String? errorMessage});
}

/// @nodoc
class __$$AddNoteStateImplCopyWithImpl<$Res>
    extends _$AddNoteStateCopyWithImpl<$Res, _$AddNoteStateImpl>
    implements _$$AddNoteStateImplCopyWith<$Res> {
  __$$AddNoteStateImplCopyWithImpl(
      _$AddNoteStateImpl _value, $Res Function(_$AddNoteStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddNoteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? amount = null,
    Object? expenseCategory = null,
    Object? incomeCategory = null,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$AddNoteStateImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as AddNoteMode,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      expenseCategory: null == expenseCategory
          ? _value.expenseCategory
          : expenseCategory // ignore: cast_nullable_to_non_nullable
              as String,
      incomeCategory: null == incomeCategory
          ? _value.incomeCategory
          : incomeCategory // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AddNoteStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AddNoteStateImpl implements _AddNoteState {
  const _$AddNoteStateImpl(
      {this.mode = AddNoteMode.expense,
      this.amount = '0',
      this.expenseCategory = 'Makanan',
      this.incomeCategory = 'Gaji',
      this.status = AddNoteStatus.initial,
      this.errorMessage});

  @override
  @JsonKey()
  final AddNoteMode mode;
  @override
  @JsonKey()
  final String amount;
  @override
  @JsonKey()
  final String expenseCategory;
  @override
  @JsonKey()
  final String incomeCategory;
  @override
  @JsonKey()
  final AddNoteStatus status;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AddNoteState(mode: $mode, amount: $amount, expenseCategory: $expenseCategory, incomeCategory: $incomeCategory, status: $status, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddNoteStateImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.expenseCategory, expenseCategory) ||
                other.expenseCategory == expenseCategory) &&
            (identical(other.incomeCategory, incomeCategory) ||
                other.incomeCategory == incomeCategory) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, amount, expenseCategory,
      incomeCategory, status, errorMessage);

  /// Create a copy of AddNoteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddNoteStateImplCopyWith<_$AddNoteStateImpl> get copyWith =>
      __$$AddNoteStateImplCopyWithImpl<_$AddNoteStateImpl>(this, _$identity);
}

abstract class _AddNoteState implements AddNoteState {
  const factory _AddNoteState(
      {final AddNoteMode mode,
      final String amount,
      final String expenseCategory,
      final String incomeCategory,
      final AddNoteStatus status,
      final String? errorMessage}) = _$AddNoteStateImpl;

  @override
  AddNoteMode get mode;
  @override
  String get amount;
  @override
  String get expenseCategory;
  @override
  String get incomeCategory;
  @override
  AddNoteStatus get status;
  @override
  String? get errorMessage;

  /// Create a copy of AddNoteState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddNoteStateImplCopyWith<_$AddNoteStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
