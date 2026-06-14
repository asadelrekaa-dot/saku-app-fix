import 'dart:async';
import 'dashboard_shared.dart';
import '../../../core/api/laravel_api_service.dart';
import '../../../core/repository/local_repository.dart';

class InsightDashboard extends StatefulWidget {
  const InsightDashboard({
    super.key,
    required this.onBack,
    this.transactions = const [],
    this.budgets = const [],
  });

  final VoidCallback onBack;
  final List<DashboardTransaction> transactions;
  final List<DashboardBudget> budgets;

  @override
  State<InsightDashboard> createState() => InsightDashboardState();
}

class InsightDashboardState extends State<InsightDashboard> {
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _showLocalSummary();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showLocalSummary() async {
    final repo = LocalRepository();
    final wallets = await repo.loadWallets();
    if (!mounted) return;

    final totalBalance = wallets.fold<int>(0, (s, w) => s + w.balance);
    final tx = widget.transactions;
    final now = DateTime.now();

    final thisMonth = tx.where((t) {
      final d = DateTime.tryParse(t.rawDate ?? '');
      return d != null && d.month == now.month && d.year == now.year;
    }).toList();
    final prevMonth = now.month == 1 ? 12 : now.month - 1;
    final prevYear = now.month == 1 ? now.year - 1 : now.year;
    final lastMonth = tx.where((t) {
      final d = DateTime.tryParse(t.rawDate ?? '');
      return d != null && d.month == prevMonth && d.year == prevYear;
    }).toList();

    final income =
        thisMonth.where((t) => t.amountValue > 0).fold<int>(0, (s, t) => s + t.amountValue);
    final expense =
        thisMonth.where((t) => t.amountValue < 0).fold<int>(0, (s, t) => s + t.amountValue.abs());
    final lastExpense =
        lastMonth.where((t) => t.amountValue < 0).fold<int>(0, (s, t) => s + t.amountValue.abs());

    final parts = <String>[];
    parts.add('📊 Ringkasan Keuangan Bulan Ini\n');
    parts.add('Total Saldo: ${_fmt(totalBalance)}');
    parts.add('Pemasukan: ${_fmt(income)}');
    parts.add('Pengeluaran: ${_fmt(expense)}');
    final net = income - expense;
    parts.add('Selisih: ${net >= 0 ? '+' : '-'}${_fmt(net.abs())}');

    if (lastExpense > 0) {
      final diff = ((expense - lastExpense) / lastExpense * 100).round();
      final arrow = diff > 0 ? '↑' : '↓';
      parts.add(
          'Dibanding bulan lalu: $arrow ${diff.abs()}% (${_fmt(lastExpense)} → ${_fmt(expense)})');
    }

    if (widget.budgets.isNotEmpty) {
      parts.add('\n📌 Anggaran:');
      for (final b in widget.budgets) {
        final pct = (b.progress * 100).round();
        parts.add('  • ${b.title}: $pct% terpakai');
      }
    }

    if (wallets.length > 1) {
      parts.add('\n👛 Dompet:');
      for (final w in wallets) {
        parts.add('  • ${w.name}: ${_fmt(w.balance)}');
      }
    }

    parts.add(
        '\n💡 Ketik pertanyaan atau tap pilihan di atas untuk analisis lebih lanjut.');

    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(
        text: parts.join('\n'),
        fromUser: false,
        time: 'Sekarang',
      ));
    });
    _scrollToBottom();
  }

  String _fmt(int n) {
    final text = n.abs().toString();
    final buf = StringBuffer(n < 0 ? '-' : '');
    for (var i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) buf.write('.');
      buf.write(text[i]);
    }
    return 'Rp $buf';
  }

  String _monthName(int m) {
    const names = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return names[m - 1];
  }

  Future<Map<String, dynamic>> _buildContext() async {
    final now = DateTime.now();
    final thisMonth = widget.transactions.where((t) {
      final d = DateTime.tryParse(t.rawDate ?? '');
      return d != null && d.month == now.month && d.year == now.year;
    }).toList();

    final totalIncome =
        thisMonth.where((t) => t.amountValue > 0).fold<int>(0, (s, t) => s + t.amountValue);
    final totalExpense =
        thisMonth.where((t) => t.amountValue < 0).fold<int>(0, (s, t) => s + t.amountValue.abs());

    final repo = LocalRepository();
    final wallets = await repo.loadWallets();

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'wallets': wallets
          .map((w) => {'name': w.name, 'balance': w.balance})
          .toList(),
      'budgets': widget.budgets
          .map((b) => {
                'title': b.title,
                'remaining': b.amountValue - (b.amountValue * b.progress).round(),
              })
          .toList(),
      'recentTransactions': widget.transactions.take(15).map((t) {
        return {
          'title': t.title,
          'amount': t.amountValue,
          'date': t.rawDate?.substring(0, 10) ?? '',
        };
      }).toList(),
    };
  }

  String _generateLocalResponse(String message) {
    final lower = message.toLowerCase();
    final tx = widget.transactions;
    final now = DateTime.now();

    final thisMonth = tx.where((t) {
      final d = DateTime.tryParse(t.rawDate ?? '');
      return d != null && d.month == now.month && d.year == now.year;
    }).toList();

    if (lower.contains('boros') || lower.contains('pengeluaran') || lower.contains('habis')) {
      final byTitle = <String, int>{};
      for (final t in thisMonth.where((t) => t.amountValue < 0)) {
        byTitle.update(t.title, (v) => v + t.amountValue.abs(), ifAbsent: () => t.amountValue.abs());
      }
      if (byTitle.isEmpty) return 'Belum ada pengeluaran bulan ini.';
      final sorted = byTitle.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      final total = sorted.fold<int>(0, (s, e) => s + e.value);
      final lines = sorted.take(5).map((e) {
        final pct = (e.value / total * 100).round();
        return '  • ${e.key}: ${_fmt(e.value)} ($pct%)';
      }).join('\n');
      return 'Pengeluaran terbesar bulan ${_monthName(now.month)}:\n$lines\n\nTotal: ${_fmt(total)}';
    }

    if (lower.contains('tips') || lower.contains('hemat')) {
      final expense =
          thisMonth.where((t) => t.amountValue < 0).fold<int>(0, (s, t) => s + t.amountValue.abs());
      if (expense > 0) {
        return 'Tips hemat:\n'
            '1. Catat setiap pengeluaran biar tahu kemana uang pergi\n'
            '2. Buat anggaran bulanan untuk tiap kategori\n'
            '3. Bedakan kebutuhan vs keinginan sebelum beli\n'
            '4. Coba metode 50/30/20 (50% kebutuhan, 30% keinginan, 20% tabungan)\n'
            '5. Review pengeluaran tiap akhir minggu';
      }
      return 'Belum ada data pengeluaran. Mulai catat dulu ya!';
    }

    if (lower.contains('budget') || lower.contains('anggaran')) {
      if (widget.budgets.isEmpty) return 'Belum ada anggaran. Buat lewat menu Budgeting di halaman utama!';
      final lines = widget.budgets.map((b) {
        final pct = (b.progress * 100).round();
        return '  • ${b.title}: $pct% terpakai (sisa ${_fmt(b.amountValue - (b.amountValue * b.progress).round())})';
      }).join('\n');
      return 'Status anggaran:\n$lines';
    }

    if (lower.contains('dompet') || lower.contains('wallet')) {
      return 'Ganti dompet atau tambah dompet baru dari halaman Profil.';
    }

    if (lower.contains('grafik') || lower.contains('chart')) {
      return 'Grafik pengeluaran bisa dilihat di tab Grafik (icon grafik di pojok kanan atas halaman utama).';
    }

    if (lower.contains('hutang') || lower.contains('pinjaman') || lower.contains('lunas')) {
      return 'Hutang/Pinjaman aktif muncul di halaman utama. Setelah dibayar, tandai lunas dari halaman Riwayat.';
    }

    if (lower.contains('widget') || lower.contains('homescreen')) {
      return 'Widget homescreen bisa ditambah dari halaman Profil → Tambah Widget.';
    }

    if (lower.contains('pembelian') || lower.contains('catat')) {
      return 'Kamu bisa catat transaksi dari tombol + (Tambah Catatan) di halaman utama. '
          'Pilih jenisnya (Pemasukan/Pengeluaran/Transfer), isi nominal, kategori, dompet, dan deskripsi.';
    }

    return 'Maaf, aku belum bisa jawab pertanyaan itu tanpa koneksi server. '
        'Coba tanya: "Bulan ini boros dimana?", "Tips hemat", atau "Status anggaran".';
  }

  Future<void> _sendMessage(String text) async {
    final message = text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tulis pertanyaan dulu sebelum dikirim')),
      );
      return;
    }

    setState(() {
      _messages.add(ChatMessage(text: message, fromUser: true, time: 'Sekarang'));
      _isLoading = true;
    });
    _scrollToBottom();

    String reply;
    try {
      final history = _messages
          .where((m) => m != _messages.last)
          .map((m) => {
                'role': m.fromUser ? 'user' : 'assistant',
                'content': m.text,
              })
          .toList();

      final ctx = await _buildContext();
      reply = await LaravelApiService.instance.chatWithAi(
        message: message,
        history: history,
        context: ctx,
      );
    } catch (_) {
      reply = _generateLocalResponse(message);
    }

    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(text: reply, fromUser: false, time: 'Sekarang'));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChildPageTopBar(title: 'Saku AI', onBack: widget.onBack),
        Expanded(
          child: Container(
            color: SakuColors.blue50,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(42, 30, 42, 24),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _QuickQuestionBubble(onQuestion: _sendMessage),
                      ),
                      const SizedBox(height: 18),
                      ..._messages.map(_ChatBubble.new),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _TypingIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
                _InsightComposer(onSend: _sendMessage, isLoading: _isLoading),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SakuColors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
          bottomLeft: const Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: SakuColors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(delay: 0),
            SizedBox(width: 6),
            _Dot(delay: 200),
            SizedBox(width: 6),
            _Dot(delay: 400),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({required this.delay});
  final int delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: SakuColors.neutral300,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _QuickQuestionBubble extends StatelessWidget {
  const _QuickQuestionBubble({required this.onQuestion});

  final ValueChanged<String> onQuestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      decoration: BoxDecoration(
        color: SakuColors.blue100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pertanyaan Cepat',
            style: TextStyle(
              color: SakuColors.blue700,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          for (final question in _quickQuestions) ...[
            _QuestionPill(question, onTap: onQuestion),
            if (question != _quickQuestions.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

const _quickQuestions = [
  'Catatan pembelian cepat',
  'Tips hemat buat aku dong',
  'Bulan ini boros dimana?',
  'Cara bikin budget?',
  'Grafik itu buat apa?',
  'Tambah dompet gimana?',
  'Widget homescreen apa?',
  'Hutang bisa ditandai lunas?',
];

class _QuestionPill extends StatelessWidget {
  const _QuestionPill(this.text, {required this.onTap});

  final String text;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.blue300,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: () => onTap(text),
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SakuColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble(this.message);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.fromUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = message.fromUser ? SakuColors.blue300 : SakuColors.white;
    final textColor = message.fromUser ? SakuColors.white : SakuColors.black;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 286),
          child: Column(
            crossAxisAlignment: message.fromUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(message.fromUser ? 18 : 4),
                    bottomRight: Radius.circular(message.fromUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: SakuColors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.38,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.time,
                style: const TextStyle(
                  color: SakuColors.neutral300,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightComposer extends StatefulWidget {
  const _InsightComposer({required this.onSend, required this.isLoading});

  final ValueChanged<String> onSend;
  final bool isLoading;

  @override
  State<_InsightComposer> createState() => _InsightComposerState();
}

class _InsightComposerState extends State<_InsightComposer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final message = _controller.text.trim();
    widget.onSend(message);
    if (message.isNotEmpty) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SakuColors.white,
      padding: const EdgeInsets.fromLTRB(32, 14, 32, 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Tanya AI...',
                filled: true,
                fillColor: SakuColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: SakuColors.neutral300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: SakuColors.neutral300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: SakuColors.blue300),
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: widget.isLoading ? null : (_) => _send(),
            ),
          ),
          const SizedBox(width: 18),
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton.filled(
              onPressed: widget.isLoading ? null : _send,
              style: IconButton.styleFrom(backgroundColor: SakuColors.blue300),
              icon: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: SakuColors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: SakuColors.white,
                      size: 24,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
