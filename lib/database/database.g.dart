// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ItemDao? _itemDaoInstance;

  RateDAO? _rateDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `items` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `name` TEXT NOT NULL, `barcode` TEXT NOT NULL, `price` REAL NOT NULL, `scheduleTime` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `rate` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `rate` REAL NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ItemDao get itemDao {
    return _itemDaoInstance ??= _$ItemDao(database, changeListener);
  }

  @override
  RateDAO get rateDao {
    return _rateDaoInstance ??= _$RateDAO(database, changeListener);
  }
}

class _$ItemDao extends ItemDao {
  _$ItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _itemInsertionAdapter = InsertionAdapter(
            database,
            'items',
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'barcode': item.barcode,
                  'price': item.price,
                  'scheduleTime': item.scheduleTime
                },
            changeListener),
        _itemUpdateAdapter = UpdateAdapter(
            database,
            'items',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'barcode': item.barcode,
                  'price': item.price,
                  'scheduleTime': item.scheduleTime
                },
            changeListener),
        _itemDeletionAdapter = DeletionAdapter(
            database,
            'items',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'barcode': item.barcode,
                  'price': item.price,
                  'scheduleTime': item.scheduleTime
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Item> _itemInsertionAdapter;

  final UpdateAdapter<Item> _itemUpdateAdapter;

  final DeletionAdapter<Item> _itemDeletionAdapter;

  @override
  Future<List<Item>> findAllItems() async {
    return _queryAdapter.queryList('select * from items',
        mapper: (Map<String, Object?> row) => Item(
            row['id'] as int,
            row['name'] as String,
            row['barcode'] as String,
            row['scheduleTime'] as String,
            row['price'] as double));
  }

  @override
  Future<Item?> findMaxId() async {
    return _queryAdapter.query('select * from items order by id desc limit 1',
        mapper: (Map<String, Object?> row) => Item(
            row['id'] as int,
            row['name'] as String,
            row['barcode'] as String,
            row['scheduleTime'] as String,
            row['price'] as double));
  }

  @override
  Stream<List<Item>> streamedData() {
    return _queryAdapter.queryListStream('select * from items order by id desc',
        mapper: (Map<String, Object?> row) => Item(
            row['id'] as int,
            row['name'] as String,
            row['barcode'] as String,
            row['scheduleTime'] as String,
            row['price'] as double),
        queryableName: 'items',
        isView: false);
  }

  @override
  Future<Item?> findItemByBarcode(String barcode) async {
    return _queryAdapter.query('select * from items where barcode= ?1',
        mapper: (Map<String, Object?> row) => Item(
            row['id'] as int,
            row['name'] as String,
            row['barcode'] as String,
            row['scheduleTime'] as String,
            row['price'] as double),
        arguments: [barcode]);
  }

  @override
  Future<void> deleteById(int id) async {
    await _queryAdapter
        .queryNoReturn('delete from items where id= ?1', arguments: [id]);
  }

  @override
  Future<void> insertItem(Item item) async {
    await _itemInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Item item) async {
    await _itemUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAll(List<Item> list) {
    return _itemDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}

class _$RateDAO extends RateDAO {
  _$RateDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _rateInsertionAdapter = InsertionAdapter(database, 'rate',
            (Rate item) => <String, Object?>{'id': item.id, 'rate': item.rate}),
        _rateUpdateAdapter = UpdateAdapter(database, 'rate', ['id'],
            (Rate item) => <String, Object?>{'id': item.id, 'rate': item.rate});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Rate> _rateInsertionAdapter;

  final UpdateAdapter<Rate> _rateUpdateAdapter;

  @override
  Future<Rate?> findRateById(int id) async {
    return _queryAdapter.query('select * from rate where id= ?1 limit 1',
        mapper: (Map<String, Object?> row) => Rate(row['rate'] as double),
        arguments: [id]);
  }

  @override
  Future<void> insertRate(Rate rate) async {
    await _rateInsertionAdapter.insert(rate, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRate(Rate rate) async {
    await _rateUpdateAdapter.update(rate, OnConflictStrategy.abort);
  }
}
