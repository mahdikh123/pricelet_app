import 'package:flutter/material.dart';
import 'package:pricelet_app/custom_drawer.dart';
import 'package:pricelet_app/database/database.dart';
import 'package:pricelet_app/entity/item_entity.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ShoppingCard extends StatefulWidget {
  const ShoppingCard({super.key});

  @override
  State<ShoppingCard> createState() => _ShoppingCardState();
}

class _ShoppingCardState extends State<ShoppingCard> {
  List<Item> items = [];
  double _rate = 0;
  double _total = 0;
  @override
  void initState() {
    _findTheRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Shopping cart'),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Text('Total price: ${_total.toStringAsFixed(2)} L.L'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    items.clear();
                  });
                },
                child: Text('Clear'),
              ),
              ElevatedButton(
                onPressed: () {
                  _scanBarcode();
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle:
                      Text('${(item.price * _rate).toStringAsFixed(2)} L.L'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        items.removeAt(index);
                        _total = _calculateTotalPrice();
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color of the scanner line
      'Cancel', // Text for the cancel button
      true, // Use the flash if available
      ScanMode.BARCODE, // Scan mode (Barcode, QRCode, or both)
    );

    final database = $FloorAppDatabase.databaseBuilder('pricelet.db').build();
    database.then((value) {
      value.itemDao.findItemByBarcode(barcode).then((val) {
        if (val != null) {
          setState(() {
            items.add(val);
            _total = _calculateTotalPrice();
          });
        }
      });
    });
  }

  _findTheRate() {
    final database = $FloorAppDatabase.databaseBuilder('pricelet.db').build();
    database.then((value) {
      value.rateDao.findRateById(1).then((val) {
        if (val != null) {
          setState(() {
            _rate = val.rate;
          });
        }
      });
    });
  }

  double _calculateTotalPrice() {
    double total = items.fold(0, (sum, item) => sum + item.price);
    return total * _rate;
  }
}
