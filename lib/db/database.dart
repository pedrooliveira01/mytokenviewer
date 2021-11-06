import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mytokenview/model/contracts.dart';

class TokenDB {
  static final TokenDB instance = TokenDB._init();

  static Database? _database;

  TokenDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY';
    final textType = 'TEXT';
    final notNull = 'NOT NULL';
    final intType = 'INTEGER';

    await db.execute('''
      CREATE TABLE $tableContracts ( 
        ${ContractFields.id} $idType, 
        ${ContractFields.code} $textType $notNull, 
        ${ContractFields.name} $textType $notNull,
        ${ContractFields.img} $textType,
        ${ContractFields.address} $textType,
        ${ContractFields.decimals} $intType
        )
      ''');
  }

  Future<Contract> create(Contract contract) async {
    final db = await instance.database;
    final id = await db.insert(tableContracts, contract.toJson());
    return contract.copy(id: id);
  }

  Future<Contract> readContract(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableContracts,
      columns: ContractFields.values,
      where: '${ContractFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Contract.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<Contract> readContractCode(String code) async {
    final db = await instance.database;

    final maps = await db.query(
      tableContracts,
      columns: ContractFields.values,
      where: '${ContractFields.code} = ?',
      whereArgs: [code],
    );

    if (maps.isNotEmpty) {
      return Contract.fromJson(maps.first);
    } else {
      throw Exception('ID $code not found');
    }
  }

  Future<bool> existToken(String code) async {
    final db = await instance.database;

    final maps = await db.query(
      tableContracts,
      columns: ContractFields.values,
      where: '${ContractFields.code} = ?',
      whereArgs: [code],
    );

    return maps.isNotEmpty;
  }

  Future<List<Contract>> readAllContracts() async {
    final db = await instance.database;

    final result = await db.query(tableContracts, orderBy: ContractFields.id);

    return result.map((json) => Contract.fromJson(json)).toList();
  }

  Future<int> update(Contract contract) async {
    final db = await instance.database;

    return db.update(
      tableContracts,
      contract.toJson(),
      where: '${ContractFields.id} = ?',
      whereArgs: [contract.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableContracts,
      where: '${ContractFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCode(String code) async {
    final db = await instance.database;

    return await db.delete(
      tableContracts,
      where: '${ContractFields.code} = ?',
      whereArgs: [code],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
