import 'package:floor/floor.dart';
import 'package:pricelet_app/dao/item_dao.dart';
import 'package:pricelet_app/dao/rate_dao.dart';
import 'package:pricelet_app/entity/item_entity.dart';
import 'package:pricelet_app/entity/rate_entity.dart';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'package:floor/floor.dart';
import 'dart:async';

part 'database.g.dart';

@Database(version: 2, entities: [Item,Rate])
abstract class AppDatabase extends FloorDatabase {
  ItemDao get itemDao;
  RateDAO get rateDao;
}
