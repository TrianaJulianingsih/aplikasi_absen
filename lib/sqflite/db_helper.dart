// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:tugas_13/models/kehadiran.dart';
import 'package:tugas_13/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tugas_13/preference/login.dart'; 

class DbHelper {
  static Future<Database> databaseHelper() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'login.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, nama TEXT, email TEXT, password TEXT)',
        );
        await db.execute(
          'CREATE TABLE kehadiran(id_kehadiran INTEGER PRIMARY KEY, userId INTEGER, nama TEXT, tanggal TEXT, kelas TEXT, status TEXT, email TEXT)',
        );
      },

      version: 5,
    );
  }

  static Future<void> registerUser(User user) async {
    final db = await databaseHelper();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // static Future<void> registerKehadiran(Kehadiran kehadiran) async {
  //   final db = await databaseHelper();
  //   await db.insert(
  //     'kehadiran',
  //     kehadiran.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  static Future<void> registerKehadiran(Kehadiran kehadiran) async {
  final db = await databaseHelper();
  String? email = await PreferenceHandler.getEmail();

  final data = kehadiran.toMap();
  data['email'] = email;

  // Jika idKehadiran ada, maka update, jika tidak insert baru
  if (kehadiran.idKehadiran != null) {
    await db.update(
      'kehadiran',
      data,
      where: 'id_kehadiran = ?',
      whereArgs: [kehadiran.idKehadiran],
    );
  } else {
    await db.insert(
      'kehadiran',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

  static Future<User?> loginUser(String email, String password) async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ? ',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  static Future<List<Kehadiran>> getAllKehadiran() async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query('kehadiran');
    return results.map((e) => Kehadiran.fromMap(e)).toList();
  }

  static Future<List<User>> getAllUser() async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query('users');
    return results.map((e) => User.fromMap(e)).toList();
  }

  static Future<User?> getUserById(int id) async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }
  // static Future<Kehadiran?> readKehadiran(String tanggal, String status) async {
  //   final db = await databaseHelper();
  //   final List<Map<String, dynamic>> results = await db.query(
  //     'kehadiran',
  //     where: 'tanggal = ? AND status = ? ',
  //     whereArgs: [tanggal, status],
  //   );

  //   if (results.isNotEmpty) {
  //     return Kehadiran.fromMap(results.first);
  //   }
  //   return null;
  // }

  // static Future<List<Kehadiran>> getKehadiranByBulan(String bulan) async {
  //   final db = await databaseHelper();
  //   final List<Map<String, dynamic>> results = await db.query(
  //     'kehadiran',
  //     where: 'substr(tanggal, 4, 2) = ?',
  //     whereArgs: [bulan]
  //   );

  //   return results.map((e) => Kehadiran.fromMap(e)).toList();
  // }

  // static Future<List<Kehadiran>> getKehadiranByBulan(String bulan) async {
  //   final db = await databaseHelper();
  //   String? email = await PreferenceHandler.getEmail();

  //   final List<Map<String, dynamic>> results = await db.query(
  //     'kehadiran',
  //     where: 'substr(tanggal, 4, 2) = ? AND email = ?',
  //     whereArgs: [bulan, email],
  //   );

  //   return results.map((e) => Kehadiran.fromMap(e)).toList();
  // }

  static Future<List<Kehadiran>> getKehadiranByUser(int userId) async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query(
      'kehadiran',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return results.map((e) => Kehadiran.fromMap(e)).toList();
  }

  static Future<List<Kehadiran>> getKehadiranByUserAndMonth(int userId, String bulan) async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query(
      'kehadiran',
      where: 'userId = ? AND substr(tanggal, 4, 2) = ?',
      whereArgs: [userId, bulan],
    );
    return results.map((e) => Kehadiran.fromMap(e)).toList();
  }


  static Future<void> updateUser(User user) async {
    final db = await databaseHelper();
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Ganti fungsi deletePeserta dengan fungsi deleteUser
static Future<void> deleteUser(int id) async {
  final db = await databaseHelper();
  await db.delete('users', where: 'id = ?', whereArgs: [id]);
}

  // Tambahkan method-method berikut di class DbHelper

static Future<void> updateKehadiran(Kehadiran kehadiran) async {
  final db = await databaseHelper();
  await db.update(
    'kehadiran',
    kehadiran.toMap(),
    where: 'id_kehadiran = ?',
    whereArgs: [kehadiran.idKehadiran],
  );
}

static Future<void> deleteKehadiran(int id) async {
  final db = await databaseHelper();
  await db.delete(
    'kehadiran',
    where: 'id_kehadiran = ?',
    whereArgs: [id],
  );
}
}

