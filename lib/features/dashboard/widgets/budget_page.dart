import 'dashboard_shared.dart';

class BudgetDashboard extends StatelessWidget {
  const BudgetDashboard({
    super.key,
    required this.budgets,
    required this.onBack,
    required this.onDelete,
  });

  final List<DashboardBudget> budgets;
  final VoidCallback onBack;
  final ValueChanged<DashboardBudget> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChildPageTopBar(title: 'Budget', onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 120),
            children: [
              const Text(
                'Budget',
                style: TextStyle(
                  color: SakuColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Katagori budget',
                style: TextStyle(
                  color: SakuColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              ...budgets.map((b) => _BudgetRow(b, onDelete: onDelete)),
            ],
          ),
        ),
      ],
    );
  }
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow(this.item, {required this.onDelete});

  final DashboardBudget item;
  final ValueChanged<DashboardBudget> onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SakuColors.neutral100)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: SakuColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: SakuColors.neutral300, width: 1.4),
            ),
            child: Icon(item.icon, color: SakuColors.blue700, size: 26),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: SakuColors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Rp ${formatPlain(item.amountValue)}',
                      style: const TextStyle(
                        color: SakuColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onDelete(item),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: SakuColors.danger,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: item.progress,
                          minHeight: 14,
                          color: SakuColors.mango500,
                          backgroundColor: SakuColors.neutral100,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.remaining,
                      style: const TextStyle(
                        color: SakuColors.neutral300,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


