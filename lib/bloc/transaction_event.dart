part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class ToggleTransactionType extends TransactionEvent {
  final TransactionType type;
  const ToggleTransactionType(this.type);
  @override
  List<Object?> get props => [type];
}

class SubmitTransaction extends TransactionEvent {
  final String source;
  final double amount;
  final TransactionType type;
  const SubmitTransaction(this.source, this.amount, this.type);
  @override
  List<Object?> get props => [source, amount, type];
}