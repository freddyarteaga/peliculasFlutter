import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    // necesitamos saber cual es el tamano de pantalla
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
        // definimos que sea el 20% de la pagina
        height: _screenSize.height * 0.3,
        // nos sirve para poder deslizar paginas o widgets(PageView)
        child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: peliculas.length,
          itemBuilder: (context, i) {
            return _tarjeta(context, peliculas[i]);
          },
        ));
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    //se envia una referencia modificada propia del modelo a una nueva propiedad
    // para que no entren en conflicto con las otras peliculas del horizotal
    pelicula.uniqueId = '${pelicula.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            //id unico que debe identificar esta tarjeta desde el punto a donde va
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    // para detectar cuando se hace click o cualquier otra cosa

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        // print('Nombre  de la peplicula ${pelicula.title}');
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
}
