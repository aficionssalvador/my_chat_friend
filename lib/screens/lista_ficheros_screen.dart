import 'package:flutter/material.dart';

import '/models/lista_ficheros_model.dart';
import '/providers/lista_ficheros_provider.dart';
import '/providers/plataforma.dart';

import '/screens/lista_chat_screen.dart';

Future<MyficheroListaItemsConversa> showListaFicherosScreenModal(BuildContext context) async {
  final result = await showDialog<MyficheroListaItemsConversa>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListaFicherosScreen(),
        ),
      );
    },
  );
  if (result == null) {
    return MyficheroListaItemsConversa(listaItems: <ItemConversa>[]);
  }
  return result!;
}

class ListaFicherosScreen extends StatefulWidget {
  @override
  _ListaFicherosScreenState createState() => _ListaFicherosScreenState();
}

class _ListaFicherosScreenState extends State<ListaFicherosScreen> {
  List<MyficheroListaItemsConversa> _ficheros = <MyficheroListaItemsConversa>[];

  @override
  void initState() {
    super.initState();
    obtenerFicheros('Coversa_').then((List<MyficheroListaItemsConversa> ficheros) {
      setState(() {
        _ficheros = ficheros;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Ficheros')),
      body: ListView.builder(
        itemCount: _ficheros.length,
        itemBuilder: (BuildContext context, int index) {
          final MyficheroListaItemsConversa fichero = _ficheros[index];
          return ListTile(
            title: Text("${fichero.getFechaHora()}"),
            subtitle: Text("${fichero.getContenido()}"),
            onTap: () async {
              MyficheroListaItemsConversa s = await showListaChatScreenModal(context, fichero);
              if (s != null) {
                if (s.calEliminar) {
                  bool ok = await deleteFile(_ficheros[index].fichero!.path.split(sepPath).last);
                  if (ok) {
                    MyficheroListaItemsConversa fichereliminat = _ficheros.removeAt(index);
                    setState(() {
                      _ficheros;
                    });
                  }
                } else if (s.listaItems.length > 0) {
                  // carregar dades
                  Navigator.pop(context, s);
                }
              }
            },
          );
        },
      ),
    );
  }
}
