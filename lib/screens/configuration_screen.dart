import 'dart:async';

import 'package:flutter/material.dart';

import '/models/config_model.dart';
import '/models/parameter_model.dart';
import '/providers/config_provider.dart';
import '/providers/open_ai_provider.dart';
import '/providers/parameters_provider.dart';
import '/screens/edit_text_filed_screen.dart';
import '/u2/u2_string_utils.dart';

class ConfiguracionScreen extends StatefulWidget {
  @override
  _ConfiguracionScreenState createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apiKeyController = TextEditingController();
  String? _selectedPrefix;
  String? _selectedModel;
  String? _selectedLanguage;
  String? _selectedPerfil;
  TextEditingController _numTokensController = TextEditingController();
  TextEditingController _numTemperatureController = TextEditingController();
  bool _isloaded = false;

  @override
  void initState() {
    super.initState();
    if (currentParameterModel == null) Future.sync(() => {_getParameters()});
    if (currentConfigModel == null) Future.sync(() => {_getConfig()});
  }

  Future<void> _getConfig() async {
    try {
      currentConfigModel = await ConfigProvider.readConfig();
      currentOpenAIApiClient.setFromConfigModel(currentConfigModel!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getParameters() async {
    currentParameterModel = await ParametersProvider.readParameter();
  }

  Future<void> _LoadConfigState() async {
    this._isloaded = true;
    setState(() {
      _nombreController.text = U2StringUtils.cString(currentConfigModel!.nombre);
      _apiKeyController.text = U2StringUtils.cString(currentConfigModel!.apiKey);
      _selectedPrefix = U2StringUtils.cString(currentConfigModel!.prefijo);
      _selectedModel = U2StringUtils.cString(currentConfigModel!.modelo);
      _selectedLanguage = U2StringUtils.cString(currentConfigModel!.idioma);
      _selectedPerfil = U2StringUtils.cString(currentConfigModel!.perfil);
      _numTokensController.text =
          U2StringUtils.cStringDef(currentConfigModel!.numTokens.toString(), '1000');
      _numTemperatureController.text =
          U2StringUtils.cStringDef(currentConfigModel!.temperature.toString(), '0');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentParameterModel == null) Future.sync(() => {_getParameters()});
    if (currentConfigModel == null) Future.sync(() => {_getConfig()});
    if (!_isloaded) _LoadConfigState();
    var v = Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditTextFieldScreen(
                        idiomaEntrada: U2StringUtils.cString(this._selectedLanguage),
                        perfilEntrada: U2StringUtils.cString(this._selectedPerfil))),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce tu nombre';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              value: _selectedPrefix,
              decoration: InputDecoration(
                labelText: 'Prefijo',
              ),
              items:
                  currentParameterModel!.prefixes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPrefix = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecciona un prefijo';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'API Key',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce tu API Key';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              value: _selectedModel,
              decoration: InputDecoration(
                labelText: 'Modelo',
              ),
              items:
                  currentParameterModel!.models.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedModel = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecciona un modelo';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              value: _selectedLanguage,
              decoration: InputDecoration(
                labelText: 'Idioma',
              ),
              items: currentParameterModel!.languages
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecciona un idioma';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              value: _selectedPerfil,
              decoration: InputDecoration(
                labelText: 'Perfil de la IA',
              ),
              items:
                  currentParameterModel!.perfiles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPerfil = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecciona un perfil';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _numTokensController,
              decoration: InputDecoration(
                labelText: 'Númde tokens (100-4000)',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Número de máximo de tokens (100-4000)';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _numTemperatureController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Valor entre 0 y 1 con un decimal',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingrese un valor';
                }
                num numero = U2StringUtils.cNumDef(num.tryParse(value), 0);
                if (numero < 0 || numero > 1) {
                  return 'El valor debe estar entre 0 y 1';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ConfigModel newConfig = ConfigModel(
                      nombre: _nombreController.text,
                      prefijo: _selectedPrefix!,
                      apiKey: _apiKeyController.text,
                      modelo: _selectedModel!,
                      idioma: _selectedLanguage!,
                      perfil: _selectedPerfil!,
                      numTokens:
                          U2StringUtils.cIntDef(int.tryParse(_numTokensController.text), 1000),
                      temperature: U2StringUtils.cNumDef(
                          num.tryParse(_numTemperatureController.text), 0));
                  currentConfigModel = newConfig;
                  bool canvi = (currentOpenAIApiClient.model != newConfig.modelo);
                  currentOpenAIApiClient.setFromConfigModel(newConfig);
                  if (canvi) {
                    currentOpenAIApiClient.conversation_id = '';
                  }
                  await ConfigProvider.saveConfig(newConfig);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Configuración guardada')),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar configuración'),
            ),
          ],
        ),
      ),
    );
    return v;
  }
}
