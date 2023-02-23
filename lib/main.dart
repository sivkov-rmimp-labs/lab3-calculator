import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лаб 3 Сивков',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '[РМиМП-1] Лаб 3. Сивков'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String inputText = "0";

  final RegExp validInputTextRegex = RegExp(r"^(|(-)|(-?\d+\.?\d*)|(-?\d+\.?\d*)([+\-*/])|(-?\d+\.?\d*)([+\-*/])(-?\d+\.?\d*))$");
  final RegExp wellFormedInputTextRegex = RegExp(r"^((-?\d+\.?\d*)([+\-*/])(-?\d+\.?\d*))$");

  final NumberFormat resultNumberFormat = NumberFormat()
    ..minimumFractionDigits = 0
    ..turnOffGrouping();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FittedBox(
                  child: Text(
                    inputText,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  CalculatorButton(
                    text: '7',
                    action: () {
                      appendText('7');
                    },
                  ),
                  CalculatorButton(
                    text: '8',
                    action: () {
                      appendText('8');
                    },
                  ),
                  CalculatorButton(
                    text: '9',
                    action: () {
                      appendText('9');
                    },
                  ),
                  CalculatorButton(
                    text: '4',
                    action: () {
                      appendText('4');
                    },
                  ),
                  CalculatorButton(
                    text: '5',
                    action: () {
                      appendText('5');
                    },
                  ),
                  CalculatorButton(
                    text: '6',
                    action: () {
                      appendText('6');
                    },
                  ),
                  CalculatorButton(
                    text: '1',
                    action: () {
                      appendText('1');
                    },
                  ),
                  CalculatorButton(
                    text: '2',
                    action: () {
                      appendText('2');
                    },
                  ),
                  CalculatorButton(
                    text: '3',
                    action: () {
                      appendText('3');
                    },
                  ),
                  CalculatorButton(
                    text: '.',
                    action: () {
                      appendText('.');
                    },
                  ),
                  CalculatorButton(
                    text: '0',
                    action: () {
                      appendText('0');
                    },
                  ),
                  CalculatorButton(
                    icon: Icons.backspace,
                    action: removeLastSymbol,
                    longTapAction: clearAll,
                  ),
                ],
              ),
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(),
                  CalculatorButton(
                    text: '+',
                    action: () {
                      appendText('+', replaceOnlyZero: false);
                    },
                  ),
                  Container(),
                  CalculatorButton(
                    text: '*',
                    action: () {
                      appendText('*', replaceOnlyZero: false);
                    },
                  ),
                  CalculatorButton(
                    text: '±',
                    action: changeSign,
                  ),
                  CalculatorButton(
                    text: '/',
                    action: () {
                      appendText('/', replaceOnlyZero: false);
                    },
                  ),
                  Container(),
                  CalculatorButton(
                    text: '-',
                    action: () {
                      appendText('-');
                    },
                  ),
                  Container(),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: wellFormedInputTextRegex.hasMatch(inputText)
          ? FloatingActionButton(
              onPressed: calculate,
              child: const Text(
                '=',
                style: TextStyle(fontSize: 22),
              ),
            )
          : null,
    );
  }

  void appendText(String text, {bool replaceOnlyZero = true}) {
    setState(() {
      if (validInputTextRegex.hasMatch(inputText + text)) {
        if (inputText == '0' && replaceOnlyZero) {
          inputText = '';
        }

        inputText += text;
      }
    });
  }

  void removeLastSymbol() {
    setState(() {
      if (inputText.isNotEmpty) {
        inputText = inputText.substring(0, inputText.length - 1);
      }

      if (inputText.isEmpty || inputText == '-') {
        inputText = '0';
      }
    });
  }

  void clearAll() {
    setState(() {
      inputText = '0';
    });
  }

  void changeSign() {
    setState(() {
      if (inputText[0] == '-') {
        inputText = inputText.substring(1);
      } else {
        inputText = '-$inputText';
      }
    });
  }

  void calculate() {
    final match = wellFormedInputTextRegex.firstMatch(inputText)!;
    final a = double.parse(match.group(2)!);
    final operation = match.group(3)!;
    final b = double.parse(match.group(4)!);

    double result = 0;
    if (operation == '+') {
      result = a + b;
    } else if (operation == '-') {
      result = a - b;
    } else if (operation == '*') {
      result = a * b;
    } else if (operation == '/') {
      if (b == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Делить на ноль нельзя!'),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }
      result = a / b;
    }

    setState(() {
      inputText = resultNumberFormat.format(result);
    });
  }
}

class CalculatorButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final void Function() action;
  final void Function()? longTapAction;
  final bool isDisabled;

  const CalculatorButton({
    Key? key,
    this.text,
    this.icon,
    required this.action,
    this.longTapAction,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = Center(
      child: text != null
          ? Text(
              text!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
              ),
            )
          : icon != null
              ? Icon(
                  icon,
                  color: Colors.white,
                )
              : null,
    );

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        color: isDisabled ? Colors.grey : Colors.blue,
        child: isDisabled
            ? Container(
                child: child,
              )
            : InkWell(
                onTap: action,
                onLongPress: longTapAction,
                child: child,
              ),
      ),
    );
  }
}
