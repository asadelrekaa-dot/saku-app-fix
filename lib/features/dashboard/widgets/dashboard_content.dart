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
          onBack: () => bloc.add(const DashboardEvent.mainShown()),
        ),
      DashboardSurface.insight => InsightDashboard(
          onBack: () => bloc.add(const DashboardEvent.mainShown()),
        ),
      DashboardSurface.notifications => NotificationsDashboard(
          onBack: () => bloc.add(const DashboardEvent.mainShown()),
        ),
      DashboardSurface.addExpense => AddNoteDashboard(
          mode: AddNoteMode.expense,
          onBack: () => bloc.add(const DashboardEvent.mainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardEvent.addNoteShown(mode)),
          onSave: (item) => bloc.add(DashboardEvent.transactionAdded(item)),
        ),
      DashboardSurface.addIncome => AddNoteDashboard(
          mode: AddNoteMode.income,
          onBack: () => bloc.add(const DashboardEvent.mainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardEvent.addNoteShown(mode)),
          onSave: (item) => bloc.add(DashboardEvent.transactionAdded(item)),
        ),
      DashboardSurface.addDebt => AddNoteDashboard(
          mode: AddNoteMode.debt,
          onBack: () => bloc.add(const DashboardEvent.mainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardEvent.addNoteShown(mode)),
          onSave: (item) => bloc.add(DashboardEvent.transactionAdded(item)),
        ),
      DashboardSurface.addLoan => AddNoteDashboard(
          mode: AddNoteMode.loan,
          onBack: () => bloc.add(const DashboardEvent.mainShown()),
          onSwitchMode: (mode) => bloc.add(DashboardEvent.addNoteShown(mode)),
          onSave: (item) => bloc.add(DashboardEvent.transactionAdded(item)),
        ),
      DashboardSurface.editTransaction => EditTransactionDashboard(
          item: state.editingTransaction,
          onBack: () => bloc.add(const DashboardEvent.mainShown()),
          onSave: (oldItem, newItem) => bloc.add(
            DashboardEvent.transactionUpdated(
              oldItem: oldItem,
              newItem: newItem,
            ),
          ),
        ),
      DashboardSurface.main => switch (state.currentIndex) {
          0 => HomeDashboard(
              userName: userName,
              transactions: state.transactions,
              onOpenHistory: () => bloc.add(const DashboardEvent.tabSelected(1)),
              onOpenBudget: () => bloc
                  .add(const DashboardEvent.surfaceShown(DashboardSurface.budget)),
              onOpenInsight: () => bloc.add(
                const DashboardEvent.surfaceShown(DashboardSurface.insight),
              ),
            ),
          1 => HistoryDashboard(
              transactions: state.transactions,
              onDelete: (item) => bloc.add(DashboardEvent.transactionDeleted(item)),
              onEdit: (item) => bloc.add(DashboardEvent.editTransactionOpened(item)),
              onMarkSettled: (item) =>
                  bloc.add(DashboardEvent.transactionSettled(item)),
            ),
          2 => ChartDashboard(transactions: state.transactions),
          _ => ProfileDashboard(
              initialName: userName,
              initialEmail: userEmail,
              onOpenNotifications: () => bloc.add(
                const DashboardEvent.surfaceShown(DashboardSurface.notifications),
              ),
              onAddHomeWidget: onRequestHomeWidget,
            ),
        },
    };
  }
}
