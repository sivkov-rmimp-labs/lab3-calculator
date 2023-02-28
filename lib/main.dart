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
        colorScheme: ColorScheme.dark(
          background: Colors.black,
          primary: Colors.grey.shade800,
          secondary: Colors.orange,
          tertiary: Colors.grey,
        ),
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
  String firstText = "0";
  String secondText = "";
  String selectedOperation = '';

  final RegExp validInputTextRegex =
      RegExp(r"^(|(-)|(-?\d+\.?\d*)|(-?\d+\.?\d*)([+\-*/])|(-?\d+\.?\d*)([+\-*/])(-?\d+\.?\d*))$");
  final RegExp wellFormedInputTextRegex = RegExp(r"^((-?\d+\.?\d*)([+\-*/])(-?\d+\.?\d*))$");

  final NumberFormat resultNumberFormat = NumberFormat()
    ..minimumFractionDigits = 0
    ..turnOffGrouping();

  @override
  Widget build(BuildContext context) {
    print('selectedOperation = "$selectedOperation", firstText = "$firstText", secondText = "$secondText"');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    child: Text(
                      selectedOperation != '' && secondText != '' ? secondText : firstText,
                      style: const TextStyle(fontSize: 64),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 4 / 5,
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CalculatorButton(
                              flex: 2,
                              text: 'AC',
                              type: CalculatorButtonType.other,
                              action: clearAll,
                            ),
                            CalculatorButton(
                              text: '±',
                              type: CalculatorButtonType.other,
                              action: changeSign,
                            ),
                            CalculatorButton(
                              text: '/',
                              type: CalculatorButtonType.operation,
                              operationSelected: selectedOperation == '/',
                              action: () {
                                setState(() {
                                  if (firstText != 'Ошибка') {
                                    selectedOperation = '/';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
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
                              text: '*',
                              type: CalculatorButtonType.operation,
                              operationSelected: selectedOperation == '*',
                              action: () {
                                setState(() {
                                  if (firstText != 'Ошибка') {
                                    selectedOperation = '*';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
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
                              text: '-',
                              type: CalculatorButtonType.operation,
                              operationSelected: selectedOperation == '-',
                              action: () {
                                setState(() {
                                  if (firstText != 'Ошибка') {
                                    selectedOperation = '-';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
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
                              text: '+',
                              type: CalculatorButtonType.operation,
                              operationSelected: selectedOperation == '+',
                              action: () {
                                setState(() {
                                  if (firstText != 'Ошибка') {
                                    selectedOperation = '+';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            CalculatorButton(
                              text: '0',
                              flex: 2,
                              action: () {
                                appendText('0');
                              },
                            ),
                            CalculatorButton(
                              text: ',',
                              action: () {
                                appendText('.');
                              },
                            ),
                            CalculatorButton(
                              text: '=',
                              type: CalculatorButtonType.operation,
                              action: calculate,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void appendText(String text, {bool replaceOnlyZero = true}) {
    setState(() {
      if (selectedOperation == '') {
        if (firstText == '0' && replaceOnlyZero) {
          firstText = '';
        }

        firstText += text;
      } else {
        if (secondText == '0' && replaceOnlyZero) {
          secondText = '';
        }

        secondText += text;
      }
    });
  }

  void removeLastSymbol() {
    setState(() {
      if (firstText.isNotEmpty) {
        firstText = firstText.substring(0, firstText.length - 1);
      }

      if (firstText.isEmpty || firstText == '-') {
        firstText = '0';
      }
    });
  }

  void clearAll() {
    setState(() {
      firstText = '0';
      secondText = '';
      selectedOperation = '';
    });
  }

  void changeSign() {
    if (firstText == 'Ошибка') return;

    setState(() {
      if (firstText[0] == '-') {
        firstText = firstText.substring(1);
      } else {
        firstText = '-$firstText';
      }
    });
  }

  void calculate() {
    final a = double.parse(firstText);
    final operation = selectedOperation;
    final b = double.parse(secondText);

    double result = 0;
    if (operation == '+') {
      result = a + b;
    } else if (operation == '-') {
      result = a - b;
    } else if (operation == '*') {
      result = a * b;
    } else if (operation == '/') {
      if (b == 0) {
        setState(() {
          clearAll();
          firstText = 'Ошибка';
        });
        return;
      }
      result = a / b;
    }

    setState(() {
      clearAll();
      firstText = resultNumberFormat.format(result);
    });
  }
}

enum CalculatorButtonType { number, operation, other }

class CalculatorButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final void Function() action;
  final void Function()? longTapAction;
  final bool isDisabled;
  final int flex;
  final CalculatorButtonType type;
  final bool operationSelected;

  const CalculatorButton({
    Key? key,
    this.text,
    this.icon,
    required this.action,
    this.longTapAction,
    this.isDisabled = false,
    this.flex = 1,
    this.type = CalculatorButtonType.number,
    this.operationSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.primary;
    Color textColor = Colors.white;
    if (operationSelected) {
      color = Colors.white;
      textColor = Theme.of(context).colorScheme.secondary;
    } else if (type == CalculatorButtonType.operation) {
      color = Theme.of(context).colorScheme.secondary;
    } else if (type == CalculatorButtonType.other) {
      color = Theme.of(context).colorScheme.tertiary;
    }

    final child = Center(
      child: text != null
          ? Text(
              text!,
              style: TextStyle(
                color: textColor,
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

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10000))),
          color: color,
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
      ),
    );
  }
}
