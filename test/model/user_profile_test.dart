import 'package:flutter_test/flutter_test.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/user_profile.dart';

void main() {
  group('UserProfile model', () {
    test('should create Map from UserProfile', () {
      final UserProfile userProfile = UserProfile(
          uid: 'a1d', displayName: 'Luca Beetz', imageUrl: 'imgUrl');

      expect(userProfile.toMap(), <String, dynamic>{
        USER_UID: 'a1d',
        USER_DISPLAY_NAME: 'Luca Beetz',
        USER_IMAGE_URL: 'imgUrl',
      });
    });

    test('should create UserProfile from Map', () {
      final Map<String, dynamic> userProfileMap = <String, dynamic>{
        USER_DISPLAY_NAME: 'Luca Beetz',
        USER_UID: 'a1d',
        USER_IMAGE_URL: 'imgUrl',
      };

      final UserProfile userProfile = UserProfile.fromMap(userProfileMap);

      expect(userProfile.uid, 'a1d');
      expect(userProfile.displayName, 'Luca Beetz');
      expect(userProfile.imageUrl, 'imgUrl');
    });
  });
}
