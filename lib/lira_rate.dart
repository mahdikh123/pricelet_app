import 'package:flutter/material.dart';
import 'package:pricelet_app/database/database.dart';
import 'package:pricelet_app/entity/rate_entity.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final _rateController = TextEditingController();

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  bool idIsNull = true;

  @override
  void initState() {
    _findTheRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lira Rate'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: widget._rateController,
              decoration: const InputDecoration(
                labelText: 'Item Price',
              ),
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                _save();
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text("Done"),
                          content: const Text("you have Saved"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Container(
                                color: Colors.blue,
                                padding: const EdgeInsets.all(14),
                                child: const Text("okey",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }

  _findTheRate() {
    final database = $FloorAppDatabase.databaseBuilder('pricelet.db').build();
    database.then((value) {
      value.rateDao.findRateById(1).then((val) {
        if (val != null) {
          widget._rateController.text = val.rate.toString();
        }
      });
    });
  }

  _save() {
    final database = $FloorAppDatabase.databaseBuilder('pricelet.db').build();
    database.then((value) {
      value.rateDao.findRateById(1).then((val) {
        if (val != null) {
          value.rateDao.updateRate(
              Rate(double.parse(widget._rateController.value.text)));
        } else {
          value.rateDao.insertRate(
              Rate(double.parse(widget._rateController.value.text)));
        }
      });
    });
  }
}
