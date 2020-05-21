import 'package:flutter/material.dart';
import 'package:qrscan/pages/direcciones_page.dart';
import 'package:qrscan/pages/mapas_page.dart';
import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scanner'), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.delete_forever,
            color: Colors.red,
            size: 30,
          ),
          onPressed: () {},
        ),
      ]),
      body: _callPage(_currentPage),
      bottomNavigationBar: _btnNavigation(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          onPressed: _scanQR,
          backgroundColor: Theme.of(context).primaryColor),
    );
  }

  Future _scanQR() async {
    dynamic futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    print('future string : $futureString');

    if (futureString != null) {
      print('tenemos informacion');
    }
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  Widget _btnNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Mapas')),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), title: Text('Direccion'))
      ],
    );
  }
}
