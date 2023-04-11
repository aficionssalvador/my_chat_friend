import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '/providers/lista_ficheros_provider.dart';
import '/models/lista_ficheros_model.dart';

Future<MyficheroListaItemsConversa> showListaChatScreenModal(
    BuildContext context, MyficheroListaItemsConversa item) async {
  final result = await showDialog<MyficheroListaItemsConversa>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListaChatScreen(item: item),
        ),
      );
    },
  );
  if (result == null) {
    return MyficheroListaItemsConversa(listaItems: <ItemConversa>[]);
  }
  return result!;
}

class ListaChatScreen extends StatelessWidget {
  final MyficheroListaItemsConversa item;

  ListaChatScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    // Añade mensajes de ejemplo al proveedor de mensajes si está vacío
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar conversa?'),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () async {
              Navigator.pop(context, item);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              item.calEliminar = true;
              Navigator.pop(context, item);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: item.listaItems.length,
              itemBuilder: (BuildContext context, int index) {
                bool isUserMessage = (item.listaItems[index].role == "user");
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: MarkdownBody(
                      data: item.listaItems[index].content,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                        p: TextStyle(
                          fontSize: 16.0,
                          color: isUserMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
