import 'dart:async';

import 'package:qrscan/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    //obtener los scan de la base de datos
    obtenerScacns();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  dispose() {
    _scansController?.close();
  }

  obtenerScacns() async {
    _scansController.sink.add(await DBProvider.db.getAllScan());
  }

  agregarScans(ScanModel scan) async {
    await DBProvider.db.nuevoSacn(scan);
    obtenerScacns();
  }

  borrarScan(int id) async {
    await DBProvider.db.delteScan(id);
    obtenerScacns();
  }

  borrarAllScan() async {
    await DBProvider.db.delteAllScan();
    obtenerScacns();
  }
}
