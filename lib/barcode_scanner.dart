import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:pricelet_app/database/database.dart';

class BarcodeScannerWidget extends StatefulWidget {
  @override
  _BarcodeScannerWidgetState createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  String _barcode = '';
  double _itemPrice = 0;
  double _rate = 0;
  double _result = 0;
  NumberFormat _numberFormat = NumberFormat("#,##0.00", "en_US");
  @override
  void initState() {
    _findTheRate();
  }

  Future<void> _scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color of the scanner line
      'Cancel', // Text for the cancel button
      true, // Use the flash if available
      ScanMode.BARCODE, // Scan mode (Barcode, QRCode, or both)
    );

    setState(() {
      _barcode = barcode;
    });

    _searchItem();
   
  }

  Future<void> _searchItem() async {
    final database = $FloorAppDatabase.databaseBuilder('pricelet.db').build();
    database.then((value) {
      value.itemDao.findItemByBarcode(_barcode).then((val) {
        if (val != null) {
          _itemPrice = val.price;
           _calculatePrice();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _scanBarcode,
              child: Text('Scan Barcode'),
            ),
            SizedBox(height: 16),
            Text('Scanned Barcode: $_barcode'),
            SizedBox(height: 16),
            Text('Price Of Item: ${_numberFormat.format(_result)}'),
          ],
        ),
      ),
    );
  }

  void _calculatePrice() {
    setState(() {
      _result = _itemPrice * _rate;
    });
  }

  _findTheRate() {
    final database = $FloorAppDatabase.databaseBuilder('pricelet.db').build();
    database.then((value) {
      value.rateDao.findRateById(1).then((val) {
        if (val != null) {
          _rate = val.rate;
        }
      });
    });
  }
}
