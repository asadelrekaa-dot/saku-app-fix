import 'dashboard_shared.dart';
import 'add_note_page.dart';
import 'budget_page.dart';
import 'chart_page.dart';
import 'edit_transaction_page.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'insight_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.state,
    required this.userName,
    required this.userEmail,
    this.photoUrl,
    required this.onRequestHomeWidget,
    this.onProfileUpdated,
  });

  final DashboardState state;
  final String userName;
  final String userEmail;
  final String? photoUrl;
  final VoidCallback onRequestHomeWidget;
  final void Function(String name, String email, String? photoUrl)? onProfileUpdated;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DashboardBloc>();
    return switch (state.surface) {
      DashboardSurface.budget => BudgetDashboard(
          budgets: state.budgets,
          onBack: () => bloc.add(const DashboardMainShown()),
          onDelete: (item) => bloc.add(DashboardBudgetDeleted(item)),
        ),
      DashboardSurface.insight => InsightDashboard(
          onBack: () => bloc.add(const DashboardMainShown()),
        ),
      DashboardSurface.notifications => NotificationsDashboard(
          onBack: () => bloc.add(const DashboardMainShown()),
        ),
      DashboardSurface.addExpense => AddNoteDashboard(
          mode: AddNoteMode.expense,
          onBack: () => bloc.add(const DashboardMainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardAddNoteShown(mode: mode)),
          onSave: (item) => bloc.add(DashboardTransactionAdded(item)),
        ),
      DashboardSurface.addIncome => AddNoteDashboard(
          mode: AddNoteMode.income,
          onBack: () => bloc.add(const DashboardMainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardAddNoteShown(mode: mode)),
          onSave: (item) => bloc.add(DashboardTransactionAdded(item)),
        ),
      DashboardSurface.addDebt => AddNoteDashboard(
          mode: AddNoteMode.debt,
          onBack: () => bloc.add(const DashboardMainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardAddNoteShown(mode: mode)),
          onSave: (item) => bloc.add(DashboardTransactionAdded(item)),
        ),
      DashboardSurface.addLoan => AddNoteDashboard(
          mode: AddNoteMode.loan,
          onBack: () => bloc.add(const DashboardMainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardAddNoteShown(mode: mode)),
          onSave: (item) => bloc.add(DashboardTransactionAdded(item)),
        ),
      DashboardSurface.editTransaction => EditTransactionDashboard(
          item: state.editingTransaction,
          onBack: () => bloc.add(const DashboardMainShown()),
          onSave: (oldItem, newItem) => bloc.add(
            DashboardTransactionUpdated(
              oldItem: oldItem,
              newItem: newItem,
            ),
          ),
        ),
      DashboardSurface.main => RefreshIndicator(
          displacement: 80,
          onRefresh: () {
            bloc.add(const DashboardStarted());
            return Future.delayed(const Duration(seconds: 2));
          },
          child: switch (state.currentIndex) {
             0 => HomeDashboard(
                  userName: userName,
                  photoUrl: photoUrl,
                  transactions: state.transactions,
                  budgets: state.budgets,
                  onOpenHistory: () => bloc.add(const DashboardTabSelected(1)),
                 onOpenBudget: () => bloc
                     .add(const DashboardSurfaceShown(DashboardSurface.budget)),
                 onOpenInsight: () => bloc.add(
                   const DashboardSurfaceShown(DashboardSurface.insight),
                 ),
                 onMarkSettled: (item) =>
                     bloc.add(DashboardTransactionSettled(item)),
               ),
            1 => HistoryDashboard(
                transactions: state.transactions,
                onDelete: (item) => bloc.add(DashboardTransactionDeleted(item)),
                onEdit: (item) => bloc.add(DashboardEditTransactionOpened(item)),
                onMarkSettled: (item) =>
                    bloc.add(DashboardTransactionSettled(item)),
              ),
            2 => ChartDashboard(transactions: state.transactions),
             _ => ProfileDashboard(
                initialName: userName,
                initialEmail: userEmail,
                onOpenNotifications: () => bloc.add(
                  const DashboardSurfaceShown(DashboardSurface.notifications),
                ),
                onAddHomeWidget: onRequestHomeWidget,
                onProfileUpdated: onProfileUpdated,
              ),
          },
        ),
    };
  }
}
