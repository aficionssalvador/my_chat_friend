import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '/models/lista_ficheros_model.dart';
import '/providers/config_provider.dart';
import '/providers/lista_ficheros_provider.dart';
import '/providers/messages_provider.dart';
import '/providers/open_ai_provider.dart';
import '/providers/parameters_provider.dart';
import '/providers/plataforma.dart';
import '/screens/configuration_screen.dart';
import '/screens/lista_ficheros_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  final TextToSpeech _textToSpeech = TextToSpeech();
  final SpeechRecognizer _speechRecognizer = SpeechRecognizer();
  late bool _loading;
  late MessagesProvider messagesProvider;
  String total = "";

  bool _isListening = false;
  bool calIconeMicro = true;

  @override
  void initState() {
    super.initState();
    _loading = false;
    if (currentParameterModel == null) Future.sync(() => {_getParameters()});
    if (currentConfigModel == null) Future.sync(() => {_getConfig()});
    // Future.sync(() => {_speechRecognizer.initialize()});
    // calIconeMicro = _speechRecognizer.initialized;
    // calIconeMicro = SpeechRecognizer.isRecognitionAvailable(context);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mensaje copiado al portapapeles'),
      ),
    );
  }

  String totalTokens() {
    String unit = '';
    int t1 = 0;
    if (currentOpenAIApiClient.TotalnumTokens > 5000000000000) {
      t1 = currentOpenAIApiClient.TotalnumTokens ~/ 1000000000000;
      unit = 'T';
    } else if (currentOpenAIApiClient.TotalnumTokens > 5000000000) {
      t1 = currentOpenAIApiClient.TotalnumTokens ~/ 1000000000;
      unit = 'G';
    } else if (currentOpenAIApiClient.TotalnumTokens > 5000000) {
      t1 = currentOpenAIApiClient.TotalnumTokens ~/ 1000000;
      unit = 'M';
    } else if (currentOpenAIApiClient.TotalnumTokens > 5000) {
      t1 = currentOpenAIApiClient.TotalnumTokens ~/ 1000;
      unit = 'K';
    } else {
      t1 = currentOpenAIApiClient.TotalnumTokens;
      unit = '';
    }
    return total = '$t1 $unit';
  }

  Future<void> _speak(String text) async {
    return _textToSpeech.doSpeak(text, context, currentConfigModel!.idioma);
  }

  void _startListening() async {
    try {
      if (!_speechRecognizer.isListening) {
        await _speechRecognizer.initialize();
        bool started = await _speechRecognizer.startListening((recognizedWords) {
          setState(() {
            _controller.text = recognizedWords;
            _isListening = _speechRecognizer.isListening;
            calIconeMicro = _speechRecognizer.initialized;
          });
        });
        calIconeMicro = started;
        if (!started) {
          print('No se pudo iniciar la escucha');
          setState(() {
            _isListening = _speechRecognizer.isListening;
            calIconeMicro = _speechRecognizer.initialized;
          });
        }
      } else {
        _speechRecognizer.stopListening();
        setState(() {
          _isListening = _speechRecognizer.isListening;
          calIconeMicro = _speechRecognizer.initialized;
        });
      }
    } catch (e) {
      print('Error al iniciar la escucha: $e');
      // Muestra un mensaje de error al usuario (por ejemplo, utilizando un SnackBar, un AlertDialog o un mensaje personalizado en la UI)
      setState(() {
        _isListening = _speechRecognizer.isListening;
        calIconeMicro = _speechRecognizer.initialized;
      });
    }
  }
  void _stopListening() async {
    _speechRecognizer.stopListening();
    setState(() {
      _isListening = _speechRecognizer.isListening;
      calIconeMicro = _speechRecognizer.initialized;
    });
  }

  Future<void> _getParameters() async {
    try {
      currentParameterModel = await ParametersProvider.readParameter();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getConfig() async {
    try {
      currentConfigModel = await ConfigProvider.readConfig();
      currentOpenAIApiClient.setFromConfigModel(currentConfigModel!);
      _loading = true;
      String texte = devuelveSaludo();
      if ((texte != "")&&(messagesProvider.messages.length == 0)) {
        messagesProvider.addMessage(texte, false);
      }
      _loading = false;
    } catch (e) {
      print(e);
    }
  }

  String devuelveSaludo(){
    //String texteCat;
    //String texteEsp;
    String texte = "";
    if (currentConfigModel!.nombre != "") {
      texte = currentParameterModel!.getPI(currentConfigModel!.idioma, "salutacio");
      //texteCat = "Digues quelcolm.";
      //texteEsp = "Di algo.";
    } else {
      texte = currentParameterModel!.getPI(currentConfigModel!.idioma, "wellcome");
      //texteCat = "Benvingut a my_chat_friend. \n\nSi és la primera vegada que executes l'aplicació vés a la pantalla de configuració i configura el teu nom. \nLa configuració es realitza en local al dispositiu. \nEl creador de l'aplicació no guarda cap dada teva.";
      //texteEsp = "Bienvenido a my_chat_friend. \n\nSi es la primera vez que ejecutas la aplicación ve a la pantalla de configuración y configura tu nombre. \nLa configuración se realiza en local en tu dispositivo. \nEl creador de la aplicación no guarda ningun dato tuyo.";
    }
    //String texte = (currentConfigModel!.idioma == "Català") ? texteCat : texteEsp;
    return texte;
  }

  @override
  Widget build(BuildContext context) {
    if (currentParameterModel == null) Future.sync(() => _getParameters());
    if (currentConfigModel == null) Future.sync(() => _getConfig());
    messagesProvider = Provider.of<MessagesProvider>(context);
    // Añade mensajes de ejemplo al proveedor de mensajes si está vacío
    total = totalTokens();
    return Scaffold(
      appBar: AppBar(
        title: Text('MyChat ($total tokens)'),
        actions: [
          IconButton(
            icon: Icon(Icons.read_more),
            onPressed: () async {
              MyficheroListaItemsConversa s = await showListaFicherosScreenModal(context);
              if (s != null) {
                if (s.listaItems.length > 0) {
                  _loading = true;
                  messagesProvider.clearMessages("Recuperado del fichero: ${s.getFechaHora()}");
                  currentOpenAIApiClient.ListaMsg.clear();
                  currentOpenAIApiClient.TotalnumTokens = 0;
                  for (int i = 0; i < s.listaItems.length; i++) {
                    String rol = s.listaItems[i].role;
                    bool isUser = (rol == "user");
                    num tk = s.listaItems[i].tk;
                    String eltext = s.listaItems[i].content;
                    currentOpenAIApiClient.TotalnumTokens += tk.toInt();
                    messagesProvider.addMessage(eltext, isUser);
                    currentOpenAIApiClient.ListaMsg.add({
                      'role': rol,
                      'content': eltext,
                      'tk': tk,
                    });
                  }
                  String cadenaid = s.fichero!.path.split(sepPath).last;
                  cadenaid = cadenaid.replaceAll("Coversa_", "").replaceAll(".txt", "");
                  var vid = cadenaid.split("_");
                  currentOpenAIApiClient.conversation_id = "${vid[0]}_${vid[1]}";
                  currentOpenAIApiClient.id = "${vid[2]}";
                  setState(() {
                    total = totalTokens();
                    _loading = false;
                  });
                  await Future.delayed(const Duration(milliseconds: 100));
                  _scrollDown();
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfiguracionScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: _loading,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              itemCount: messagesProvider.messages.length,
              itemBuilder: (context, index) {
                final message = messagesProvider.messages[index];
                bool isUserMessage = message.isUser;
                return Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: GestureDetector(
                      onDoubleTap: () {
                        _copyToClipboard(message.text);
                      },
                      onLongPress: () {
                        // _copyToClipboard(message.text);
                        _speak(message.text);
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: MarkdownBody(
                          data: message.text,
                          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                            p: TextStyle(
                              fontSize: 16.0,
                              color: isUserMessage ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                FutureBuilder<bool>(
                  future: null,
                  builder: (context, snapshot) {
                    return IconButton(
                      icon: Icon(Icons.cleaning_services),
                      onPressed: () async {
                        // currentOpenAIApiClient.ListaMsg.clear();
                        currentOpenAIApiClient.conversation_id = '';
                        _loading = true;
                        String texte = devuelveSaludo();
                        messagesProvider.clearMessages(texte);
                        messagesProvider.notifyListeners();
                        _loading = false;
                      },
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    maxLines: 5,
                    minLines: 1,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ),
                FutureBuilder<bool>(
                  future: null,
                  builder: (context, snapshot) {
                    if (_loading) {
                      return CircularProgressIndicator();
                    } else {
                      return Row(
                        children: [
                        Visibility(
                          visible: calIconeMicro,
                          child: IconButton(
                            icon: _speechRecognizer.isListening ? Icon(Icons.mic_off) : Icon(Icons.mic),
                            onPressed: _speechRecognizer.isListening ? _stopListening : _startListening,
                          ),
                        ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () async {
                              if (!_loading) {
                                if (_controller.text.isNotEmpty) {
                                  _loading = true;
                                  var v = _sendMessage();
                                }
                              }
                            },
                          ),
                      ]);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<bool> _sendMessage() async {
    // añade el mensaje
    String elText = _controller.text;
    messagesProvider.addMessage(elText, true);

    await Future.delayed(const Duration(milliseconds: 50));
    _scrollDown();
    _controller.clear();
    // Obtiene la respuesta de la API
    String response = await currentOpenAIApiClient.generateText(elText,currentOpenAIApiClient.conversation_id);

    // añade la respuesta
    messagesProvider.addMessage(response, false);
    await Future.delayed(const Duration(milliseconds: 50));
    _scrollDown();

    setState(() {
      _loading = false;
    });


    return true;
  }
}
