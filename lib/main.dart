import 'package:currency_info/pages/about.dart';
import 'package:currency_info/pages/calculator.dart';
import 'package:currency_info/pages/stock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:launch_review/launch_review.dart';

const request = "https://api.hgbrasil.com/finance?format=json&key=1bef1c18";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)))),
    debugShowCheckedModeBanner: false,
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  double dollar;
  double euro;
  double bitcoin;

  String symbol = "MGLU3";
  var symbols = [
    'ALZR11',
    'ABEV3',
    'ARZZ3',
    'AZUL4',
    'BTOW3',
    'B3SA3',
    'BBDC3',
    'BBDC4',
    'BBAS3',
    'BIDI4',
    'SANB3',
    'SANB11',
    'BBSE3',
    'BRML3',
    'BRAP4',
    'BRAP3',
    'BRKM5',
    'BRFS3',
    'CCRO3',
    'ELET3',
    'ELET6',
    'HGTX3',
    'CIEL3',
    'COGN3',
    'PCAR4',
    'SBSP3',
    'CMIG3',
    'CMIG4',
    'CPLE6',
    'CPLE3',
    'CSNA3',
    'CSAN3',
    'CPFE3',
    'HGLG11',
    'CVCB3',
    'CYRE3',
    'ECOR3',
    'ENBR3',
    'EMBR3',
    'EGIE3',
    'EQTL3',
    'YDUQ3',
    'HTMX11',
    'FLRY3',
    'GGBR3',
    'GGBR4',
    'GOLL4',
    'HYPE3',
    'IGTA3',
    'IRBR3',
    'ITUB4',
    'ITSA4',
    'JBSS3',
    'KLBN11',
    'RENT3',
    'LAME4',
    'LREN3',
    'MGLU3',
    'MRFG3',
    'GOAU4',
    'MRVE3',
    'MULT3',
    'NTCO3',
    'NATU3',
    'OIBR3',
    'BRDT3',
    'PETR4',
    'PETR3',
    'QUAL3',
    'RADL3',
    'RAIL3',
    'SQIA3',
    'SMLS3',
    'SUZB3',
    'TASA4',
    'VIVT4',
    'TIMP3',
    'TAEE11',
    'UGPA3',
    'USIM5',
    'VALE3',
    'VVAR3',
    'WEGE3',
    'WIZS3'
  ];

  var _selectedItem = 'MGLU3';

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
      adUnitId: "ca-app-pub-8682283257399936/7918334881",
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
      body: FabCircularMenu(
        ringWidth: 60.0,
        
        fabColor: Colors.blueAccent[300],
        fabOpenColor: Color(0xff18043b),
        fabOpenIcon: Icon(Icons.menu),
        fabCloseIcon: Icon(Icons.close),
        ringColor: Colors.white70,
        options: <Widget>[
          IconButton(
              icon: Icon(Icons.star_border),
              onPressed: () {
                LaunchReview.launch();
              },
              iconSize: 48.0,
              color: Color(0xff18043b)),
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => About()),
                );
              },
              iconSize: 48.0,
              color: Color(0xff18043b)),
              IconButton(
              icon: Icon(Icons.cached),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Calculator(dollar: dollar, euro: euro,)),
                );
              },
              iconSize: 48.0,
              color: Color(0xff18043b)),
        ],
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF282a57), Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: FutureBuilder<Map>(
              future: getData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Text(
                        "Carregando...",
                        style:
                            TextStyle(color: Colors.lightBlue, fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Erro ao carregar dados...",
                          style: TextStyle(
                              color: Colors.lightBlue, fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      dollar =
                          snapshot.data["results"]["currencies"]["USD"]["buy"];
                      euro =
                          snapshot.data["results"]["currencies"]["EUR"]["buy"];
                      bitcoin = snapshot.data["results"]["bitcoin"]
                          ["mercadobitcoin"]["last"];
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Principais cotações do dia:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              color: Colors.lightBlue,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 10.0, 20.0, 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'images/coin.png',
                                          scale: 10.0,
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.0)),
                                        Text(
                                          'Dollar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.0)),
                                        Text(
                                          'R\$ ' + dollar.toStringAsFixed(2),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 10.0, 20.0, 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'images/euro.png',
                                          scale: 10.0,
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.0)),
                                        Text(
                                          'Euro',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.0)),
                                        Text(
                                          'R\$ ' + euro.toStringAsFixed(2),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.lightBlue,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 20.0, 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'images/bitcoin.png',
                                    scale: 10.0,
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 4.0)),
                                  Text(
                                    'Bitcoin (Mercado Bitcoin)',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 4.0)),
                                  Text(
                                    'R\$ ' + bitcoin.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 18.0),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.lightBlue,
                            ),
                            buildDropdown(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CupertinoButton(
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Stock(
                                                stock: symbol,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'Consultar',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                      );
                    }
                }
              }),
        ),
      ),
    );
  }

  buildDropdown() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ver mercado de ações:',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            'Escolha uma empresa para consulta',
            style: TextStyle(color: Colors.white),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.black87,
            ),
            child: DropdownButton<String>(
                items: symbols.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(
                      'Símbolo: $dropDownStringItem',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String newItemSelected) {
                  _dropDownItemSelected(newItemSelected);
                  setState(() {
                    this._selectedItem = newItemSelected;
                    symbol = newItemSelected;
                  });
                },
                value: _selectedItem),
          ),
        ],
      ),
    );
  }

  void _dropDownItemSelected(String newItem) {
    setState(() {
      this._selectedItem = newItem;
      symbol = newItem;
    });
  }
}
