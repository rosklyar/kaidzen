import 'package:flutter/foundation.dart';
import 'package:kaidzen_app/service/KaizenState.dart';
import 'package:sqflite/sqflite.dart';

import 'Feature.dart';

const String tableFeatures = 'features';
const String columnFeatureId = 'feature_id';
const String columnFeatureName = 'name';
const String columnFeatureDiscovered = 'discovered';

class FeaturesRepository {
  Database? db;
  FeaturesRepository();

  Future open() async {
    db = await KaizenDb.getDb();
  }

  Future close() async => db!.close();

  Future<List<Feature>> getAll() async {
    if (db == null) {
      await open();
    }
    final List<Map<String, dynamic>> maps = await db!.query(tableFeatures);
    return maps.map((map) => Feature.fromMap(map)).toList();
  }

  Future<void> featureDiscovered(int id) async {
    if (db == null) {
      await open();
    }
    await db!.update(
        tableFeatures, <String, Object?>{columnFeatureDiscovered: 1},
        where: '$columnFeatureId = ?', whereArgs: [id]);
  }
}
