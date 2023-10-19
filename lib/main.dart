import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calculadora NPI'),
        ),
        body: Calculator(),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  TextEditingController inputController = TextEditingController();
  String output = '';

  // Esta función convierte la expresión matemática a notación polaca inversa (NPI).
  void _convertToRPN() {
    // Obtenemos la expresión ingresada por el usuario.
    String input = inputController.text;

    // Listas para almacenar la salida en NPI y los operadores temporales.
    List<String> _output = [];
    List<String> stack = [];

    // Precendencia de los operadores.
    Map<String, int> precedence = {
      '+': 1,
      '-': 1,
      '*': 2,
      '/': 2,
    };

    // Variable para almacenar los números digitados por el usuario.
    String numeros = '';

    // Recorremos cada carácter de la expresión ingresada.
    for (int i = 0; i < input.length; i++) {
      String char = input[i];

      // Verificamos si el carácter es un dígito o un punto decimal.
      if (RegExp(r'[0-9.]').hasMatch(char)) {
        numeros += char; // Si es un dígito, lo añadimos al número actual.
      } else {
        if (numeros.isNotEmpty) {
          _output.add(numeros); // Si ya no hay dígitos, añadimos el número a la salida.
          numeros = '';
        }

        // Manejo de paréntesis y operadores.
        if (char == '(') {
          stack.add(char); // Si encontramos un paréntesis izquierdo, lo añadimos a la pila.
        } else if (char == ')') {
          while (stack.isNotEmpty && stack.last != '(') {
            _output.add(stack.removeLast()); // Si encontramos un paréntesis derecho, desapilamos los operadores.
          }
          stack.removeLast(); // Eliminamos el paréntesis izquierdo de la pila.
        } else {
          // Manejo de operadores.
          while (stack.isNotEmpty &&
              precedence.containsKey(stack.last) &&
              precedence[char]! <= precedence[stack.last]!) {
            _output.add(stack.removeLast()); // Desapilamos operadores según la precedencia.
          }
          stack.add(char); // Añadimos el operador actual a la pila.
        }
      }
    }

    // Manejamos los dígitos que quedan al final.
    if (numeros.isNotEmpty) {
      _output.add(numeros);
    }

    // Desapilamos cualquier operador restante.
    while (stack.isNotEmpty) {
      _output.add(stack.removeLast());
    }

    // Actualizamos el estado con la salida en NPI como una cadena separada por comas.
    setState(() {
      output = _output.join(',');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Ingresa una operación matemática',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: inputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escriba aquí',
              ),
            ),
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _convertToRPN(); // Cuando se presiona el botón, llamamos a la función para convertir a NPI.
            },
            child: Text('Convertir a NPI'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Resultado en notación polaca inversa: $output', // Mostramos la salida en NPI.
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
