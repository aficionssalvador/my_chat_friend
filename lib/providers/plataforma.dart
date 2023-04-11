import 'package:flutter/material.dart';
import 'dart:io';

/// =================================
/// todo: seleccionar la plataforma
/// =================================
///
/// windows
///
/// al fitxer: pubspec.yaml
///
/// comentar les linies
///
/// dependencies:
///   flutter:
///     sdk: flutter
///   # /// windows!
///   # flutter_tts: ^3.6.3
///   # speech_to_text: ^5.3.0
///
/// descomentar el seguent bloc de codi
/*
final sepPath = '\\';

// text_to_speech.dart
class TextToSpeech {

  Future<void> doSpeak(String text, BuildContext context, String language) async {
  }
}

class SpeechRecognizer {
  Future<bool> initialize() async {
    return false;
  }

  Future<bool> startListening(Function(String) onResult,{String? language}) async {
    return false;
  }

  void stopListening() {
  }

  bool get isListening => false;
}
/// */
///
/// android
///
/// al fitxer: pubspec.yaml
///
/// descomentar les linies
///
/// dependencies:
///   flutter:
///     sdk: flutter
///   # /// windows!
///   flutter_tts: ^3.6.3
///   speech_to_text: ^5.3.0
///
/// comentar el seguent bloc de codi
/// /*
import 'package:flutter_tts/flutter_tts.dart';
import '/providers/config_provider.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

final sepPath = '/';

// text_to_speech.dart
class TextToSpeech {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> doSpeak(String text, BuildContext context, String language) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mensaje enviado a TTS'),
      ),
    );

    if (language == "Català") {
      await _flutterTts.setLanguage('ca-ES');
    } else {
      await _flutterTts.setLanguage('es-ES');
    }

    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.6);
    await _flutterTts.speak(text);
  }
}


// speech_recognizer.dart
class SpeechRecognizer {
  final SpeechToText _speech = SpeechToText();
  String _lang = "";
  bool _initialized = false;
  bool get initialized => _initialized;

  Future<bool> initialize() async {
    if(!_initialized) {
      _initialized = await _speech.initialize(
        onError: (error) => print('Error: $error'),
        onStatus: (status) => print('Status: $status'),
      );
    }
    print('initialize SpeechRecognizer_ $_initialized');
    return _initialized;
  }

  Future<bool> startListening(Function(String) onResult,{String? language}) async {
    if (language != null) {
      if (language == "Català") {
        _lang = 'ca-ES';
      } else {
        _lang = 'es-ES';
      }
    } else _lang = "";

    if (!_speech.isListening) {
      if (_lang != "") {
        await _speech.listen(
          onResult: (SpeechRecognitionResult result) {
            print("Resultat1= ${result.recognizedWords}");
            onResult(result.recognizedWords);
            },
          localeId: _lang,
          listenFor: Duration(minutes: 5),
          pauseFor: Duration(seconds: 5), // no funciona esta prefixat pel SO
          partialResults: true,
          cancelOnError: false,
          listenMode: ListenMode.confirmation,
        );
        return _speech.isListening;
      } else {
        await _speech.listen(
          onResult: (SpeechRecognitionResult result) {
            print("Resultat2= ${result.recognizedWords}");
            onResult(result.recognizedWords);
          },
          listenFor: Duration(minutes: 5),
          pauseFor: Duration(seconds: 5),  // no funciona esta prefixat pel SO
          partialResults: true,
          cancelOnError: false,
          listenMode: ListenMode.confirmation,
        );
        return _speech.isListening;
      }
    }
    return false;
  }

  void stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
  }

  bool get isListening => _speech.isListening;
}
/// */
/* =========================================
   a modificar per fer el build amb android
   =========================================


```` C:\Users\s_rig\AndroidStudioProjects\my_chat_friend\android\build.gradle
buildscript {
    ext.kotlin_version = '1.6.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.1.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
````

   =========================================

```` C:\Users\s_rig\AndroidStudioProjects\my_chat_friend\android\gradle\wrapper\gradle-wrapper.properties
distributionUrl=https\://services.gradle.org/distributions/gradle-7.4-all.zip
````

   =========================================

```` C:\Users\s_rig\AndroidStudioProjects\my_chat_friend\android\app\build.gradle
android {
  defaultConfig {
    minSdkVersion 21
  }
}
````

   =========================================

```` C:\Users\s_rig\AndroidStudioProjects\my_chat_friend\android\app\src\main\AndroidManifest.xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />

````
 */