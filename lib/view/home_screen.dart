import 'package:intl/intl.dart';
import 'package:money_tracker/import.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Tracker'),
        actions: [
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoaded) {
                // Use the total from the state
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'Total: \$${state.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle Buttons
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              TransactionType selectedType = TransactionType.income;
              if (state is TransactionLoaded) {
                selectedType = state.selectedType;
              }
              return Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: selectedType == TransactionType.income
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: () => context
                          .read<TransactionBloc>()
                          .add(ToggleTransactionType(TransactionType.income)),
                      child: const Text('Income',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: selectedType == TransactionType.expense
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: () => context
                          .read<TransactionBloc>()
                          .add(ToggleTransactionType(TransactionType.expense)),
                      child: const Text('Expense',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              );
            },
          ),

          // Input Fields
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoaded) {
                return TransactionInputForm(type: state.selectedType);
              }
              return const SizedBox.shrink();
            },
          ),

          // History List
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoaded) {
                  return ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = state.transactions[index];
                      return ListTile(
                        title: Text(transaction['title']),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd').format(
                            DateTime.parse(transaction['date']),
                          ),
                        ),
                        trailing: Text(
                          '\$${transaction['amount'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: transaction['type'] == 'income'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}