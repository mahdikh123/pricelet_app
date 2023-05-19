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
        body: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/items.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price Of Item ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _numberFormat.format(_result),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(Icons.qr_code, color: Colors.grey[600]),
                              const SizedBox(width: 10),
                              Text(
                                'Scanned Barcode',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            _barcode,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: _scanBarcode,
                                child: Text('Scan Barcode'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
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
