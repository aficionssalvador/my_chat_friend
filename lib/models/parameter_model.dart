import 'dart:convert';
import 'dart:core';

class ParameterModel {
  List<String> prefixes;
  List<String> models;
  List<String> languages;
  List<String> perfiles;
  List pi;

  ParameterModel(
      {required this.prefixes,
      required this.models,
      required this.languages,
      required this.perfiles,
      required this.pi});

  //static ParameterModel ParameterModelFromJson(Map<String, dynamic> jsondynamic) => ParameterModel(
  static ParameterModel ParameterModelFromJson(dynamic jsondynamic) => ParameterModel(
        prefixes: List<String>.from(jsondynamic[0]['prefijos'].map((x) => x.toString())),
        models: List<String>.from(jsondynamic[1]['modelos'].map((x) => x.toString())),
        languages: List<String>.from(jsondynamic[2]['idiomas'].map((x) => x.toString())),
        perfiles: List<String>.from(jsondynamic[3]['perfil'].map((x) => x.toString())),
        pi: jsondynamic[4]['pi'] as List,
      );

  static ParameterModel ParameterModelFromString(String jsonString) {
    Map<String, dynamic> jsondynamic = json.decode(jsonString);
    return ParameterModel(
      prefixes: List<String>.from(jsondynamic[0]['prefijos'].map((x) => x.toString())),
      models: List<String>.from(jsondynamic[1]['modelos'].map((x) => x.toString())),
      languages: List<String>.from(jsondynamic[2]['idiomas'].map((x) => x.toString())),
      perfiles: List<String>.from(jsondynamic[3]['perfil'].map((x) => x.toString())),
      pi: jsondynamic[4]['pi'] as List,
    );
  }

  static List ParameterModelToJson(ParameterModel instance) => [
        {
          'prefijos': instance.prefixes,
        },
        {
          'modelos': instance.models,
        },
        {
          'idiomas': instance.languages,
        },
        {
          'perfil': instance.perfiles,
        },
        {
          'pi': instance.pi,
        },
      ];

  String getPI(String idioma, String perfil) {
    List _pi = this.pi;
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

}
