import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = 'e24befd41e992c3d66c6663072bf02f1';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  //declaramos el streamController como un listado de peliculas Boradcast para que sea
  //escuchado de diferentes lados
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  // funcion para escuchar todo lo que el stream emita
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  // metodo para escuchar la salida de peliculas
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }

  // utilizamos un Future y no un stream porque la cantidad de actores
  // va ser finito, pueden ser 20 y no va pasar mas de eso
  Future<List<Actor>> getCast(String peliId) async {
    // creamos la URL
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});
    // ejecutamos el http de la URL el cual es almacenado e la respuesta
    // con el await espero la respuesta
    final resp = await http.get(url);
    // almaceno la repsuesta del mapa
    final decodedData = json.decode(resp.body);
    // mandamos el mapa en su propiedad de cast
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _procesarRespuesta(url);
  }
}
