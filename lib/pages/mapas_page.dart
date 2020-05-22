import 'package:flutter/material.dart';
import 'package:qrscan/bloc/scan_bloc.dart';
import 'package:qrscan/models/scan_model.dart';

class MapasPage extends StatelessWidget {
  final _scanBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanModel>>(
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshop) {
        if (!snapshop.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final scan = snapshop.data;

        if (scan.length == 0) {
          return Center(
            child: Text('No hay informacion para mostrar'),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (direction) => _scanBloc.borrarScan(scan[i].id),
              child: ListTile(
                leading: Icon(Icons.cloud_queue,
                    color: Theme.of(context).primaryColor),
                title: Text(scan[i].valor),
                subtitle: Text('ID: ${scan[i].id}'),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.grey,
                ),
              ),
            ),
            itemCount: scan.length,
          );
        }
      },
      stream: _scanBloc.scansStream,
    );
  }
}
