import 'dart:core';

class ConfigModel {
  final String nombre;
  final String prefijo;
  final String apiKey;
  final String modelo;
  final String idioma;
  final String perfil;
  final int numTokens;
  final num temperature;

  ConfigModel(
      {required this.nombre,
      required this.prefijo,
      required this.apiKey,
      required this.modelo,
      required this.idioma,
      required this.perfil,
      required this.numTokens,
      required this.temperature});

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'prefijo': prefijo,
      'apiKey': apiKey,
      'modelo': modelo,
      'idioma': idioma,
      'perfil': perfil,
      'numTokens': numTokens,
      'temperature': temperature,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      nombre: map['nombre'] as String,
      prefijo: map['prefijo'] as String,
      apiKey: map['apiKey'] as String,
      modelo: map['modelo'] as String,
      idioma: map['idioma'] as String,
      perfil: map['perfil'] as String,
      numTokens: map['numTokens'] as int,
      temperature: map['temperature'] as num,
    );
  }
}
