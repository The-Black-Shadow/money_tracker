import 'package:money_tracker/import.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => TransactionBloc()..add(LoadTransactions()),
        child: const HomeScreen(),
      ),
    );
  }
}


