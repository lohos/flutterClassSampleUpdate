import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class TaskMain extends StatefulWidget {
  const TaskMain({super.key});
  @override
  State<TaskMain> createState() => _TaskMainState();
}

class _TaskMainState extends State<TaskMain> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => Phone()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        debugShowCheckedModeBanner: false,
        home: SafeArea(child: MyHomePage()),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Count(),
            CountPhone(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('increment_floatingActionButton'),
        onPressed: () {
          context.read<Counter>().increment();
          context.read<Phone>().increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Count extends StatelessWidget {
  const Count({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      /// Calls `context.watch` to make [Count] rebuild when [Counter] changes.
      '${context.watch<Counter>().count}',
      key: const Key('counterState'),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class CountPhone extends StatelessWidget {
  const CountPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      /// Calls `context.watch` to make [Count] rebuild when [Counter] changes.
      '${context.watch<Phone>().countPhone}',
      key: const Key('phoneState'),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
