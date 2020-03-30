import 'dart:async';

import 'package:carros/domain/services/carro_service.dart';

class CarrosBloc {
  final _controller = StreamController();

  get stream => _controller.stream;

  fetch(String tipo) {
    Future future = CarroService.getCarros(tipo);
    future.then((carros) {
      _controller.sink.add(carros);
    });
  }

  close() {
    _controller.close();
  }
}