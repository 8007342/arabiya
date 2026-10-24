import 'dart:convert';
import 'dart:async';

import 'package:arabiya/src/models/comic_models.dart';
import 'package:arabiya/src/services/progress_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, Object> session(String subject, int xp) => {
  'authenticated': true,
  'user': {
    'userKey': 'google:$subject',
    'displayName': subject,
    'email': '',
    'authProvider': 'google',
  },
  'progress': PlayerProgressState(xp: xp).toJson(),
};

http.Response jsonResponse(String body, int status) => http.Response(
  body,
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  test(
    'Google cookie session imports guest progress without storing a credential',
    () async {
      SharedPreferences.setMockInitialValues({});
      var signedIn = false;
      var uploaded = 0;
      final service = ProgressSyncService(
        client: MockClient((request) async {
          expect(request.headers.containsKey('authorization'), false);
          if (request.url.path == '/api/auth/session') {
            return jsonResponse(
              jsonEncode(
                signedIn ? session('alice', 80) : {'authenticated': false},
              ),
              200,
            );
          }
          uploaded++;
          expect(jsonDecode(request.body)['progress']['xp'], 25);
          return jsonResponse(
            jsonEncode({
              'progress': const PlayerProgressState(xp: 80).toJson(),
            }),
            200,
          );
        }),
      );
      await service.initialize();
      await service.saveProgress(const PlayerProgressState(xp: 25));
      signedIn = true;
      await service.completeGoogleSignIn();
      expect(service.isAuthenticated, true);
      expect(service.progress.xp, 80);
      expect(uploaded, 1);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('arabiya_session_token'), 'cookie-session');
      expect(prefs.getString('arabiya_progress_owner'), 'google:alice');
    },
  );

  test(
    'a previous account save is not imported into another Google account',
    () async {
      SharedPreferences.setMockInitialValues({
        'arabiya_progress_owner': 'google:alice',
        'arabiya_progress_v1': jsonEncode(
          const PlayerProgressState(xp: 900).toJson(),
        ),
      });
      var signedIn = false;
      final service = ProgressSyncService(
        client: MockClient((request) async {
          expect(request.url.path, '/api/auth/session');
          return jsonResponse(
            jsonEncode(
              signedIn ? session('bob', 10) : {'authenticated': false},
            ),
            200,
          );
        }),
      );
      await service.initialize();
      signedIn = true;
      await service.completeGoogleSignIn();
      expect(service.user!.userKey, 'google:bob');
      expect(service.progress.xp, 10);
    },
  );

  test(
    'cached profile does not prove an authenticated session when offline',
    () async {
      SharedPreferences.setMockInitialValues({
        'arabiya_session_token': 'cookie-session',
        'arabiya_user_json': jsonEncode(session('alice', 10)['user']),
      });
      final service = ProgressSyncService(
        client: MockClient((_) async => throw Exception('offline')),
      );
      await service.initialize();
      expect(service.isAuthenticated, false);
      expect(service.saveStatus, contains('Cloud unavailable'));
    },
  );
  test('pending local progress survives restore and failed upload', () async {
    SharedPreferences.setMockInitialValues({
      'arabiya_progress_owner': 'google:alice',
      'arabiya_progress_pending': true,
      'arabiya_progress_v1': jsonEncode(
        const PlayerProgressState(xp: 250).toJson(),
      ),
    });
    final service = ProgressSyncService(
      client: MockClient((request) async {
        if (request.url.path == '/api/auth/session') {
          return jsonResponse(jsonEncode(session('alice', 80)), 200);
        }
        expect(jsonDecode(request.body)['progress']['xp'], 250);
        return jsonResponse('{}', 503);
      }),
    );
    await service.initialize();
    expect(service.progress.xp, 250);
    expect(service.saveStatus, contains('Sync failed'));
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('arabiya_progress_pending'), true);
  });

  test(
    'failed logout does not pretend the server session was revoked',
    () async {
      SharedPreferences.setMockInitialValues({});
      final service = ProgressSyncService(
        client: MockClient((request) async {
          if (request.url.path == '/api/auth/session') {
            return jsonResponse(jsonEncode(session('alice', 80)), 200);
          }
          return jsonResponse('{}', 503);
        }),
      );
      await service.initialize();
      await expectLater(service.signOut(), throwsStateError);
      expect(service.isAuthenticated, true);
    },
  );
  test(
    'late cloud acknowledgement does not discard newer writing evidence',
    () async {
      SharedPreferences.setMockInitialValues({});
      final firstUpload = Completer<http.Response>();
      final uploadStarted = Completer<void>();
      var uploads = 0;
      final service = ProgressSyncService(
        client: MockClient((request) async {
          if (request.url.path == '/api/auth/session') {
            return jsonResponse(jsonEncode(session('alice', 10)), 200);
          }
          uploads++;
          if (uploads == 1) {
            uploadStarted.complete();
            return firstUpload.future;
          }
          return jsonResponse(
            jsonEncode({'progress': jsonDecode(request.body)['progress']}),
            200,
          );
        }),
      );
      await service.initialize();
      final firstSave = service.saveProgress(
        service.progress.copyWith(currentPanelIndex: 1),
      );
      await uploadStarted.future;
      final inkSave = service.recordWritingEvidence({
        'id': 'attempt-late-save',
        'target': 'ba',
        'accepted': true,
        'timestamp': '2026-10-24T00:00:00Z',
      });
      firstUpload.complete(
        jsonResponse(
          jsonEncode({'progress': const PlayerProgressState(xp: 10).toJson()}),
          200,
        ),
      );
      await Future.wait([firstSave, inkSave]);
      expect(uploads, 2);
      expect(service.progress.currentPanelIndex, 1);
      expect(
        service.progress.writingEvidence.single['id'],
        'attempt-late-save',
      );
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('arabiya_progress_pending'), false);
    },
  );
}
