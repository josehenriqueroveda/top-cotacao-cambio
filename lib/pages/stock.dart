import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';

const stockRequest =
    "https://api.hgbrasil.com/finance/stock_price?key=1bef1c18&symbol=";

Future<Map> getStock(String symbol) async {
  http.Response response = await http.get('$stockRequest$symbol');
  return json.decode(response.body);
}

class Stock extends StatefulWidget {
  final String stock;

  Stock({this.stock});

  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  String stockName;
  double price;
  double variation;

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'dinheiro',
      'economia',
      'viagens',
      'viajar',
      'bitcoin',
      'renda',
      'finanças',
      'investimento',
      'tesouro direto',
      'corretora',
      'dollar',
      'euro',
      'cotação',
      'comprar',
      'vender',
      'bolsa de valores',
      'bovespa',
      'ações'
    ],
    childDirected: false,
    testDevices: <String>[],
  );

  BannerAd myBanner;

  int clicks = 0;
  void startBanner() {
    myBanner = BannerAd(
      adUnitId: "ca-app-pub-8682283257399936/9532395342",
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  void displayBanner() {
    myBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        anchorType: AnchorType.bottom,
      );
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-8682283257399936~3851382770");

    startBanner();
    displayBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cotação Fácil"),
        backgroundColor: Color(0xff18043b),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF282a57), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: FutureBuilder<Map>(
            future: getStock(widget.stock),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      "Carregando...",
                      style: TextStyle(color: Colors.lightBlue, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao carregar dados...",
                        style: TextStyle(color: Colors.lightBlue, fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    stockName =
                        snapshot.data["results"]["${widget.stock}"]["name"];
                    price = snapshot.data["results"]["${widget.stock}"]["price"];
                    variation = snapshot.data["results"]["${widget.stock}"]
                        ["change_percent"];
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Image.asset(
                              'images/profit.png',
                              scale: 5,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 30.0),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: LinearGradient(
                                    colors: [Color(0xff18043b), Colors.black54],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '$stockName',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 12.0, 12.0, 30.0),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'R\$ ',
                                        style: TextStyle(fontSize: 18.0, color: Colors.green),
                                      ),
                                      Text(
                                        price.toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 30.0, 12.0, 30.0),
                                    child: Container(
                                      width: 120.0,
                                      decoration: BoxDecoration(
                                        color: variation < 0
                                            ? Colors.red
                                            : Colors.green,
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: variation < 0
                                                  ? Icon(Icons.arrow_downward,
                                                      color: Colors.white)
                                                  : Icon(Icons.arrow_upward,
                                                      color: Colors.white)),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              '$variation %',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              }
            }),
      ),
    );
  }
}
