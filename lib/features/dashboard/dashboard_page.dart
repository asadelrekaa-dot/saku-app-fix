import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/api/laravel_api_service.dart';
import 'widgets/budget_page.dart';
import 'widgets/dashboard_content.dart';
import 'widgets/dashboard_shared.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    this.userName,
    this.userEmail,
    this.openAddNote = false,
  });

  static const routeName = '/home';
  final String? userName;
  final String? userEmail;
  final bool openAddNote;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _userName = '';
  String _userEmail = '';
  bool _loadingUser = true;
  static const _homeWidgetProvider = 'SakuSummaryWidgetProvider';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (widget.userName != null && widget.userEmail != null) {
      _userName = widget.userName!;
      _userEmail = widget.userEmail!;
      if (mounted) setState(() => _loadingUser = false);
      return;
    }
    final saved = await LaravelApiService.instance.getSavedUser();
    if (mounted) {
      setState(() {
        _userName = saved?.name ?? 'Pengguna';
        _userEmail = saved?.email ?? '';
        _loadingUser = false;
      });
    }
  }

  Future<void> _requestHomeWidget() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      showInfoDialog(
        context,
        title: 'Widget Homescreen',
        message:
            'Widget ringkasan siap untuk Android. Tambahkan dari homescreen perangkat Android setelah aplikasi diinstal.',
      );
      return;
    }

    try {
      await HomeWidget.updateWidget(name: _homeWidgetProvider);
      final supported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
      if (supported) {
        await HomeWidget.requestPinWidget(name: _homeWidgetProvider);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Permintaan widget dikirim ke homescreen')),
        );
      } else {
        if (!mounted) return;
        showInfoDialog(
          context,
          title: 'Tambahkan Widget',
          message:
              'Tekan lama area kosong di homescreen, pilih Widget, lalu pilih Saku Ringkasan.',
        );
      }
    } catch (_) {
      if (!mounted) return;
      showInfoDialog(
        context,
        title: 'Tambahkan Widget',
        message:
            'Tekan lama area kosong di homescreen, pilih Widget, lalu pilih Saku Ringkasan.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return BlocProvider(
      create: (_) => DashboardBloc(openAddNote: widget.openAddNote)
        ..add(const DashboardStarted()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final bloc = context.read<DashboardBloc>();
          return Scaffold(
            backgroundColor: SakuColors.neutral50,
            body: SafeArea(
              child: Column(
                children: [
Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final pageWidth = constraints.maxWidth > 430
                            ? 430.0
                            : constraints.maxWidth;

                        return Center(
                          child: SizedBox(
                            width: pageWidth,
                            height: constraints.maxHeight,
                            child: DashboardContent(
                              state: state,
                              userName: _userName,
                              userEmail: _userEmail,
                              onRequestHomeWidget: _requestHomeWidget,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: state.hidesFloatingActionButton
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      if (state.surface == DashboardSurface.budget) {
                        showDialog<void>(
                          context: context,
                          builder: (context) => BudgetFormDialog(
                            onSave: (item) {
                              bloc.add(DashboardBudgetAdded(item));
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                        return;
                      }
                      bloc.add(const DashboardAddNoteShown());
                    },
                    backgroundColor: SakuColors.mango500,
                    foregroundColor: SakuColors.white,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add_rounded, size: 34),
                  ),
            floatingActionButtonLocation: state.showBottomNavigation
                ? FloatingActionButtonLocation.centerDocked
                : FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: state.showBottomNavigation
                ? Container(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: Center(
                      heightFactor: 1,
                      child: SizedBox(
                        width: 430,
                        child: NavigationBar(
                          selectedIndex: state.currentIndex,
                          onDestinationSelected: (index) {
                            bloc.add(DashboardTabSelected(index));
                          },
                          indicatorColor: SakuColors.blue100,
                          destinations: const [
                            NavigationDestination(
                              icon: Icon(Icons.home_outlined),
                              selectedIcon: Icon(Icons.home_rounded),
                              label: 'Beranda',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.receipt_long_outlined),
                              selectedIcon: Icon(Icons.receipt_long_rounded),
                              label: 'Riwayat',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.pie_chart_outline_rounded),
                              selectedIcon: Icon(Icons.pie_chart_rounded),
                              label: 'Grafik',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.person_outline_rounded),
                              selectedIcon: Icon(Icons.person_rounded),
                              label: 'Profil',
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
