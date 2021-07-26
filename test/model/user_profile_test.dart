import 'package:flutter_test/flutter_test.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/user_profile.dart';

void main() {
  group('UserProfile model parsing', () {
    final UserProfile userProfile =
        UserProfile(uid: 'a1d', displayName: 'Luca Beetz', imageUrl: 'imgUrl');
    test('To Map', () {
      expect(
          userProfile.toMap(),
          equals(<String, dynamic>{
            USER_UID: userProfile.uid,
            USER_DISPLAY_NAME: userProfile.displayName,
            USER_IMAGE_URL: userProfile.imageUrl,
          }));
    });

    test('From Map', () {
      final Map<String, dynamic> userProfileMap = userProfile.toMap();
      final UserProfile mappedUserProfile = UserProfile.fromMap(userProfileMap);

      expect(mappedUserProfile.displayName, userProfile.displayName);
      expect(mappedUserProfile.imageUrl, userProfile.imageUrl);
      expect(mappedUserProfile.uid, userProfile.uid);
    });
  });
}
