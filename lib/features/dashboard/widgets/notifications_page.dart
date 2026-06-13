import 'dashboard_shared.dart';
import '../../../core/api/laravel_api_service.dart';
import '../data/model/notification_model.dart';

class NotificationsDashboard extends StatefulWidget {
  const NotificationsDashboard({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<NotificationsDashboard> createState() => _NotificationsDashboardState();
}

class _NotificationsDashboardState extends State<NotificationsDashboard> {
  late Future<List<NotificationItem>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchNotifications();
  }

  Future<List<NotificationItem>> fetchNotifications() async {
    try {
      final raw = await LaravelApiService.instance.getNotifications();
      return raw.map((json) => NotificationItem.fromJson(json)).toList();
    } catch (_) {
      return _fallbackNotifications();
    }
  }

  List<NotificationItem> _fallbackNotifications() {
    return const [
      NotificationItem(
        id: 1,
        title: 'Jangan lupa catat ya. sudah ada\npengeluaran hari ini?',
        time: '4:40 PM',
        icon: Icons.edit_note_rounded,
        iconColor: SakuColors.neutral700,
        isRead: false,
      ),
      NotificationItem(
        id: 2,
        title: 'Pengeluaran meningkat kamu\nmenghabiskan lebih banyak dari pada\nbiasanya',
        time: '6.30 PM',
        icon: Icons.trending_down_rounded,
        iconColor: SakuColors.danger,
        isRead: false,
      ),
      NotificationItem(
        id: 3,
        title: 'Pengeluaran tercatat\nkamu baru saja mengeluarkan Rp\n50.000 untuk makan',
        time: '8.25 PM',
        icon: Icons.edit_note_rounded,
        iconColor: SakuColors.neutral700,
        isRead: false,
      ),
    ];
  }

  // Fungsi refresh jika user menarik halaman ke bawah (Pull to Refresh)
  Future<void> _handleRefresh() async {
    setState(() {
      _notificationsFuture = fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChildPageTopBar(title: 'Notifikasi', onBack: widget.onBack),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh, // Fitur tarik layar ke bawah untuk reload data nyata
            color: SakuColors.mango500,
            child: FutureBuilder<List<NotificationItem>>(
              future: _notificationsFuture,
              builder: (context, snapshot) {
                // 1. STATE JIKA SEDANG MEMUAT DATA (LOADING)
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(SakuColors.mango500),
                    ),
                  );
                }

                // 2. STATE JIKA TERJADI LOGICAL ERROR / KONEKSI TIMEOUT
                if (snapshot.hasError) {
                  return ListView( // Harus pakai listview agar RefreshIndicator bisa bekerja saat error
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            '${snapshot.error}'.replaceAll('Exception: ', ''),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: SakuColors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // 3. STATE JIKA DATA DITERIMA NAMUN KOSONG (KOSONG DI DATABASE)
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                      const EmptyStateCard(
                        icon: Icons.notifications_none_rounded,
                        title: 'Belum Ada Notifikasi',
                        message: 'Seluruh pemberitahuan aktivitas keuanganmu\nakan muncul di sini.',
                      ),
                    ],
                  );
                }

                // 4. STATE JIKA DATA BERHASIL DIAMBIL SECARA REALTIME
                final items = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(), // Menjaga agar selalu bisa di-scroll & di-refresh
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _NotificationRow(item: items[index]);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 14, 32, 10),
      decoration: const BoxDecoration(
        color: SakuColors.white,
        border: Border(bottom: BorderSide(color: SakuColors.neutral300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            height: 40,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Icon(item.icon, color: item.iconColor, size: 28),
                if (item.icon == Icons.edit_note_rounded)
                  const Positioned(
                    right: 0,
                    bottom: 3,
                    child: Icon(
                      Icons.edit_rounded,
                      color: SakuColors.mango500,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: SakuColors.black,
                    fontSize: 17,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item.time,
                    style: const TextStyle(
                      color: SakuColors.neutral300,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}