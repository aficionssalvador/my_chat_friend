import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '/models/parameter_model.dart';
import '/providers/open_ai_provider.dart';

ParameterModel? currentParameterModel;

class ParametersProvider {
  static const String _parametersFileName = 'my_chat_friend_parametros.json';
  static Future<File>? _parametersFile;

  static String getPI(String idioma, String perfil) {
    List _pi = currentParameterModel!.pi;
    for (int i = 0; i < _pi!.length; i++) {
      var m = _pi[i];
      String _idioma = m!['idioma'];
      String _perfil = m!['perfil'];
      if ((_idioma == idioma) && (_perfil == perfil)) {
        return m!['content'];
      }
    }
    return '';
  }

  static void setPI(String idioma, String perfil, String valor) {
    List _pi = currentParameterModel!.pi;
    for (int i = 0; i < _pi.length; i++) {
      var m = _pi[i];
      if ((m['idioma'] == idioma) && (m['perfil'] == perfil)) {
        _pi[i]['content'] = valor;
        currentOpenAIApiClient.systemContext = valor;
        return;
      }
    }
  }

  static Future<File> get _localFile async {
    if (_parametersFile == null) {
      _parametersFile = _getParametersFile();
    }
    return _parametersFile!;
  }

  static Future<ParameterModel> readParameter() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        dynamic v = await json.decode(jsonString);
        currentParameterModel = ParameterModel.ParameterModelFromJson(v);
        return currentParameterModel!;
      } else {
        dynamic v = json.decode(await loadJsonFile(_parametersFileName));
        currentParameterModel = ParameterModel.ParameterModelFromJson(v);
        return currentParameterModel!;

        // throw FileSystemException("El archivo de parametros no existe");
      }
    } catch (e) {
      dynamic v = json.decode(await loadJsonFile(_parametersFileName));
      currentParameterModel = ParameterModel.ParameterModelFromJson(v);
      return currentParameterModel!;
      // throw e;
    }
  }

  static Future<File> saveParameters() async {
    final file = await _localFile;
    return file.writeAsString(
        json.encode(ParameterModel.ParameterModelToJson(currentParameterModel!)));
  }

  static Future<File> _getParametersFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_parametersFileName');
  }

  static Future<String> loadJsonFile(String fileName) async {
    String jsonString = await rootBundle.loadString('assets/json/$fileName');
    return jsonString;
    //return json.decode(jsonString);
  }
}
