import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:admob_flutter/admob_flutter.dart';

const request = "https://api.hgbrasil.com/finance?format=json&key=1bef1c18";

void main() async {
  Admob.initialize(getAppId());
  runApp(Application());
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

String getAppId() {
  if (Platform.isIOS) {
    return '';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-8682283257399936/7918334881';
  }
  return null;
}

String getBannerAdId() {
  if (Platform.isIOS) {
    return '';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-8682283257399936~3851382770';
  }
  return null;
}

class _ApplicationState extends State<Application> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  double dollar;
  double euro;
  double bitcoin;

  @override
  void initState() {
    super.initState();
  }

  void _clearAll() {
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dollarController.text = (real / dollar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("\$ Conversão Fácil \$"),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando...",
                    style: TextStyle(color: Colors.purple, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  bitcoin = snapshot.data["results"]["bitcoin"]
                      ["mercadobitcoin"]["last"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                          ),
                          child: AdmobBanner(
                          adUnitId: getBannerAdId(),
                          adSize: AdmobBannerSize.BANNER,
                        ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Principais cotações do dia:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.monetization_on),
                              Padding(padding: EdgeInsets.only(right: 4.0)),
                              Text(
                                'Dollar',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4.0)),
                              Text(
                                'R\$ ' + dollar.toStringAsFixed(2),
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.euro_symbol),
                              Padding(padding: EdgeInsets.only(right: 4.0)),
                              Text(
                                'Euro',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4.0)),
                              Text(
                                'R\$ ' + euro.toStringAsFixed(2),
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    6.0, 0.0, 4.0, 0.0),
                                child: Text('₿',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4.0)),
                              Text(
                                'Bitcoin',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4.0)),
                              Text(
                                'R\$ ' + dollar.toStringAsFixed(2),
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Calculadora de conversão:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        buildTextField(
                            "Reais", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dólares", "US\$", dollarController,
                            _dollarChanged),
                        Divider(),
                        buildTextField(
                            "Euros", "€", euroController, _euroChanged),
                        Divider(),
                      ],
                    ),
                  );
                }
            }
          }),
      ),
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)))),
      debugShowCheckedModeBanner: false,
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(),
      hoverColor: Colors.purple,
      prefixText: prefix + " ",
      prefixStyle: TextStyle(color: Colors.black, fontSize: 18.0),
    ),
    style: TextStyle(color: Colors.black, fontSize: 18.0),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
