import 'dart:ffi';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:pricelet_app/database/database.dart';
import 'package:pricelet_app/entity/item_entity.dart';
import 'package:intl/intl.dart';

class AddItem extends StatefulWidget {
  AddItem({super.key, this.id, this.name, this.barcode, this.price});

  final int? id;
  final String? name;
  final String? barcode;
  final String? price;

  final _itemNameController = TextEditingController();
  final _serialNoController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  bool idIsNull = true;

  @override
  void initState() {
    if (widget.id != null) {
      widget._itemNameController.text = widget.name!;
      widget._serialNoController.text = widget.barcode!;
      widget._priceController.text = widget.price ?? '';
      idIsNull = false;
    }
  }

/*
  @override
  void dispose() {
    widget._itemNameController.dispose();
    widget._itemNameController.dispose();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(idIsNull ? 'Add New Item' : 'Update Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: widget._itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
              ),
            ),
            TextFormField(
              controller: widget._serialNoController,
              decoration: InputDecoration(
                labelText: 'BarCode',
              ),
            ),
            TextFormField(
              controller: widget._priceController,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                // Handle form submission
                if (idIsNull)
                  _save();
                else
                  _saveEdit();
              },
            ),
          ],
        ),
      ),
    );
  }

  _save() {
    final database = $FloorAppDatabase.databaseBuilder('pricelet.db').build();
    database.then((value) {
      value.itemDao.findMaxId().then((val) {
        int id = 1;
        if (val != null) {
          id = val.id + 1;
        }

        value.itemDao.insertItem(Item(
            id,
            widget._itemNameController.value.text,
            widget._serialNoController.value.text,
            DateFormat('MMMM dd, yyyy').format(DateTime.now()),
            double.parse(widget._priceController.value.text)));
      });
    });
    Navigator.pop(context);
  }

  _saveEdit() {
    final database = $FloorAppDatabase.databaseBuilder('pricelet.db').build();
    database.then((value) {
      value.itemDao.updateItem(Item(
          widget.id!,
          widget._itemNameController.value.text,
          widget._serialNoController.value.text,
          DateFormat('MMMM dd, yyyy').format(DateTime.now()),
          double.parse(widget._priceController.value.text)));
    });

    Navigator.pop(context);
  }
}
