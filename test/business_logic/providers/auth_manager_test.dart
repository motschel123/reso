import 'package:flutter_test/flutter_test.dart';
import 'package:reso/business_logic/providers/auth_manager.dart';
import 'package:reso/consts/strings_german.dart';

import '../../mocks.dart';

void main() {
  group('Validators', () {
    final UserMock _userMock = UserMock();
    final UserCredentialMock _userCredentialMock = UserCredentialMock();
    final AuthManager _authManager = AuthManager(
        authOverride: FirebaseAuthMock(_userMock, _userCredentialMock));
    test('emailValidator should only validate @fau.de mails', () {
      final Map<String, String?> mails = <String, String?>{
        'marcel.schoeckel@gmail.com': EMAIL_DOMAIN_INVALID,
        'm.a@gmx.de': EMAIL_DOMAIN_INVALID,
        'richtige.mail@fau.de': null,
        'nochmal.richtig@fau.de': null,
        'keinmail.gamil@com': EMAIL_FORMAT_INVALID,
        'negat.iv@faude': EMAIL_FORMAT_INVALID,
        'nope.fau@de': EMAIL_FORMAT_INVALID,
        '': EMAIL_EMPTY,
        '       ': EMAIL_EMPTY,
      };

      mails.forEach((String mail, String? response) {
        expect(_authManager.emailValidator(mail), response,
            reason: '$mail wrong validated');
      });
    });
    test('passwordValidator should validate passwords', () {
      // TODO: implement
    });
    test('displayNameValidator should validate names', () {
      // TODO(motschel123): implement
    });
  });
}
