import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '/models/config_model.dart';
import '/providers/config_provider.dart';
import '/providers/parameters_provider.dart';
import '/u2/u2_string_utils.dart';

OpenAIApiClient currentOpenAIApiClient = OpenAIApiClient();

class OpenAIApiClient {
  String apiKey = '';
  String model = '';
  int maxTokens = 0;
  Encoding srcEncoding = utf8; // Set de caracteres de origen (UTF-8)
  Encoding destEncoding = latin1; // Set de caracteres de destino (Latin1)
  final String apiUrlGen = 'https://api.openai.com/v1/chat/completions';
  final String apiUrlTurbo = 'https://api.openai.com/v1/engines/gpt-3.5-turbo/completions';
  String apiUrl = "";
  String conversation_id = '';
  int numTokens = 0;
  int TotalnumTokens = 0;
  List ListaMsg = [];
  num temperature = 0;
  String id = "";

  String systemContext = '';

  OpenAIApiClient() {
    // no fa res
    this.apiUrl = this.apiUrlGen;
  }

  int countDistinctTokens(String text) {
    // Convertimos el texto en una lista de tokens separados por espacios

    List<String> tokens = text.replaceAll(RegExp(r'[^\w\s]+'), ' ').split(' ');

    // Creamos un conjunto vacío para almacenar los tokens únicos
    Set<String> uniqueTokens = {};

    // Iteramos sobre cada token y lo agregamos al conjunto
    for (String token in tokens) {
      if (token != '') {
        uniqueTokens.add(token.toLowerCase());
      }
    }
    // Devolvemos el número de tokens únicos
    print('unike: ${uniqueTokens.length}');
    return uniqueTokens.length;
  }

  int countTokensOld(String text) {
    // Convertimos el texto en una lista de tokens separados por espacios

    List<String> tokens = text.replaceAll(RegExp(r'[^\w\s]+'), ' ').split(' ');
    int cnt = 0;
    for (String token in tokens) {
      if (token != '') {
        cnt++;
      }
    }
    // Devolvemos el número de tokens únicos
    print('tk: ${cnt}');
    return cnt;
  }

  int countTokens(String text) {
    // Dividir el texto en palabras y caracteres especiales utilizando expresiones regulares
    RegExp regExp = RegExp(r'\w+|[^\s\w]+');
    List<String> tokens = regExp.allMatches(text).map((e) => e.group(0) ?? '').toList();
    return tokens.length;
  }


  String copiaListaString(List origen, int posInicial) {
    String destino = '';
    String sep = '';
    for (int i = posInicial; i < origen.length; i++) {
      dynamic v = origen[i];
      destino = destino + sep + v['content'];
      sep = '\n';
    }
    print('len: ${destino.length}');
    return destino;
  }

  List ultimosTokens(int tokensCabecera, int tokensMensaje) {
    List listaTockens = [];
    for (int i = 0; i < this.ListaMsg.length; i++) {
      /// if ((countDistinctTokens(copiaListaString(this.ListaMsg,i))) <= (this.maxTokens)) {
      if ((countTokens(copiaListaString(this.ListaMsg,i)) + tokensCabecera + tokensMensaje) <= this.maxTokens) {
//      if ((copiaListaString(this.ListaMsg, i).length + tokensCabecera + tokensMensaje) <=(this.maxTokens * 0.4).toInt()) {
        print('i: $i');
        for (int j = i; j < this.ListaMsg.length; j++) {
          dynamic v = this.ListaMsg[j];
          dynamic m = {};
          m['role'] = v['role'];
          m['content'] = v['content'];
          listaTockens.add(m);
        }
        return listaTockens;
      }
    }
    return listaTockens;
  }

