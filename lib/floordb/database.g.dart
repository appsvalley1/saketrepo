// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

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

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

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
        ? join(await sqflite.getDatabasesPath(), name)
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
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ShippingAddressDao _shippingAddressDaoInstance;

  CartModelDao _cartModelDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ShippingAddress` (`id` INTEGER, `HouseNumber` TEXT, `SocietyName` TEXT, `FullAddress` TEXT, `PinCode` TEXT, `AddressTag` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CartModel` (`ProductID` INTEGER, `ProductName` TEXT, `Amount` INTEGER, PRIMARY KEY (`ProductID`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  ShippingAddressDao get shippingAddressDao {
    return _shippingAddressDaoInstance ??=
        _$ShippingAddressDao(database, changeListener);
  }

  @override
  CartModelDao get cartModelDao {
    return _cartModelDaoInstance ??= _$CartModelDao(database, changeListener);
  }
}

class _$ShippingAddressDao extends ShippingAddressDao {
  _$ShippingAddressDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _shippingAddressInsertionAdapter = InsertionAdapter(
            database,
            'ShippingAddress',
            (ShippingAddress item) => <String, dynamic>{
                  'id': item.id,
                  'HouseNumber': item.HouseNumber,
                  'SocietyName': item.SocietyName,
                  'FullAddress': item.FullAddress,
                  'PinCode': item.PinCode,
                  'AddressTag': item.AddressTag
                }),
        _shippingAddressDeletionAdapter = DeletionAdapter(
            database,
            'ShippingAddress',
            ['id'],
            (ShippingAddress item) => <String, dynamic>{
                  'id': item.id,
                  'HouseNumber': item.HouseNumber,
                  'SocietyName': item.SocietyName,
                  'FullAddress': item.FullAddress,
                  'PinCode': item.PinCode,
                  'AddressTag': item.AddressTag
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _shippingAddressMapper = (Map<String, dynamic> row) =>
      ShippingAddress(
          row['id'] as int,
          row['HouseNumber'] as String,
          row['SocietyName'] as String,
          row['FullAddress'] as String,
          row['PinCode'] as String,
          row['AddressTag'] as String);

  final InsertionAdapter<ShippingAddress> _shippingAddressInsertionAdapter;

  final DeletionAdapter<ShippingAddress> _shippingAddressDeletionAdapter;

  @override
  Future<List<ShippingAddress>> findAllShippingAddress() async {
    return _queryAdapter.queryList('SELECT * FROM ShippingAddress',
        mapper: _shippingAddressMapper);
  }

  @override
  Future<ShippingAddress> findShippingAddressId(int id) async {
    return _queryAdapter.query('SELECT * FROM ShippingAddress WHERE id = ?',
        arguments: <dynamic>[id], mapper: _shippingAddressMapper);
  }

  @override
  Future<void> insertShippingAddress(ShippingAddress shippingAddress) async {
    await _shippingAddressInsertionAdapter.insert(
        shippingAddress, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<int> deleteShippingAddress(List<ShippingAddress> person) {
    return _shippingAddressDeletionAdapter
        .deleteListAndReturnChangedRows(person);
  }
}

class _$CartModelDao extends CartModelDao {
  _$CartModelDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _cartModelInsertionAdapter = InsertionAdapter(
            database,
            'CartModel',
            (CartModel item) => <String, dynamic>{
                  'ProductID': item.ProductID,
                  'ProductName': item.ProductName,
                  'Amount': item.Amount
                }),
        _cartModelDeletionAdapter = DeletionAdapter(
            database,
            'CartModel',
            ['ProductID'],
            (CartModel item) => <String, dynamic>{
                  'ProductID': item.ProductID,
                  'ProductName': item.ProductName,
                  'Amount': item.Amount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _cartModelMapper = (Map<String, dynamic> row) => CartModel(
      row['ProductID'] as int,
      row['ProductName'] as String,
      row['Amount'] as int);

  final InsertionAdapter<CartModel> _cartModelInsertionAdapter;

  final DeletionAdapter<CartModel> _cartModelDeletionAdapter;

  @override
  Future<List<CartModel>> findAllCartModel() async {
    return _queryAdapter.queryList('SELECT * FROM CartModel',
        mapper: _cartModelMapper);
  }

  @override
  Future<CartModel> findCartModelId(int id) async {
    return _queryAdapter.query('SELECT * FROM CartModel WHERE id = ?',
        arguments: <dynamic>[id], mapper: _cartModelMapper);
  }

  @override
  Future<void> deleteAllCartModel() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CartModel');
  }

  @override
  Future<void> insertCartModel(CartModel cartModel) async {
    await _cartModelInsertionAdapter.insert(
        cartModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<int> deleteCartModel(CartModel person) {
    return _cartModelDeletionAdapter.deleteAndReturnChangedRows(person);
  }
}
