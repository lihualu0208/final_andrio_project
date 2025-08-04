// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dealership_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $DealershipDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $DealershipDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $DealershipDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<DealershipDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorDealershipDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $DealershipDatabaseBuilderContract databaseBuilder(String name) =>
      _$DealershipDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $DealershipDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$DealershipDatabaseBuilder(null);
}

class _$DealershipDatabaseBuilder
    implements $DealershipDatabaseBuilderContract {
  _$DealershipDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $DealershipDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $DealershipDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<DealershipDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$DealershipDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$DealershipDatabase extends DealershipDatabase {
  _$DealershipDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DealershipDao? _dealershipDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `dealerships` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `address` TEXT NOT NULL, `city` TEXT NOT NULL, `postalCode` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DealershipDao get dealershipDao {
    return _dealershipDaoInstance ??= _$DealershipDao(database, changeListener);
  }
}

class _$DealershipDao extends DealershipDao {
  _$DealershipDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _dealershipInsertionAdapter = InsertionAdapter(
            database,
            'dealerships',
            (Dealership item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'address': item.address,
                  'city': item.city,
                  'postalCode': item.postalCode
                }),
        _dealershipUpdateAdapter = UpdateAdapter(
            database,
            'dealerships',
            ['id'],
            (Dealership item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'address': item.address,
                  'city': item.city,
                  'postalCode': item.postalCode
                }),
        _dealershipDeletionAdapter = DeletionAdapter(
            database,
            'dealerships',
            ['id'],
            (Dealership item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'address': item.address,
                  'city': item.city,
                  'postalCode': item.postalCode
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Dealership> _dealershipInsertionAdapter;

  final UpdateAdapter<Dealership> _dealershipUpdateAdapter;

  final DeletionAdapter<Dealership> _dealershipDeletionAdapter;

  @override
  Future<List<Dealership>> findAllDealerships() async {
    return _queryAdapter.queryList('SELECT * FROM dealerships ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => Dealership(
            id: row['id'] as int,
            name: row['name'] as String,
            address: row['address'] as String,
            city: row['city'] as String,
            postalCode: row['postalCode'] as String));
  }

  @override
  Future<int?> findMaxId() async {
    return _queryAdapter.query('SELECT MAX(id) FROM dealerships',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertDealership(Dealership dealership) async {
    await _dealershipInsertionAdapter.insert(
        dealership, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDealership(Dealership dealership) async {
    await _dealershipUpdateAdapter.update(dealership, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDealership(Dealership dealership) async {
    await _dealershipDeletionAdapter.delete(dealership);
  }
}