  Future<String> generateText(String prompt, String aNewConversationId) async {
    this.apiUrl = (this.model == 'gpt-3.5-turbo')
        ? 'https://api.openai.com/v1/engines/gpt-3.5-turbo/completions'
        : 'https://api.openai.com/v1/completions';
    // 'https://api.openai.com/v1/engines/davinci-codex/completions';
    this.apiUrl = 'https://api.openai.com/v1/chat/completions';
    if ((this.conversation_id == '') || ((aNewConversationId == ''))) {
      DateTime dt = DateTime.now();
      this.conversation_id =
          U2StringUtils.DateTime2u2TADA(dt) + '_' + U2StringUtils.DateTime2u2HHMMSS(dt);
      this.ListaMsg = [];
      this.id = "";
    }
    String s = _getBody(prompt); //, id);
    print(this.apiUrl);
    print(s);
    final response = await http.post(Uri.parse(this.apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: s);
    print(response.body);
    if (response.statusCode == 200) {
      print('maxtokens: ${this.maxTokens}');
      var jsonResponse = json.decode(response.body);
      if (id == "") {
        this.id = jsonResponse['id'];
      }
      String s = jsonResponse['choices'][0]['message']['content'];
      this.numTokens = jsonResponse['usage']['total_tokens'];
      this.TotalnumTokens += this.numTokens;
      //return convertEncoding(s, srcEncoding, destEncoding);
      String resultat = convertEncoding(s, destEncoding, srcEncoding);
      // afegir al context
      this.ListaMsg.add({
        'role': 'user',
        'content': prompt,
        'tk': 0,
      });
      this.ListaMsg.add({
        'role': 'assistant',
        'content': resultat,
        'tk': numTokens,
      });
      try {
        String msgfitxer = json.encode(this.ListaMsg);
        await _saveConversation(msgfitxer);
      } finally {}
      return resultat;
    } else {
      //throw Exception('Error: ${response.statusCode}');
      String menssageErr = '';
      if (response.body != '') {
        menssageErr = json.decode(response.body)['error']['message'];
      }
      return 'Error llamada al servidor: ${response.statusCode} $menssageErr';
    }
  }

  String _getBody(String prompt, [String novalid = ""]) {
    var counter = 0;
    // int tokensPrompt = countTokens(prompt);
    int tokensPrompt = prompt.length;
    int tokensSystem = 0;
    dynamic m = {};
    int max = (this.maxTokens).toInt();
    if (max > 3700) max = 3700;
    dynamic vobj = {
      'temperature': this.temperature,
      'max_tokens': max,
//      'top_p': 1,
//      'frequency_penalty': 0.0,
//      'presence_penalty': 0.0,
      'model': this.model,
      //'user': this.conversation_id,
    };
    if (this.id != "") {
      //vobj['user'] = this.id as String;
    }
    //vobj['model'] = this.model as String;
    List messagesArray = [];
    if (this.systemContext != '') {
      String s1 = this.systemContext;
      s1 = tractaParamConfig(s1, currentConfigModel!);
      m = {};
      m['role'] = 'system';
      m['content'] = s1;
      tokensSystem = countTokens(s1);
      tokensSystem = s1.length;
      messagesArray.add(m);
      counter += 1;
    }
    if (prompt != '') {
      int n = this.ListaMsg.length;

      messagesArray.addAll(ultimosTokens(tokensSystem, tokensPrompt));
      m = {};
      m['role'] = 'user';
      m['content'] = prompt;
      messagesArray.add(m);
      counter += 1;
      if (counter > 0) {
        vobj['messages'] = messagesArray;
      }
      counter += 1;
      //v['prompt'] = prompt;
    }
    return json.encode(vobj);
  }

  Future<File> _getConversationFile() async {
    final directory = await getApplicationDocumentsDirectory();
    print('${directory.path}');
    return File('${directory.path}/Coversa_${this.conversation_id}_${this.id}.txt');
  }

  Future<void> _saveConversation(String msg) async {
    final file = await _getConversationFile();
    await file.writeAsString(msg);
  }

  void setFromConfigModel(ConfigModel value) {
    this.apiKey = value!.apiKey;
    this.model = value!.modelo;
    this.systemContext = ParametersProvider.getPI(value!.idioma, value!.perfil);
    this.conversation_id = '';
    this.maxTokens = value!.numTokens;
    this.temperature = value!.temperature;
  }

  String convertEncoding(String input, Encoding srcEncoding, Encoding destEncoding) {
    // Convertir la cadena de entrada a bytes usando el set de caracteres de origen
    List<int> inputBytes = srcEncoding.encode(input);

    // Convertir los bytes a la cadena de caracteres usando el set de caracteres de destino
    String output = destEncoding.decode(inputBytes);
    return output;
  }

  String tractaParamConfig(String s1, ConfigModel configModel) {
    String fechaActual = U2StringUtils.DateTime2u2TADA(DateTime.now());
    fechaActual = U2StringUtils.u2Substr(fechaActual, 1, 4) +
        '-' +
        U2StringUtils.u2Substr(fechaActual, 5, 2) +
        '-' +
        U2StringUtils.u2Substr(fechaActual, 5, 2);
    try {
      s1 = U2StringUtils.u2Replace(s1, '^fecha', fechaActual);
    } finally {}
    try {
      s1 = U2StringUtils.u2Replace(s1, '^nombre', U2StringUtils.cString(configModel!.nombre));
    } finally {}
    try {
      s1 = U2StringUtils.u2Replace(s1, '^prefijo', U2StringUtils.cString(configModel!.prefijo));
    } finally {}
    try {
      s1 = U2StringUtils.u2Replace(s1, '^perfil', U2StringUtils.cString(configModel!.perfil));
    } finally {}
    try {
      s1 = U2StringUtils.u2Replace(s1, '^modelo', U2StringUtils.cString(configModel!.modelo));
    } finally {}
    try {
      s1 = U2StringUtils.u2Replace(s1, '^idioma', U2StringUtils.cString(configModel!.idioma));
    } finally {}
    return s1;
  }
}
