import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tandhjuls beregner',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Tandhjuls beregner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // individuelle tal
  final List<double> _modulM = [0.0, 0.0];
  final List<double> _delingT = [0.0, 0.0];
  final List<double> _tandantalZ = [0.0, 0.0];
  final List<double> _udvDiameterDt = [0.0, 0.0];
  final List<double> _delecirkelDiameterDo = [0.0, 0.0];
  final List<double> _bundDiameterDb = [0.0, 0.0];
  final List<double> _tandhojdeH = [0.0, 0.0];
  final List<double> _tandfodHf = [0.0, 0.0];
  final List<double> _tandbreddeB = [0.0, 0.0];
  final List<double> _kontrolMaal = [0.0, 0.0];

  // sammenligen tal
  double _akselAfstandCc = 0.0;
  final modulMControllerHjul1 = TextEditingController();
  final tandantalZControllerHjul1 = TextEditingController();
  final modulMControllerHjul2 = TextEditingController();
  final tandantalZControllerHjul2 = TextEditingController();

  showAlertDialog(/*BuildContext context*/ String errorM) {

    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: Text(errorM),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },

    );
  }

  void _calculate() {
    setState(() {
      if (modulMControllerHjul1.text != "" && tandantalZControllerHjul1.text != "") {
        List cjek = modulMControllerHjul1.text.split('.');
        List cjek2 = tandantalZControllerHjul1.text.split('.');

        cjek.length < 2 ? _modulM[0] = double.parse(modulMControllerHjul1.text) : showAlertDialog("Du har et punktum for meget i: \nmodul m 1");

        cjek2.length < 2 ? _tandantalZ[0] = double.parse(tandantalZControllerHjul1.text) : showAlertDialog("Du har et punktum for meget i: \ntandantal z 1");
      }
      else{
        _modulM[0] = 0.0;
        _tandantalZ[0] = 0.0;
      }

      if(modulMControllerHjul2.text != "" && tandantalZControllerHjul2.text != "") {
        List cjek = modulMControllerHjul2.text.split('.');
        List cjek2 = tandantalZControllerHjul2.text.split('.');

        cjek.length < 2 ? _modulM[1] = double.parse(modulMControllerHjul2.text) : showAlertDialog("Du har et punktum for meget i: \nmodul m 2");

        cjek2.length < 2 ? _tandantalZ[1] = double.parse(tandantalZControllerHjul2.text) : showAlertDialog("Du har et punktum for meget i: \ntandantal z 2");
      }
      else{
        _modulM[1] = 0.0;
        _tandantalZ[1] = 0.0;
      }

      for (int i = 0; i < 2; i++) {
        _delingT[i] = double.parse((pi * _modulM[i]).toStringAsFixed(3));
        _udvDiameterDt[i] = double.parse((_modulM[i] * (_tandantalZ[i] + 2)).toStringAsFixed(3));
        _delecirkelDiameterDo[i] = double.parse((_modulM[i] * _tandantalZ[i]).toStringAsFixed(3));
        _bundDiameterDb[i] = double.parse((_delecirkelDiameterDo[i] - _tandfodHf[i] - _tandfodHf[i]).toStringAsFixed(3));
        _tandhojdeH[i] = double.parse((_modulM[i] * 2.166).toStringAsFixed(3));
        _tandfodHf[i] = double.parse((_modulM[i] * 1.166).toStringAsFixed(3));
        _tandbreddeB[i] = 10 * _modulM[i];
        _kontrolMaal[i] = double.parse((
            _modulM[i] * cos(20 * pi / 180) * ((4 - 0.5) * pi + _tandantalZ[i] * (tan(20 * pi / 180) - (20 * pi / 180)))
                ).toStringAsFixed(3));
      }
      _akselAfstandCc = (_delecirkelDiameterDo[0] + _delecirkelDiameterDo[1]) / 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          const Text('\nTandhjul 1', style: TextStyle(fontSize: 24)),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          labelText: 'Modul m',
                          labelStyle: TextStyle(
                          color: Colors.green,
                          fontSize: 19,
                          )
                      ),
                    controller: modulMControllerHjul1,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          labelText: 'Tandantal z',
                          labelStyle: TextStyle(
                            color: Colors.green,
                            fontSize: 19,
                          )
                      ),
                      controller: tandantalZControllerHjul1,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ),
              ],
            ),
            const Text('\nTandhjul 2', style: TextStyle(fontSize: 24)),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          labelText: 'Modul m',
                          labelStyle: TextStyle(
                            color: Colors.green,
                            fontSize: 19,
                          )
                      ),
                      controller: modulMControllerHjul2,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          labelText: 'Tandantal z',
                          labelStyle: TextStyle(
                            color: Colors.green,
                            fontSize: 19,
                          )
                      ),
                      controller: tandantalZControllerHjul2,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ),
              ],
            ),

            const Text('\nModul m'),
            Row(
              children: [
                Expanded(
                    child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_modulM[0].toString()),
                ),
                ),
                 Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_modulM[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nDeling t'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_delingT[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_delingT[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nTandantal z'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_tandantalZ[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_tandantalZ[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nUdv. Diameter Dt'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_udvDiameterDt[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_udvDiameterDt[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nDelecirkel diameter Do'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_delecirkelDiameterDo[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_delecirkelDiameterDo[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nBund diameter Db'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_bundDiameterDb[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_bundDiameterDb[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nTandhøjde h'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_tandhojdeH[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_tandhojdeH[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nTandhovedhøjde hh'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_modulM[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_modulM[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nTandfod hf'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_tandfodHf[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_tandfodHf[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nTandbredde b'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_tandbreddeB[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_tandbreddeB[1].toString()),
                    )
                ),
              ],
            ),
            const Text('\nAkselafstand c-c'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_akselAfstandCc.toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_akselAfstandCc.toString()),
                    )
                ),
              ],
            ),
            const Text('\nIndgrebsvinkel'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(20.toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(20.toString()),
                    )
                ),
              ],
            ),
            const Text('\nKontrolmål antal z'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(4.toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(4.toString()),
                    )
                ),
              ],
            ),
            const Text('\nKontrolmål'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                    child: Text(_kontrolMaal[0].toString()),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 20, 0),
                      child: Text(_kontrolMaal[1].toString()),
                    )
                ),
              ],
            ),

            Text('''\n
            Aksel diameter: 15\n
            Modul : ''' + _modulM[0].toString() + '''\n
            Deling afstand i mellem tænder: ''' + _delingT[0].toString() + '''\n
            Tandhøjde - Fræse dybde: ''' + _tandhojdeH[0].toString() + '''\n
            Center-center afstand: ''' + ((_delecirkelDiameterDo[0] / 2) + (7.5) - _modulM[0]).toStringAsFixed(2) + '''\n
            Kontrolmål fra bund af tand:''' + (15 - _tandhojdeH[0]).toStringAsFixed(3) + '\n',
              style: const TextStyle(fontSize: 17),

            ),
          ],
        ),
      ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _calculate,
              child: const Icon(Icons.done),
            ),
          ],
        ),
      ),
    );
  }
}
