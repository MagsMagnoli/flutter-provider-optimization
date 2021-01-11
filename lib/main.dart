import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Provider Optimization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('$counter', style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                Provider<int>.value(
                    value: counter,
                    builder: (_, __) => const ExpensiveItemList())
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            counter += 1;
          });
        },
      ),
    );
  }
}

class ExpensiveItemList extends StatelessWidget {
  final items = 10;

  const ExpensiveItemList();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: Iterable.generate(items)
          .map((e) => ExpensiveItem(
                position: e + 1,
              ))
          .toList(),
    );
  }
}

class ExpensiveItem extends StatelessWidget {
  final int position;

  const ExpensiveItem({Key key, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.of(context).size.width / 5) - 32 / 5;
    final isFactor = context
        .select<int, bool>((value) => value > 0 && position % value == 0);
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1)),
      builder: (_, snapshot) {
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: snapshot.connectionState == ConnectionState.done
                ? isFactor
                    ? Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                        .withOpacity(1.0)
                    : null
                : null,
          ),
          child: Center(
            child: snapshot.connectionState == ConnectionState.done
                ? Text('$position')
                : CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
