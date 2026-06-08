part of 'add_note_bloc.dart';

// Status proses saat menyimpan data
enum AddNoteStatus { initial, loading, success, failure }

@freezed
class AddNoteState with _$AddNoteState {
  const factory AddNoteState({
    @Default(AddNoteMode.expense) AddNoteMode mode,
    @Default('0') String amount,
    @Default('Makanan') String expenseCategory,
    @Default('Gaji') String incomeCategory,
    @Default(AddNoteStatus.initial) AddNoteStatus status,
    String? errorMessage,
  }) = _AddNoteState;
}

// Extension untuk mempermudah helper getter seperti di kode UI lama kamu
extension AddNoteStateX on AddNoteState {
  bool get isLoan => mode == AddNoteMode.loan;
  bool get isIncome => mode == AddNoteMode.income;
  bool get isExpense => mode == AddNoteMode.expense;
  bool get isDailyNote => isExpense || isIncome;
  String get selectedCategory => isIncome ? incomeCategory : expenseCategory;
}