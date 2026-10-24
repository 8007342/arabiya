import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'ink_model.dart';
import 'ink_rubric.dart';

/// Device-local evidence. Raw handwriting is only copied on an explicit export;
/// it is never silently uploaded or included in the app's cloud progress.
class InkEvidenceStore {
  static const key = 'arabiya.ink.evidence.v1';
  static Future<void> _queue = Future.value();
  Future<List<Map<String, dynamic>>> read() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(key);
    if (saved == null) return [];
    try {
      return (jsonDecode(saved) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } on FormatException {
      return [];
    } on TypeError {
      return [];
    }
  }

  Future<void> record(InkAttempt attempt, InkAssessment assessment) {
    final operation = _queue.catchError((Object _) {}).then((_) async {
      final entries = await read();
      entries.add({
        'time': DateTime.now().toUtc().toIso8601String(),
        'target': attempt.target.name,
        'assistance': attempt.assistance.name,
        'pointerKinds': attempt.strokes
            .map((s) => s.pointerKind)
            .toSet()
            .toList(),
        ...assessment.toJson(),
      });
      if (entries.length > 120) entries.removeRange(0, entries.length - 120);
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setString(key, jsonEncode(entries))) {
        throw StateError('Local storage did not accept the save');
      }
    });
    _queue = operation;
    return operation;
  }

  Future<bool> calligraphyUnlocked() async =>
      (await SharedPreferences.getInstance()).getBool(
        'arabiya.ink.calligraphy.v1',
      ) ??
      false;
  Future<void> unlockCalligraphy() async {
    if (!await (await SharedPreferences.getInstance()).setBool(
      'arabiya.ink.calligraphy.v1',
      true,
    )) {
      throw StateError('Local storage did not accept the unlock');
    }
  }
}
