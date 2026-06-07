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
    required this.onRequestHomeWidget,
  });

  final DashboardState state;
  final String userName;
  final String userEmail;
  final VoidCallback onRequestHomeWidget;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DashboardBloc>();
    return switch (state.surface) {
      DashboardSurface.budget => BudgetDashboard(
          budgets: state.budgets,
          onBack: () => bloc.add(const DashboardMainShown()),
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
          onSwitchMode: (mode) => bloc.add(DashboardAddNoteShown(mode)),
          onSave: (item) => bloc.add(DashboardTransactionAdded(item)),
        ),
      DashboardSurface.addIncome => AddNoteDashboard(
          mode: AddNoteMode.income,
          onBack: () => bloc.add(const DashboardMainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardAddNoteShown(mode)),
          onSave: (item) => bloc.add(DashboardTransactionAdded(item)),
        ),
      DashboardSurface.addDebt => AddNoteDashboard(
          mode: AddNoteMode.debt,
          onBack: () => bloc.add(const DashboardMainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardAddNoteShown(mode)),
          onSave: (item) => bloc.add(DashboardTransactionAdded(item)),
        ),
      DashboardSurface.addLoan => AddNoteDashboard(
          mode: AddNoteMode.loan,
          onBack: () => bloc.add(const DashboardMainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardAddNoteShown(mode)),
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
      DashboardSurface.main => switch (state.currentIndex) {
          0 => HomeDashboard(
              userName: userName,
              transactions: state.transactions,
              onOpenHistory: () => bloc.add(const DashboardTabSelected(1)),
              onOpenBudget: () => bloc
                  .add(const DashboardSurfaceShown(DashboardSurface.budget)),
              onOpenInsight: () => bloc.add(
                const DashboardSurfaceShown(DashboardSurface.insight),
              ),
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
            ),
        },
    };
  }
}
