import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '/models/lista_ficheros_model.dart';
import '/providers/plataforma.dart';

Future<List<MyficheroListaItemsConversa>> obtenerFicheros(String plantilla) async {
  final Directory directorio = await getApplicationDocumentsDirectory();
  final List<MyficheroListaItemsConversa> ficheros = [];
  final List<FileSystemEntity> entidades = directorio.listSync();

  for (FileSystemEntity entidad in entidades) {
    if (entidad is File) {
      final String nombreFichero = entidad.path.split(sepPath).last;
      if (nombreFichero.contains(plantilla)) {
        List<ItemConversa> items = await leerFichero(entidad);
        ficheros.add(MyficheroListaItemsConversa(fichero: entidad, listaItems: items));
      }
    }
  }

  return ficheros;
}

Future<List<ItemConversa>> leerFichero(File file) async {
  String s = await file.readAsString();
  List resultado = await json.decode(s);
  return List.generate(resultado.length, (i) {
    return ItemConversa.fromMap(resultado[i]);
  });
}

Future<bool> deleteFile(String fileName) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    if (await file.exists()) {
      await file.delete();
      print('Archivo borrado exitosamente');
      return true;
    } else {
      print('El archivo no existe');
      return false;
    }
  } catch (e) {
    print('Error al borrar el archivo: $e');
    return false;
  }
}
