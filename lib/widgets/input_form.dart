import 'package:money_tracker/import.dart';

class TransactionInputForm extends StatefulWidget {
  final TransactionType type;
  const TransactionInputForm({super.key, required this.type});

  @override
  State<TransactionInputForm> createState() => _TransactionInputFormState();
}

class _TransactionInputFormState extends State<TransactionInputForm> {
  final _sourceController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add a form key for validation

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey, // Assign the form key
        child: Column(
          children: [
            // Source Input Field
            TextFormField(
              controller: _sourceController,
              decoration: InputDecoration(
                labelText: widget.type == TransactionType.income
                    ? 'Income Source (e.g., Salary)'
                    : 'Expense Category (e.g., Grocery)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a source or category';
                }
                return null;
              },
            ),

            // Amount Input Field
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Validate the form
                if (_formKey.currentState!.validate()) {
                  final source = _sourceController.text;
                  final amount = double.parse(_amountController.text);

                  // Submit the transaction
                  context.read<TransactionBloc>().add(
                        SubmitTransaction(source, amount, widget.type),
                      );

                  // Clear the input fields
                  _sourceController.clear();
                  _amountController.clear();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
