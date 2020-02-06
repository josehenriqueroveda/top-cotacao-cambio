import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';

const request = "https://api.hgbrasil.com/finance?format=json&key=1bef1c18";

class Calculator extends StatefulWidget {
  final double dollar;
  final double euro;

  Calculator({this.dollar, this.euro});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  double dollar;
  double euro;

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
      adUnitId: "ca-app-pub-8682283257399936/7110601353",
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
    dollar = widget.dollar;
    euro = widget.euro;
    startBanner();
    displayBanner();
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
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'images/maths.png',
                  scale: 5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Calculadora de conversão:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              buildTextField("Reais", "R\$", realController, _realChanged),
              Divider(
                color: Colors.lightBlue,
              ),
              buildTextField(
                  "Dólares", "US\$", dollarController, _dollarChanged),
              Divider(
                color: Colors.lightBlue,
              ),
              buildTextField("Euros", "€", euroController, _euroChanged),
              Divider(
                color: Colors.lightBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(),
      hoverColor: Colors.lightBlue,
      prefixText: prefix + " ",
      prefixStyle: TextStyle(color: Colors.white, fontSize: 18.0),
    ),
    style: TextStyle(color: Colors.white, fontSize: 18.0),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
