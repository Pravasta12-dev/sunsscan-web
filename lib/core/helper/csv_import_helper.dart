import 'dart:io';
import 'package:csv/csv.dart';

class CsvImportHelper {
  static Future<List<Map<String, String>>> parseFromPath(
    String filePath,
  ) async {
    final file = File(filePath);
    final content = await file.readAsString();

    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
    ).convert(content);

    if (rows.length < 2) return [];

    final headers = rows.first.map((e) => e.toString()).toList();

    return rows
        .skip(1)
        .map((row) {
          final Map<String, String> data = {};
          for (int i = 0; i < headers.length; i++) {
            data[headers[i]] = row.length > i ? row[i].toString() : '';
          }
          return data;
        })
        .where((row) => row.isNotEmpty)
        .toList();
  }
}
