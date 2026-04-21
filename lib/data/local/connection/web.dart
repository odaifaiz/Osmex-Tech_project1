// lib/data/local/connection/web.dart
import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnection() {
  return WebDatabase('cityfix_web');
}
