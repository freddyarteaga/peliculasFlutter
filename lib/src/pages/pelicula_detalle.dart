import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //asigamos los argumentos a pelicula
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: Center(
      child: Text(pelicula.title),
    ));
  }
}
