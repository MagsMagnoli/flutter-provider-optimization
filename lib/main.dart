import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  int items = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('$counter', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Wrap(
                children: Iterable.generate(items)
                    .map((e) => ExpensiveItem(
                          position: e + 1,
                          counter: counter,
                        ))
                    .toList(),
              )
            ],
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

class ExpensiveItem extends StatelessWidget {
  final int position;
  final int counter;

  const ExpensiveItem({Key key, this.position, this.counter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.of(context).size.width / 5) - 32 / 5;
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 5)),
      builder: (_, snapshot) {
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: snapshot.connectionState == ConnectionState.done
                ? position % counter == 0
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
