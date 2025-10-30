import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

/// Classe que representa uma pessoa
class Pessoa {
  double peso;
  double altura;
  String genero;

  Pessoa({required this.peso, required this.altura, required this.genero});

  double calcularIMC() {
    return peso / (altura * altura);
  }

  String classificarIMC() {
    double imc = calcularIMC();
    if (genero == 'Masculino') {
      if (imc < 20.7)
        return "Abaixo do peso";
      else if (imc < 26.4)
        return "Peso ideal";
      else if (imc < 27.8)
        return "Levemente acima do peso";
      else if (imc < 31.1)
        return "Obesidade Grau I";
      else if (imc < 40.0)
        return "Obesidade Grau II";
      else
        return "Obesidade Grau III";
    } else {
      if (imc < 19.1)
        return "Abaixo do peso";
      else if (imc < 25.8)
        return "Peso ideal";
      else if (imc < 27.3)
        return "Levemente acima do peso";
      else if (imc < 32.3)
        return "Obesidade Grau I";
      else if (imc < 40.0)
        return "Obesidade Grau II";
      else
        return "Obesidade Grau III";
    }
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _resultado = "Informe seus dados";
  String _generoSelecionado = "Masculino";
  Color _corResultado = Colors.white;

  void resetFields() {
    _weightController.clear();
    _heightController.clear();
    setState(() {
      _resultado = "Informe seus dados";
      _corResultado = Colors.white;
      _generoSelecionado = "Masculino";
    });
  }

  void calcularIMC() {
    double peso = double.parse(_weightController.text);
    double altura = double.parse(_heightController.text) / 100.0;
    Pessoa pessoa = Pessoa(
      peso: peso,
      altura: altura,
      genero: _generoSelecionado,
    );

    double imc = pessoa.calcularIMC();
    String classificacao = pessoa.classificarIMC();

    setState(() {
      _resultado = "IMC = ${imc.toStringAsFixed(2)}\n$classificacao";

      if (classificacao.contains("Abaixo"))
        _corResultado = Colors.lightBlueAccent;
      else if (classificacao.contains("Peso ideal"))
        _corResultado = Colors.greenAccent.shade400;
      else if (classificacao.contains("Levemente"))
        _corResultado = Colors.orangeAccent;
      else if (classificacao.contains("Obesidade Grau I"))
        _corResultado = Colors.deepOrangeAccent;
      else if (classificacao.contains("Obesidade Grau II"))
        _corResultado = Colors.redAccent;
      else
        _corResultado = Colors.purpleAccent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removemos a cor sólida e aplicamos gradiente
      appBar: AppBar(
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetFields,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: buildForm(),
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildGeneroSelector(),
          const SizedBox(height: 20),
          buildTextFormField(
            label: "Peso (kg)",
            error: "Insira seu peso!",
            controller: _weightController,
          ),
          const SizedBox(height: 10),
          buildTextFormField(
            label: "Altura (cm)",
            error: "Insira sua altura!",
            controller: _heightController,
          ),
          buildTextResult(),
          buildCalculateButton(),
        ],
      ),
    );
  }

  Widget buildGeneroSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gênero:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                activeColor: Colors.cyanAccent,
                title: const Text("Masculino",
                    style: TextStyle(color: Colors.white)),
                value: "Masculino",
                groupValue: _generoSelecionado,
                onChanged: (value) {
                  setState(() => _generoSelecionado = value!);
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                activeColor: Colors.pinkAccent,
                title: const Text("Feminino",
                    style: TextStyle(color: Colors.white)),
                value: "Feminino",
                groupValue: _generoSelecionado,
                onChanged: (value) {
                  setState(() => _generoSelecionado = value!);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding buildCalculateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          backgroundColor: const Color(0xFF42A5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          shadowColor: Colors.black45,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            calcularIMC();
          }
        },
        child: const Text(
          'CALCULAR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Padding buildTextResult() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _resultado,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _corResultado,
          height: 1.5,
        ),
      ),
    );
  }

  TextFormField buildTextFormField({
    required TextEditingController controller,
    required String error,
    required String label,
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      controller: controller,
      validator: (text) => text!.isEmpty ? error : null,
    );
  }
}
