// @trace spec:arabiya, spec:cloud-edge-sync
import 'dart:convert';
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

class ProgressSyncService {
  static const String _kProgressKey = 'arabiya_progress_v1';
  static const String _kTokenKey = 'arabiya_session_token';
  static const String _kUserJsonKey = 'arabiya_user_json';
  static const String _kHasStartedKey = 'arabiya_has_started';

  PlayerProgressState _progress = const PlayerProgressState();
  CloudUserProfile? _user;
  String? _sessionToken;
  bool _hasStarted = false;
  bool _syncing = false;

  PlayerProgressState get progress => _progress;
  CloudUserProfile? get user => _user;
  bool get isAuthenticated => _user != null && (_sessionToken?.isNotEmpty ?? false);
  bool get shouldSkipLanding => isAuthenticated || _hasStarted;
  bool get isSyncing => _syncing;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _hasStarted = prefs.getBool(_kHasStartedKey) ?? false;
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

    if (_sessionToken != null && _sessionToken!.isNotEmpty) {
      await refreshCloudSession();
    }
  }

  Future<void> markJourneyStarted() async {
    _hasStarted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHasStartedKey, true);
  }

  Future<void> saveProgress(PlayerProgressState next) async {
    _progress = next;
    _hasStarted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHasStartedKey, true);
    await prefs.setString(_kProgressKey, jsonEncode(next.toJson()));

    if (isAuthenticated) {
      await syncToCloud();
    }
  }

  Future<String?> signInWithPassport({
    required String handle,
    String? displayName,
    String passcode = 'tlatoani',
  }) async {
    _syncing = true;
    try {
      final response = await http
          .post(
            Uri.parse('/api/auth/passport'),
            headers: {'content-type': 'application/json'},
            body: jsonEncode({
              'handle': handle.trim(),
              'displayName': (displayName?.trim().isNotEmpty ?? false)
                  ? displayName!.trim()
                  : handle.trim().split('@').first,
              'passcode': passcode.trim().isEmpty ? 'tlatoani' : passcode.trim(),
              'progress': _progress.toJson(),
            }),
          )
          .timeout(const Duration(seconds: 6));

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return (body['error'] as String?) ?? 'Could not sign in';
      }

      _sessionToken = (body['sessionToken'] as String?) ?? 'cookie-session';
      if (body['user'] is Map<String, dynamic>) {
        _user = CloudUserProfile.fromJson(body['user'] as Map<String, dynamic>);
      }
      if (body['progress'] is Map<String, dynamic>) {
        _progress = PlayerProgressState.fromJson(
          body['progress'] as Map<String, dynamic>,
        );
      }
      _hasStarted = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kTokenKey, _sessionToken!);
      await prefs.setBool(_kHasStartedKey, true);
      if (_user != null) {
        await prefs.setString(
          _kUserJsonKey,
          jsonEncode({
            'userKey': _user!.userKey,
            'displayName': _user!.displayName,
            'email': _user!.email,
            'authProvider': _user!.authProvider,
          }),
        );
      }
      await prefs.setString(_kProgressKey, jsonEncode(_progress.toJson()));
      return null;
    } catch (_) {
      // Offline / local preview fallback: create local traveler passport seamlessly.
      final clean = handle.trim();
      _sessionToken = 'local-${DateTime.now().millisecondsSinceEpoch}';
      _user = CloudUserProfile(
        userKey: 'passport:${clean.toLowerCase()}',
        displayName: (displayName?.trim().isNotEmpty ?? false)
            ? displayName!.trim()
            : clean.split('@').first,
        email: clean,
        authProvider: 'passport-local',
      );
      _hasStarted = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kTokenKey, _sessionToken!);
      await prefs.setBool(_kHasStartedKey, true);
      await prefs.setString(
        _kUserJsonKey,
        jsonEncode({
          'userKey': _user!.userKey,
          'displayName': _user!.displayName,
          'email': _user!.email,
          'authProvider': _user!.authProvider,
        }),
      );
      return null;
    } finally {
      _syncing = false;
    }
  }

  Future<void> refreshCloudSession() async {
    if (_sessionToken == null || _sessionToken!.startsWith('local-')) return;
    try {
      final response = await http
          .get(
            Uri.parse('/api/auth/session'),
            headers: {'authorization': 'Bearer $_sessionToken'},
          )
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['authenticated'] == true) {
          if (data['user'] is Map<String, dynamic>) {
            _user = CloudUserProfile.fromJson(
              data['user'] as Map<String, dynamic>,
            );
          }
          if (data['progress'] is Map<String, dynamic>) {
            _progress = PlayerProgressState.fromJson(
              data['progress'] as Map<String, dynamic>,
            );
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_kProgressKey, jsonEncode(_progress.toJson()));
          }
        }
      }
    } catch (_) {}
  }

  Future<void> syncToCloud() async {
    if (_sessionToken == null || _sessionToken!.startsWith('local-')) return;
    _syncing = true;
    try {
      final response = await http
          .post(
            Uri.parse('/api/progress'),
            headers: {
              'content-type': 'application/json',
              'authorization': 'Bearer $_sessionToken',
            },
            body: jsonEncode({'progress': _progress.toJson()}),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['progress'] is Map<String, dynamic>) {
          _progress = PlayerProgressState.fromJson(
            data['progress'] as Map<String, dynamic>,
          );
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_kProgressKey, jsonEncode(_progress.toJson()));
        }
      }
    } catch (_) {
    } finally {
      _syncing = false;
    }
  }

  Future<void> signOut() async {
    try {
      if (_sessionToken != null && !_sessionToken!.startsWith('local-')) {
        await http
            .post(
              Uri.parse('/api/auth/logout'),
              headers: {'authorization': 'Bearer $_sessionToken'},
            )
            .timeout(const Duration(seconds: 3));
      }
    } catch (_) {}
    _user = null;
    _sessionToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    await prefs.remove(_kUserJsonKey);
  }
}
