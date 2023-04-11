import 'package:flutter/material.dart';

import '/providers/open_ai_provider.dart';
import '/providers/parameters_provider.dart';

class EditTextFieldScreen extends StatefulWidget {
  final String? idiomaEntrada;
  final String? perfilEntrada;

  EditTextFieldScreen({this.idiomaEntrada, this.perfilEntrada});

  @override
  _EditTextFieldScreenState createState() => _EditTextFieldScreenState();
}

class _EditTextFieldScreenState extends State<EditTextFieldScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text =
        ParametersProvider.getPI(widget.idiomaEntrada!, widget.perfilEntrada!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar PI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _textEditingController,
          maxLines: null, // Permite que el campo de texto tenga múltiples líneas
          decoration: InputDecoration(
            hintText: 'PI',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ParametersProvider.setPI(
              widget.idiomaEntrada!, widget.perfilEntrada!, _textEditingController.text);
          ParametersProvider.saveParameters();
          Navigator.pop(context);
        },
        child: Icon(Icons.assignment_return),
      ),
    );
  }
}
