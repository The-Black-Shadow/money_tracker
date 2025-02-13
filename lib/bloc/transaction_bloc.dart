import 'package:money_tracker/import.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<ToggleTransactionType>(_onToggleTransactionType);
    on<SubmitTransaction>(_onSubmitTransaction);
  }

  // Add this helper method to calculate total
  double _calculateTotal(List<Map<String, dynamic>> transactions) {
    double income = 0;
    double expenses = 0;
    for (var transaction in transactions) {
      if (transaction['type'] == 'income') {
        income += transaction['amount'];
      } else {
        expenses += transaction['amount'];
      }
    }
    return income - expenses;
  }

  Future<void> _onLoadTransactions(
      LoadTransactions event, Emitter<TransactionState> emit) async {
    try {
      final transactions = await _databaseHelper.getTransactions();
      final total = _calculateTotal(transactions);
      emit(TransactionLoaded(transactions, total: total));
    } catch (e) {
      emit(TransactionError('Failed to load transactions'));
    }
  }

  Future<void> _onToggleTransactionType(
      ToggleTransactionType event, Emitter<TransactionState> emit) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      // Include total and selectedType
      emit(TransactionLoaded(
        currentState.transactions,
        total: currentState.total,
        selectedType: event.type,
      ));
    }
  }

  Future<void> _onSubmitTransaction(
      SubmitTransaction event, Emitter<TransactionState> emit) async {
    try {
      await _databaseHelper.insertTransaction({
        'title': event.source,
        'amount': event.amount,
        'type': event.type == TransactionType.income ? 'income' : 'expense',
        'date': DateTime.now().toString(),
      });
      final transactions = await _databaseHelper.getTransactions();
      final total = _calculateTotal(transactions); // Calculate total
      // Include total and selectedType
      emit(TransactionLoaded(
        transactions,
        total: total,
        selectedType: state is TransactionLoaded 
            ? (state as TransactionLoaded).selectedType 
            : TransactionType.income,
      ));
    } catch (e) {
      emit(TransactionError('Failed to submit transaction'));
    }
  }
}