import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitan America',
    'Superman',
    'Ironman 2',
    'Ironman 3',
    'Ironman 4',
    'Ironman 5',
  ];

  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro AppBar como borrar o cancelar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando la persona escribe

    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  }
}
