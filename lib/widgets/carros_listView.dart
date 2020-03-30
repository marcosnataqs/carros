import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'package:carros/pages/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/domain/carro.dart';

class CarrosListView extends StatelessWidget {
  final List<Carro> carros;

  const CarrosListView(this.carros);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: carros.length,
      itemBuilder: (ctx, idx) {
        final c = carros[idx];
        return Container(
          child: InkWell(
            onTap: () {
              _onClickCarro(context, c);
            },
            onLongPress: () {
              _onLongClickCarro(context, c);
            },
            child: Card(
                child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                      child: Image.network(c.urlFoto ??
                          "http://www.livroandroid.com.br/livro/carros/esportivos/Ferrari_FF.png")),
                  Text(
                    c.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                  Text(
                    c.desc,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('DETALHES'),
                          onPressed: () {
                            _onClickCarro(context, c);
                          },
                        ),
                        FlatButton(
                          child: const Text('SHARE'),
                          onPressed: () {
                            _onClickShare(context, c);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ),
        );
      },
    );
  }

  _onClickCarro(BuildContext context, Carro c) {
    push(context, CarroPage(c));
  }

  _onLongClickCarro(BuildContext context, Carro c) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  c.nome,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text("Detalhes"),
                leading: Icon(Icons.directions_car),
                onTap: () {
                  Navigator.pop(context);
                  _onClickCarro(context, c);
                },
              ),
              ListTile(
                title: Text("Share"),
                leading: Icon(Icons.share),
                onTap: () {
                  Navigator.pop(context);
                  _onClickShare(context, c);
                },
              ),
            ],
          );
        });
  }

  _onClickShare(BuildContext context, Carro c) {
    print("Share ${c.nome}");

    Share.share(c.urlFoto);
  }
}
