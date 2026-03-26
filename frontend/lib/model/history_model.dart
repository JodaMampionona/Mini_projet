import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/model/bus_stop_model.dart';

class HistoryEntry {
  final DateTime searchedAt;
  final BusStop start;
  final BusStop end;

  const HistoryEntry({
    required this.searchedAt,
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchedAt': searchedAt.toIso8601String(),
      'start': start.toJson(),
      'end': end.toJson(),
    };
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      searchedAt: DateTime.parse(json['searchedAt'] as String),
      start: BusStop.fromJson(json['start'] as Map<String, dynamic>),
      end: BusStop.fromJson(json['end'] as Map<String, dynamic>),
    );
  }
}

class HistoryModel {
  static const String key = "history_entries";
  static const int maxEntries = 50;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<HistoryEntry>> loadHistory() async {
    final storedString = await _storage.read(key: key);
    if (storedString == null) return [];

    final List<dynamic> jsonList = jsonDecode(storedString) as List<dynamic>;
    final List<HistoryEntry> history = [];

    for (final item in jsonList) {
      try {
        history.add(HistoryEntry.fromJson(item as Map<String, dynamic>));
      } catch (_) {
        debugPrint('error decoding history from secure storage');
      }
    }

    return history;
  }

  Future<void> add(HistoryEntry entry) async {
    final history = await loadHistory();

    history.removeWhere(
      (e) => e.start.name == entry.start.name && e.end.name == entry.end.name,
    );

    history.insert(0, entry);

    if (history.length > maxEntries) {
      history.removeLast();
    }

    final encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    await _storage.write(key: key, value: encoded);
  }

  Future<void> delete(HistoryEntry entry) async {
    final history = await loadHistory();

    history.removeWhere(
      (e) =>
          e.start.name == entry.start.name &&
          e.end.name == entry.end.name &&
          e.searchedAt == entry.searchedAt,
    );

    final encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    await _storage.write(key: key, value: encoded);
  }

  Future<void> clearHistory() async {
    await _storage.delete(key: key);
  }
}
