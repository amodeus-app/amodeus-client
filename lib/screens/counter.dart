import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'This screen is not yet implemented, so you can just click on the text below instead:',
          ),
          TextButton(
            onPressed: () => setState(() => _counter++),
            onLongPress: () {
              controller.text = _counter.toString();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Change value"),
                  content: SingleChildScrollView(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) {
                        setState(() {
                          _counter = int.tryParse(controller.value.text) ?? _counter;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  actions: <TextButton>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _counter = int.tryParse(controller.value.text) ?? _counter;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Set"),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
