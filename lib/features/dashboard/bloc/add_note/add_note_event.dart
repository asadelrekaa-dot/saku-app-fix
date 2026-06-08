
part of 'add_note_bloc.dart';

@freezed
class AddNoteEvent with _$AddNoteEvent {
  // Ditrigger saat halaman pertama kali dibuka untuk inisialisasi mode awal
  const factory AddNoteEvent.started(AddNoteMode initialMode) = _Started;

  // Ditrigger saat user mengubah tab (Pengeluaran / Pemasukan / Hutang / Pinjaman)
  const factory AddNoteEvent.modeChanged(AddNoteMode mode) = _ModeChanged;

  // Ditrigger saat user memilih kategori dari Picker Component
  const factory AddNoteEvent.categoryChanged(String category) = _CategoryChanged;

  // Ditrigger setiap kali tombol di calculator pad di-tap (angka, C, back, dll)
  const factory AddNoteEvent.keypadTapped(String key) = _KeypadTapped;

  // Ditrigger saat user menekan tombol 'Simpan'
  const factory AddNoteEvent.saveSubmitted({
    required String name,
    required String note,
  }) = _SaveSubmitted;
}