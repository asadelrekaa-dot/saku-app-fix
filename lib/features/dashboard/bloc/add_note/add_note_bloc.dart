import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/expression_calculator.dart';
import '../../widgets/dashboard_shared.dart';

part 'add_note_event.dart';
part 'add_note_state.dart';
part 'add_note_bloc.freezed.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  AddNoteBloc() : super(const AddNoteState()) {
    on<_Started>(_onStarted);
    on<_ModeChanged>(_onModeChanged);
    on<_CategoryChanged>(_onCategoryChanged);
    on<_KeypadTapped>(_onKeypadTapped);
    on<_SaveSubmitted>(_onSaveSubmitted);
  }

  void _onStarted(_Started event, Emitter<AddNoteState> emit) {
    emit(state.copyWith(mode: event.initialMode));
  }

  void _onModeChanged(_ModeChanged event, Emitter<AddNoteState> emit) {
    emit(state.copyWith(
      mode: event.mode,
      status: AddNoteStatus.initial,
      errorMessage: null,
    ));
  }

  void _onCategoryChanged(_CategoryChanged event, Emitter<AddNoteState> emit) {
    if (state.mode == AddNoteMode.income) {
      emit(state.copyWith(incomeCategory: event.category));
    } else {
      emit(state.copyWith(expenseCategory: event.category));
    }
  }

  void _onKeypadTapped(_KeypadTapped event, Emitter<AddNoteState> emit) {
    final key = event.key;
    String currentAmount = state.amount;

    // 1. Reset Kalkulator
    if (key == 'C') {
      currentAmount = '0';
    } 
    // 2. Backspace / Hapus Karakter Terakhir
    else if (key == 'back') {
      currentAmount = currentAmount.length <= 1 
          ? '0' 
          : currentAmount.substring(0, currentAmount.length - 1);
    } 
    // 3. Tombol Operator Matematika
    else if (key == '+' || key == '-' || key == 'x') {
      // Jika karakter terakhir sudah berupa operator, ganti dengan operator yang baru dipilih
      if (currentAmount.endsWith('+') || currentAmount.endsWith('-') || currentAmount.endsWith('x')) {
        currentAmount = currentAmount.substring(0, currentAmount.length - 1) + key;
      } else {
        currentAmount = '$currentAmount$key';
      }
    } 
    // 4. Tombol Sama Dengan (=) / Eksekusi Hasil Hitung
    else if (key == '=') {
      currentAmount = ExpressionCalculator.evaluate(currentAmount);
    } 
    // 5. Input Angka (0-9) atau Ribuan (000)
    else if (RegExp(r'^\d+$').hasMatch(key)) {
      if (currentAmount == '0') {
        // Jangan biarkan awalan '000' jika layar masih bernilai '0'
        currentAmount = key == '000' ? '0' : key;
      } else {
        // Cek jika karakter terakhir adalah operator, jangan biarkan langsung memasukkan '000'
        if ((currentAmount.endsWith('+') || currentAmount.endsWith('-') || currentAmount.endsWith('x')) && key == '000') {
          currentAmount = '${currentAmount}0';
        } else {
          currentAmount = '$currentAmount$key';
        }
      }
    }

    emit(state.copyWith(
      amount: currentAmount,
      status: AddNoteStatus.initial, // Reset status saat user mengetik ulang
    ));
  }

  void _onSaveSubmitted(_SaveSubmitted event, Emitter<AddNoteState> emit) {
    // Jalankan kalkulasi otomatis terlebih dahulu jika ada rumus yang belum diselesaikan (misal: '5000+2000' langsung klik Simpan)
    final finalAmountStr = ExpressionCalculator.evaluate(state.amount);
    final numericAmount = int.tryParse(finalAmountStr) ?? 0;
    
    // Validasi input nominal kosong atau nol
    if (numericAmount == 0) {
      emit(state.copyWith(
        status: AddNoteStatus.failure,
        errorMessage: 'Nominal belum diisi atau tidak valid',
      ));
      return;
    }

    emit(state.copyWith(status: AddNoteStatus.loading));

    try {
      // Logika pemrosesan database/API ditaruh di sini jika ada.
      // Jika berhasil, kirim sinyal sukses ke UI agar diproses oleh BlocListener
      emit(state.copyWith(
        amount: finalAmountStr, // Update dengan nilai bersih hasil kalkulasi terakhir
        status: AddNoteStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddNoteStatus.failure,
        errorMessage: 'Gagal memproses catatan transaksi',
      ));
    }
  }

}