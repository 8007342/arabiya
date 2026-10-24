// @trace spec:arabiya, spec:cloud-edge-sync
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/comic_models.dart';

class CloudUserProfile {
  final String userKey;
  final String displayName;
  final String email;
  final String authProvider;

  const CloudUserProfile({
    required this.userKey,
    required this.displayName,
    required this.email,
    required this.authProvider,
  });

  factory CloudUserProfile.fromJson(Map<String, dynamic> json) {
    return CloudUserProfile(
      userKey: (json['userKey'] as String?) ?? '',
      displayName: (json['displayName'] as String?) ?? 'Traveler',
      email: (json['email'] as String?) ?? '',
      authProvider: (json['authProvider'] as String?) ?? 'passport',
    );
  }
}

class ProgressSyncService extends ChangeNotifier {
  ProgressSyncService({http.Client? client})
    : _client = client ?? http.Client();
  final http.Client _client;
  String? _progressOwner;
  bool _sessionConfirmed = false;
  bool _dirty = false;
  int _revision = 0;
  int _identityRevision = 0;
  Future<void>? _syncTask;
  Future<void> _localWrites = Future<void>.value();

  Future<void> _persistLocal() {
    final snapshot = jsonEncode(_progress.toJson());
    final dirty = _dirty;
    _localWrites = _localWrites.then((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kHasStartedKey, true);
      await prefs.setString(_kProgressKey, snapshot);
      await prefs.setBool('arabiya_progress_pending', dirty);
    });
    return _localWrites;
  }

  static const String _kProgressKey = 'arabiya_progress_v1';
  static const String _kTokenKey = 'arabiya_session_token';
  static const String _kUserJsonKey = 'arabiya_user_json';
  static const String _kHasStartedKey = 'arabiya_has_started';

  PlayerProgressState _progress = const PlayerProgressState();
  CloudUserProfile? _user;
  String? _sessionToken;
  bool _hasStarted = false;
  bool _syncing = false;
  String _saveStatus = 'Saved on this device';
  String get saveStatus => _saveStatus;
  Map<String, String> get _authHeaders =>
      _sessionToken != null && _sessionToken != 'cookie-session'
      ? {'authorization': 'Bearer $_sessionToken'}
      : {};

  PlayerProgressState get progress => _progress;
  CloudUserProfile? get user => _user;
  bool get isAuthenticated => _sessionConfirmed && _user != null;
  bool get shouldSkipLanding => isAuthenticated || _hasStarted;
  bool get isSyncing => _syncing;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _hasStarted = prefs.getBool(_kHasStartedKey) ?? false;
    _progressOwner = prefs.getString('arabiya_progress_owner');
    _dirty = prefs.getBool('arabiya_progress_pending') ?? false;
    _sessionToken = prefs.getString(_kTokenKey);

    final rawUser = prefs.getString(_kUserJsonKey);
    if (rawUser != null && rawUser.isNotEmpty) {
      try {
        _user = CloudUserProfile.fromJson(
          jsonDecode(rawUser) as Map<String, dynamic>,
        );
      } catch (_) {}
    }

    final rawProgress = prefs.getString(_kProgressKey);
    if (rawProgress != null && rawProgress.isNotEmpty) {
      try {
        _progress = PlayerProgressState.fromJson(
          jsonDecode(rawProgress) as Map<String, dynamic>,
        );
      } catch (_) {}
    }

    _progressOwner ??= _user?.userKey;
    await refreshCloudSession();
  }

  Future<void> markJourneyStarted() async {
    _hasStarted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHasStartedKey, true);
  }

  Future<void> saveProgress(PlayerProgressState next) async {
    _progress = next;
    _hasStarted = true;
    _dirty = true;
    _revision++;
    await _persistLocal();
    if (isAuthenticated) await syncToCloud();
  }

  Future<void> recordWritingEvidence(Map<String, dynamic> event) async {
    final id = event['id'];
    if (id is! String || id.isEmpty || jsonEncode(event).length > 1024) return;
    if (_progress.writingEvidence.any((entry) => entry['id'] == id)) return;
    final records = [
      ..._progress.writingEvidence,
      Map<String, dynamic>.from(event),
    ];
    await saveProgress(
      _progress.copyWith(
        writingEvidence: records
            .skip(records.length > 96 ? records.length - 96 : 0)
            .toList(),
      ),
    );
    notifyListeners();
  }

  Future<void> completeGoogleSignIn() async {
    _identityRevision++;
    final guestProgress = _progressOwner == null && _user == null
        ? _progress
        : null;
    _sessionConfirmed = false;
    _user = null;
    _sessionToken = 'cookie-session';
    await refreshCloudSession();
    if (!isAuthenticated || _user!.authProvider != 'google') {
      throw StateError('Google session could not be restored');
    }
    if (guestProgress != null) {
      await saveProgress(guestProgress);
    }
    notifyListeners();
  }

  Future<void> refreshCloudSession() async {
    try {
      final response = await _client
          .get(Uri.parse('/api/auth/session'), headers: _authHeaders)
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['authenticated'] == true) {
          _sessionConfirmed = true;
          _sessionToken ??= 'cookie-session';
          if (data['user'] is Map<String, dynamic>) {
            _user = CloudUserProfile.fromJson(
              data['user'] as Map<String, dynamic>,
            );
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_kTokenKey, _sessionToken!);
          if (data['user'] is Map<String, dynamic>) {
            await prefs.setString(_kUserJsonKey, jsonEncode(data['user']));
          }
          final restorePending = _dirty && _progressOwner == _user?.userKey;
          _progressOwner = _user?.userKey;
          if (_progressOwner != null) {
            await prefs.setString('arabiya_progress_owner', _progressOwner!);
          }
          _saveStatus = 'All changes synced';
          if (restorePending) {
            await syncToCloud();
          } else if (data['progress'] is Map<String, dynamic>) {
            _dirty = false;
            await prefs.setBool('arabiya_progress_pending', false);
            _progress = PlayerProgressState.fromJson(
              data['progress'] as Map<String, dynamic>,
            );
            await prefs.setString(
              _kProgressKey,
              jsonEncode(_progress.toJson()),
            );
          }
        } else {
          _sessionConfirmed = false;
          _user = null;
          _sessionToken = null;
          _saveStatus = 'Saved on this device · Sign in to sync';
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(_kTokenKey);
          await prefs.remove(_kUserJsonKey);
        }
      }
    } catch (_) {
      _sessionConfirmed = false;
      _saveStatus = 'Saved on this device · Cloud unavailable';
    }
    notifyListeners();
  }

  Future<void> syncToCloud() {
    if (_syncTask != null) return _syncTask!;
    if (!isAuthenticated ||
        _sessionToken == null ||
        _sessionToken!.startsWith('local-')) {
      return Future<void>.value();
    }
    _syncTask = _uploadPendingProgress().whenComplete(() => _syncTask = null);
    return _syncTask!;
  }

  Future<void> _uploadPendingProgress() async {
    final identity = _identityRevision;
    final owner = _user?.userKey;
    _syncing = true;
    _saveStatus = 'Saving to cloud…';
    notifyListeners();
    try {
      do {
        final revision = _revision;
        final payload = _progress.toJson();
        final response = await _client
            .post(
              Uri.parse('/api/progress'),
              headers: {'content-type': 'application/json', ..._authHeaders},
              body: jsonEncode({'progress': payload}),
            )
            .timeout(const Duration(seconds: 5));
        if (identity != _identityRevision || owner != _user?.userKey) return;
        if (response.statusCode != 200) {
          if (response.statusCode == 401) _sessionConfirmed = false;
          _saveStatus = response.statusCode == 401
              ? 'Saved locally · Sign in to resume sync'
              : 'Saved locally · Sync failed';
          return;
        }
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['progress'] is! Map<String, dynamic>) {
          throw const FormatException('Missing progress acknowledgement');
        }
        // A late response must never replace a newer local checkpoint/ink attempt.
        if (revision == _revision) {
          _progress = PlayerProgressState.fromJson(
            data['progress'] as Map<String, dynamic>,
          );
          _dirty = false;
          await _persistLocal();
        }
      } while (_dirty && isAuthenticated && identity == _identityRevision);
      if (identity == _identityRevision) _saveStatus = 'All changes synced';
    } catch (_) {
      if (identity == _identityRevision) {
        _saveStatus = 'Saved locally · Sync pending';
      }
    } finally {
      _syncing = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (_sessionToken != null && !_sessionToken!.startsWith('local-')) {
      final response = await _client
          .post(Uri.parse('/api/auth/logout'), headers: _authHeaders)
          .timeout(const Duration(seconds: 3));
      if (response.statusCode != 200) {
        throw StateError(
          'Could not sign out. Check your connection and retry.',
        );
      }
    }
    _identityRevision++;
    _sessionConfirmed = false;
    _user = null;
    _sessionToken = null;
    _saveStatus = 'Saved on this device · Sign in to sync';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    await prefs.remove(_kUserJsonKey);
  }
}
