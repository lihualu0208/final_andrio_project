// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SalesDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $SalesDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $SalesDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $SalesDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<SalesDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorSalesDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $SalesDatabaseBuilderContract databaseBuilder(String name) =>
      _$SalesDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $SalesDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$SalesDatabaseBuilder(null);
}

class _$SalesDatabaseBuilder implements $SalesDatabaseBuilderContract {
  _$SalesDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $SalesDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $SalesDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<SalesDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$SalesDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$SalesDatabase extends SalesDatabase {
  _$SalesDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SalesRecordsDAO? _getDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `SalesRecords` (`recordID` INTEGER NOT NULL, `title` TEXT NOT NULL, `custID` INTEGER NOT NULL, `carID` INTEGER NOT NULL, `dealerID` INTEGER NOT NULL, `date` TEXT NOT NULL, PRIMARY KEY (`recordID`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SalesRecordsDAO get getDAO {
    return _getDAOInstance ??= _$SalesRecordsDAO(database, changeListener);
  }
}

class _$SalesRecordsDAO extends SalesRecordsDAO {
  _$SalesRecordsDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _salesRecordsInsertionAdapter = InsertionAdapter(
            database,
            'SalesRecords',
            (SalesRecords item) => <String, Object?>{
                  'recordID': item.recordID,
                  'title': item.title,
                  'custID': item.custID,
                  'carID': item.carID,
                  'dealerID': item.dealerID,
                  'date': item.date
                }),
        _salesRecordsUpdateAdapter = UpdateAdapter(
            database,
            'SalesRecords',
            ['recordID'],
            (SalesRecords item) => <String, Object?>{
                  'recordID': item.recordID,
                  'title': item.title,
                  'custID': item.custID,
                  'carID': item.carID,
                  'dealerID': item.dealerID,
                  'date': item.date
                }),
        _salesRecordsDeletionAdapter = DeletionAdapter(
            database,
            'SalesRecords',
            ['recordID'],
            (SalesRecords item) => <String, Object?>{
                  'recordID': item.recordID,
                  'title': item.title,
                  'custID': item.custID,
                  'carID': item.carID,
                  'dealerID': item.dealerID,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SalesRecords> _salesRecordsInsertionAdapter;

  final UpdateAdapter<SalesRecords> _salesRecordsUpdateAdapter;

  final DeletionAdapter<SalesRecords> _salesRecordsDeletionAdapter;

  @override
  Future<List<SalesRecords>> getRecords() async {
    return _queryAdapter.queryList('Select * from SalesRecords',
        mapper: (Map<String, Object?> row) => SalesRecords(
            row['recordID'] as int,
            row['title'] as String,
            row['custID'] as int,
            row['carID'] as int,
            row['dealerID'] as int,
            row['date'] as String));
  }

  @override
  Future<void> addSalesRecord(SalesRecords record) async {
    await _salesRecordsInsertionAdapter.insert(
        record, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSalesRecord(SalesRecords record) async {
    await _salesRecordsUpdateAdapter.update(record, OnConflictStrategy.abort);
  }

  @override
  Future<void> removeSalesRecord(SalesRecords record) async {
    await _salesRecordsDeletionAdapter.delete(record);
  }
}
