import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _dailyChannelId = 'saku_daily_reminder';
  static const _warningChannelId = 'saku_warnings';
  static const _dailyNotificationId = 1001;
  static const _afternoonNotificationId = 1002;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    await _createChannels();
    _initialized = true;
  }

  Future<void> _createChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _dailyChannelId,
        'Pengingat Harian',
        description: 'Pengingat untuk mencatat pengeluaran setiap pagi',
        importance: Importance.defaultImportance,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _warningChannelId,
        'Peringatan Keuangan',
        description: 'Peringatan terkait anggaran dan pengeluaran',
        importance: Importance.high,
      ),
    );
  }

  Future<void> scheduleDailyReminder() async {
    await _plugin.cancel(_dailyNotificationId);

    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 6, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      _dailyChannelId,
      'Pengingat Harian',
      channelDescription: 'Pengingat untuk mencatat pengeluaran setiap pagi',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      _dailyNotificationId,
      'Pagi yang cerah!',
      'Jangan lupa catat pemasukkan & pengeluaran hari ini ya!',
      tzScheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleAfternoonReminder() async {
    await _plugin.cancel(_afternoonNotificationId);

    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 15, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      _dailyChannelId,
      'Pengingat Harian',
      channelDescription: 'Pengingat untuk mencatat pengeluaran setiap pagi',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      _afternoonNotificationId,
      'Jangan lupa catat keuangan!',
      'Catat pemasukan & pengeluaran hari ini di Saku yuk!',
      tzScheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showBudgetLowNotification(
    String category,
    int remaining,
    double percentage,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      _warningChannelId,
      'Peringatan Keuangan',
      channelDescription: 'Peringatan terkait anggaran dan pengeluaran',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecond,
      'Anggaran $category Hampir Habis',
      'Sisa ${_formatRupiah(remaining)} (${percentage.toStringAsFixed(0)}%) — Yuk atur pengeluaran!',
      details,
    );
  }

  Future<void> showHighSpendingNotification(
    int totalExpense,
    int walletBalance,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      _warningChannelId,
      'Peringatan Keuangan',
      channelDescription: 'Peringatan terkait anggaran dan pengeluaran',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecond + 1,
      'Pengeluaran Tinggi!',
      'Pengeluaranmu ${_formatRupiah(totalExpense)} sudah lebih dari 50% saldo dompet (${_formatRupiah(walletBalance)})',
      details,
    );
  }

  static String _formatRupiah(int amount) {
    final text = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final position = text.length - i;
      buffer.write(text[i]);
      if (position > 1 && position % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp $buffer';
  }
}
