import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sun_scan.db');

    print('Database path: $path');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        event_uuid TEXT PRIMARY KEY,
        event_code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        event_date_start TEXT NOT NULL,
        event_date_end TEXT NOT NULL,
        location TEXT,
        is_active INTEGER NOT NULL DEFAULT 0,
        out_active INTEGER NOT NULL DEFAULT 0,
        is_locked INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        sync_status TEXT NOT NULL DEFAULT 'pending'
      );
    ''');

    await db.execute('''
      CREATE TABLE guests (
        guest_uuid TEXT PRIMARY KEY,
        event_uuid TEXT NOT NULL,
        name TEXT NOT NULL,
        phone TEXT,
        qr_value TEXT NOT NULL UNIQUE,
        photo TEXT,
        tag TEXT,
        is_checked_in INTEGER NOT NULL DEFAULT 0,
        gender VARCHAR(16) NOT NULL DEFAULT 'male',
        guest_category_uuid TEXT NOT NULL,
        guest_category_name TEXT,
        checked_in_at TEXT,
        checked_out_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        FOREIGN KEY (event_uuid) REFERENCES events (event_uuid) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE guest_categories (
        category_uuid TEXT PRIMARY KEY,
        event_uuid TEXT NOT NULL,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        FOREIGN KEY (event_uuid) REFERENCES events (event_uuid) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE souvenirs (
        souvenir_uuid TEXT PRIMARY KEY,
        event_uuid TEXT NOT NULL,
        guest_uuid TEXT NOT NULL,
        guest_category_uuid TEXT NOT NULL,
        souvenir_status TEXT NOT NULL DEFAULT 'pending',
        received_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        FOREIGN KEY (event_uuid) REFERENCES events (event_uuid) ON DELETE CASCADE,
        FOREIGN KEY (guest_uuid) REFERENCES guests (guest_uuid) ON DELETE CASCADE,
        FOREIGN KEY (guest_category_uuid) REFERENCES guest_categories (category_uuid) ON DELETE CASCADE
      );
    ''');

    await db.execute('CREATE INDEX idx_guests_qr_value ON guests (qr_value);');
    await db.execute(
      'CREATE INDEX idx_guests_event_uuid ON guests (event_uuid);',
    );
    await db.execute(
      'CREATE INDEX idx_souvenirs_event_uuid ON souvenirs (event_uuid);',
    );
    await db.execute(
      'CREATE INDEX idx_souvenirs_guest_uuid ON souvenirs (guest_uuid);',
    );
    await db.execute(
      'CREATE INDEX idx_souvenirs_guest_category_uuid ON souvenirs (guest_category_uuid);',
    );
  }
}
