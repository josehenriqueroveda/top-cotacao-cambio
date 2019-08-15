import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=1bef1c18";

void main() async {

  runApp(MaterialApp(
    home: Home(),
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
          )
      )
  ));
}

Future<Map> getData() async{
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

  void _clearAll(){
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Currency converter \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Loading...",
                    style: TextStyle(color: Colors.amber,
                    fontSize: 25.0),
                  textAlign: TextAlign.center,),
                );
              default:
                if(snapshot.hasError){
                  return Center(
                    child: Text("Error on loading data...",
                      style: TextStyle(color: Colors.amber,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,),
                  );
                } else{
                  dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  bitcoin = snapshot.data["results"]["bitcoin"]["mercadobitcoin"]["last"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                        buildTextField("Reais", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dollars", "US\$", dollarController, _dollarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroController, _euroChanged),
                        Divider(),
                        Text("₿ Bitcoin (Mercado Bitcoin)",
                          style: TextStyle(color: Colors.white, fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Divider(),
                        Text("R\$ " + bitcoin.toStringAsFixed(2),
                          style: TextStyle(color: Colors.white, fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix + " ", prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
