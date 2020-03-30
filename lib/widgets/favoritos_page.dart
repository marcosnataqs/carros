import 'package:flutter/material.dart';

import 'package:carros/domain/db/CarroDB.dart';
import 'package:carros/widgets/carros_listView.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: _body(),
    );
  }

  _body() {
    Future future = CarroDB.getInstance().getCarros();

    return Container(
      padding: EdgeInsets.all(12),
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              "Nenhum carro disponível!",
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ));
          } else if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return CarrosListView(snapshot.data);
          }
        },
      ),
    );
  }
}