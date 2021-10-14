import 'dart:math';
import 'dart:io';
import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';

import 'package:flutter/services.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
        id: 't1',
        title: 'Conta #01',
        value: 310.50,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: 't2',
        title: 'Conta #02',
        value: 250.90,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: 't3',
        title: 'Conta #03',
        value: 9,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(id: 't4', title: 'Conta #04', value: 42, date: DateTime.now()),
    Transaction(id: 't5', title: 'Conta #05', value: 4.5, date: DateTime.now()),
    Transaction(
        id: 't6',
        title: 'Conta #06',
        value: 18,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(id: 't7', title: 'Conta #07', value: 12, date: DateTime.now()),
    Transaction(id: 't8', title: 'Conta #08', value: 32, date: DateTime.now()),
    Transaction(
        id: 't9',
        title: 'Conta #09',
        value: 800,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: 't10', title: 'Conta #10', value: 150, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransaction {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop(); // remove modal (pagina em pilha)
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((elm) => elm.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
      ),
      actions: [
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: Icon(Icons.add),
          color: Colors.white,
        )
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final bodyPage = SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
          Container(
            child: Chart(_recentTransaction),
            height: availableHeight * .3,
          ),
          Container(
            child: TransactionList(_transactions, _removeTransaction),
            height: availableHeight * .7,
          ),
        ]));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
