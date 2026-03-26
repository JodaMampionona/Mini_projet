import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/model/bus_stop_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<HistoryEntry>> loadHistory() async {
    final instance = await SharedPreferences.getInstance();
    final List<String>? stored = instance.getStringList(key);

    if (stored == null) return [];

    final List<HistoryEntry> history = [];

    for (final item in stored) {
      try {
        final json = jsonDecode(item) as Map<String, dynamic>;
        history.add(HistoryEntry.fromJson(json));
      } catch (_) {
        debugPrint('error decoding history from shared pref');
      }
    }

    return history;
  }

  Future<void> add(HistoryEntry entry) async {
    final instance = await SharedPreferences.getInstance();
    final List<String> stored = instance.getStringList(key) ?? [];

    final List<HistoryEntry> history = stored
        .map(
          (e) => HistoryEntry.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList();

    history.removeWhere(
      (e) =>
          e.start.name == entry.start.name &&
          e.end.name == entry.end.name,
    );

    history.insert(0, entry);

    if (history.length > maxEntries) {
      history.removeLast();
    }

    final encoded = history.map((e) => jsonEncode(e.toJson())).toList();
    await instance.setStringList(key, encoded);
  }

  Future<void> delete(HistoryEntry entry) async {
    final instance = await SharedPreferences.getInstance();
    final List<String> stored = instance.getStringList(key) ?? [];

    final List<HistoryEntry> history = stored
        .map(
          (e) => HistoryEntry.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList();

    history.removeWhere(
      (e) =>
          e.start.name == entry.start.name &&
          e.end.name == entry.end.name &&
          e.searchedAt == entry.searchedAt,
    );

    final encoded = history.map((e) => jsonEncode(e.toJson())).toList();
    await instance.setStringList(key, encoded);
  }

  Future<void> clearHistory() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove(key);
  }
}
