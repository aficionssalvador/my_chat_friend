import 'dart:io';
import '/u2/u2_string_utils.dart';
import '/providers/plataforma.dart';

class MyficheroListaItemsConversa {
  File? fichero;
  List<ItemConversa> listaItems;
  bool calEliminar = false;

  MyficheroListaItemsConversa({this.fichero, required this.listaItems});

  String getFechaHora() {
    String s = fichero!.path.split(sepPath).last;
    String sData=U2StringUtils.DateTime2DataS(U2StringUtils.u2TADA2DateTime(s.split('_')[1]));
    String shora=U2StringUtils.DateTime2HoraMinSecS(U2StringUtils.u2HHMMSS2DateTime(s.split('_')[2]));
    return "${sData} ${shora}";
  }

  String getContenido() {
    return listaItems[0].content;
  }
}

class ItemConversa {
  String role;
  String content;
  num tk;

  ItemConversa({
    required this.role,
    required this.content,
    required this.tk,
  });

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
      'tk': tk,
    };
  }

  factory ItemConversa.fromMap(Map<String, dynamic> map) {
    return ItemConversa(
      role: map['role'],
      content: map['content'],
      tk: map['tk'],
    );
  }
}
