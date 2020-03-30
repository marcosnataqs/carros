import 'dart:io';

import 'package:carros/domain/services/carros_bloc.dart';
import 'package:carros/widgets/carros_listView.dart';
import 'package:flutter/material.dart';

class CarrosPage extends StatefulWidget {
  final String tipo;

  const CarrosPage(this.tipo);

  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage>
    with AutomaticKeepAliveClientMixin<CarrosPage> {
  final _bloc = CarrosBloc();

  get tipo => widget.tipo;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _bloc.fetch(widget.tipo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: _body(),
    );
  }

  _body() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        padding: EdgeInsets.all(12),
        child: StreamBuilder(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error;

              return Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Text(
                      error is SocketException
                          ? "Conexão indisponível, por favor verifique sua internet."
                          : "Ocorreu um erro ao buscar a lista de carros",
                      style: TextStyle(color: Colors.grey, fontSize: 25),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return CarrosListView(snapshot.data);
            }
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() {
    print("onRefresh");
    return Future.delayed(Duration(seconds: 3), () {
      return _bloc.fetch(tipo);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}