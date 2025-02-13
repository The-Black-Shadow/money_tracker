part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Map<String, dynamic>> transactions;
  final double total; // Add this field
  final TransactionType selectedType;

  const TransactionLoaded(
    this.transactions, {
    required this.total, // Make total required
    this.selectedType = TransactionType.income,
  });

  @override
  List<Object?> get props => [transactions, total, selectedType]; // Include total in props
}

class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);
  @override
  List<Object?> get props => [message];
}