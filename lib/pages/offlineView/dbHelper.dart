import 'dart:io';
import 'package:gtlmd/pages/offlineView/offlinePod/model/podEntry_offlineModel.dart';
import 'package:gtlmd/pages/offlineView/offlineUndelivery/model/undelivery_offlineModel.dart';
import 'package:gtlmd/pages/podEntry/Model/podEntryModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'gtlmd.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE podEntry (
        prmloginbranchcode TEXT,
        prmgrno TEXT PRIMARY KEY,
        prmdlvdt TEXT,
        prmdlvtime TEXT,
        prmname TEXT,
        prmrelation TEXT,
        prmphno TEXT,
        prmsign TEXT,
        prmstamp TEXT,
        prmremarks TEXT,
        prmusercode TEXT,
        prmpodimageurl TEXT,
        prmsighnimageurl TEXT,
        prmsessionid TEXT,
        prmdelayreason TEXT,
        prmdeliveryboy TEXT,
        prmmenucode TEXT,
        prmpoddt TEXT,
        prmdrsno TEXT,
        prmboyid INTEGER,
        prmdeliverpckgs INTEGER,
        prmdamagepckgs INTEGER,
        prmdamagereasonid TEXT,
        prmdamageimg1 TEXT,
        prmdamageimg2 TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE undelivery (
      prmbranchcode TEXT,
      prmundeldt TEXT,
      prmtime TEXT,
      prmdlvtripsheetno TEXT,
      prmgrno TEXT PRIMARY KEY,
      prmreasoncode TEXT,
      prmactioncode TEXT,
      prmremarks TEXT,
      prmusercode TEXT,
      prmmenucode TEXT,
      prmsessionid TEXT,
      prmdrno TEXT,
      prmimagepath TEXT,
      prmreason TEXT,
      prmaction TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE podDamageImages (
      prmgrno TEXT,
      path TEXT
      )
    ''');
  }

  // Insert a podEntry
  static Future<int> insertPod(PodEntryOfflineModel model) async {
    final dbClient = await db;
    return await dbClient.insert('podEntry', {
      // 'commandstatus': model.commandstatus,
      // 'commandmessage': model.commandmessage,
      'prmloginbranchcode': model.prmloginbranchcode,
      'prmgrno': model.prmgrno,
      'prmdlvdt': model.prmdlvdt,
      'prmdlvtime': model.prmdlvtime,
      'prmname': model.prmname,
      'prmrelation': model.prmrelation,
      'prmphno': model.prmphno,
      'prmsign': model.prmsign,
      'prmstamp': model.prmstamp,
      'prmremarks': model.prmremarks,
      'prmusercode': model.prmusercode,
      'prmpodimageurl': model.prmpodimageurl,
      'prmsighnimageurl': model.prmsighnimageurl,
      'prmsessionid': model.prmsessionid,
      'prmdelayreason': model.prmdelayreason,
      'prmdeliveryboy': model.prmdeliveryboy,
      'prmmenucode': model.prmmenucode,
      'prmpoddt': model.prmpoddt,
      'prmdrsno': model.prmdrsno,
      'prmboyid': model.prmboyid,
      'prmdeliverpckgs': model.prmdeliverpckgs,
      'prmdamagepckgs': model.prmdamagepckgs,
      'prmdamagereasonid': model.prmdamagereasonid,
      // 'prmdamageimgstr': model.prmdamageimgstr,
      'prmdamageimg1': model.prmdamageimg1,
      // 'prmdamageimg2': model.prmdamageimg2
    });
  }

  // Insert an undelivery for a user
  static Future<int> insertUndelivery(UnDeliveryOfflineModel model) async {
    final dbClient = await db;
    return await dbClient.insert('unDelivery', {
      // 'commandstatus': model.commandstatus,
      // 'commandmessage': model.commandmessage,
      'prmbranchcode': model.prmbranchcode,
      'prmundeldt': model.prmundeldt,
      'prmtime': model.prmtime,
      'prmdlvtripsheetno': model.prmdlvtripsheetno,
      'prmgrno': model.prmgrno,
      'prmreasoncode': model.prmreasoncode,
      'prmactioncode': model.prmactioncode,
      'prmremarks': model.prmremarks,
      'prmusercode': model.prmusercode,
      'prmmenucode': model.prmmenucode,
      'prmsessionid': model.prmsessionid,
      'prmdrno': model.prmdrno,
      'prmimagepath': model.prmimagepath,
      'prmreason': model.prmreason,
      'prmaction': model.prmaction,
    });
  }

  // Get all Pods
  static Future<List<Map<String, dynamic>>> getPodEntryDetail() async {
    final dbClient = await db;
    return await dbClient.query('podEntry', distinct: true);
  }

  // Get all Undelivery
  static Future<List<Map<String, dynamic>>> getUndeliveryDetail() async {
    final dbClient = await db;
    return await dbClient.query('unDelivery', distinct: true);
  }

  static Future<int> getPodEntryCount() async {
    final dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient.query('podEntry');
    return list.length;
  }

  static Future<int> getUndeliveryCount() async {
    final dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient.query('unDelivery');
    return list.length;
  }

  static Future<int> deletePodEntry(PodEntryOfflineModel item) async {
    final dbClient = await db;
    return dbClient
        .delete('podEntry', where: 'prmgrno = ?', whereArgs: [item.prmgrno]);
  }

  static Future<int> deleteUndeliveryEntry(UnDeliveryOfflineModel item) async {
    final dbClient = await db;
    return dbClient
        .delete('unDelivery', where: 'prmgrno = ?', whereArgs: [item.prmgrno]);
  }

  static Future<int> deleteMultiplePodEntry(
      List<PodEntryOfflineModel> items) async {
    final dbClient = await db;

    // Extract prmgrno values from the list
    List<String?> prmgrnos = items.map((e) => e.prmgrno).toList();

    if (prmgrnos.isEmpty) return 0; // Nothing to delete

    // Create the correct number of placeholders (?, ?, ?) for the SQL IN clause
    String placeholders = List.filled(prmgrnos.length, '?').join(',');

    // Run the delete query
    return await dbClient.delete(
      'podEntry',
      where: 'prmgrno IN ($placeholders)',
      whereArgs: prmgrnos,
    );
  }

  static Future<int> deleteMultipleUndeliveryEntry(
      List<UnDeliveryOfflineModel> items) async {
    final dbClient = await db;

    // Extract prmgrno values from the list
    List<String?> prmgrnos = items.map((e) => e.prmgrno).toList();

    if (prmgrnos.isEmpty) return 0; // Nothing to delete

    // Create the correct number of placeholders (?, ?, ?) for the SQL IN clause
    String placeholders = List.filled(prmgrnos.length, '?').join(',');

    // Run the delete query
    return await dbClient.delete(
      'unDelivery',
      where: 'prmgrno IN ($placeholders)',
      whereArgs: prmgrnos,
    );
  }

  static Future<int> deleteAllPods() async {
    final dbClient = await db;
    return dbClient.delete('podEntry');
  }

  static Future<int> deleteAllUndelivery() async {
    final dbClient = await db;
    return dbClient.delete('unDelivery');
  }

  static Future<List<String>> getPodGrList() async {
    final dbClient = await db;
    List<Map<String, Object?>> result =
        await dbClient.query('podEntry', columns: ['prmgrno']);
    List<String> prmgrnoList =
        result.map((row) => row['prmgrno'] as String).toList();

    return prmgrnoList;
  }

  static Future<List<String>> getUndeliveryGrList() async {
    final dbClient = await db;
    List<Map<String, Object?>> result =
        await dbClient.query('unDelivery', columns: ['prmgrno']);
    List<String> prmgrnoList =
        result.map((row) => row['prmgrno'] as String).toList();

    return prmgrnoList;
  }

  static Future<int> insertPodDamageImage(
      String prmgrno, List<String> path) async {
    final dbClient = await db;
    int result = 0;
    for (String imgPath in path) {
      result += await dbClient.insert('podDamageImages', {
        'prmgrno': prmgrno,
        'path': imgPath,
      });
    }
    return result;
  }

  static Future<List<Map<String, dynamic>>> getPodDamageImages(
      String prmgrno) async {
    final dbClient = await db;
    return await dbClient.query('podDamageImages',
        where: 'prmgrno = ?', whereArgs: [prmgrno], distinct: true);
  }

  static Future<int> deletePodDamageImage(String prmgrno) async {
    final dbClient = await db;
    return await dbClient
        .delete('podDamageImages', where: 'prmgrno = ?', whereArgs: [prmgrno]);
  }

  static Future<int> getPodImageCount(String prmgrno) async {
    final dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient
        .query('podDamageImages', where: 'prmgrno = ?', whereArgs: [prmgrno]);
    return list.length;
  }

  static Future<List<String>> getAllPodDamageImagesList() async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query('podDamageImages');
    List<String> imagePaths = result.map((e) => e['path'] as String).toList();
    return imagePaths;
  }
}
