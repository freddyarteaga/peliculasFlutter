import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas en Cine'),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
            child: Column(
          children: <Widget>[_swiperTarjetas()],
        )));
  }

  Widget _swiperTarjetas() {
    final peliculasProvider = new PeliculasProvider();
    peliculasProvider.getEnCines();

    return CardSwiper(
      peliculas: [1, 2, 3, 4],
    );
  }
}
