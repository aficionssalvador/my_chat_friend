import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '/models/config_model.dart';

ConfigModel? currentConfigModel;

class ConfigProvider {
  static const String _configFileName = 'my_chat_friend_config.json';
  static Future<File>? _configFile;

  static Future<File> get _localFile async {
    if (_configFile == null) {
      _configFile = _getConfigFile();
    }
    return _configFile!;
  }

  static Future<File> _getConfigFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_configFileName');
  }

  static Future<ConfigModel> readConfig() async {
    try {
      final file = await _localFile;

      if (await file.exists()) {
        String jsonString = await file.readAsString();
        currentConfigModel = ConfigModel.fromMap(json.decode(jsonString));
        return currentConfigModel!;
      } else {
        currentConfigModel =
            ConfigModel.fromMap(json.decode(await loadJsonFile(_configFileName)));
        return currentConfigModel!;
        //throw FileSystemException("El archivo de configuración no existe");
      }
    } catch (e) {
      currentConfigModel =
          ConfigModel.fromMap(json.decode(await loadJsonFile(_configFileName)));
      return currentConfigModel!;
      throw e;
    }
  }

  static Future<File> saveConfig(ConfigModel config) async {
    final file = await _localFile;
    return file.writeAsString(json.encode(config.toMap()));
  }

  static Future<String> loadJsonFile(String fileName) async {
    String jsonString = await rootBundle.loadString('assets/json/$fileName');
    return jsonString;
  }
}
