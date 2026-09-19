import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../models/user_profile.dart';

class ProfileApi {
  const ProfileApi._();

  static Future<UserProfile> getMyProfile() {
    return ApiResult.unwrap(
      () => ApiClient.instance.get('/api/users/me'),
      (data) => UserProfile.fromJson(data as Map<String, dynamic>),
    );
  }

  static Future<UserProfile> updateNickname(String nickname) {
    return ApiResult.unwrap(
      () => ApiClient.instance.patch(
        '/api/users/me/nickname',
        data: {'nickname': nickname},
      ),
      (data) => UserProfile.fromJson(data as Map<String, dynamic>),
    );
  }

  static Future<UserProfile> updateNotificationPreference(bool enabled) {
    return ApiResult.unwrap(
      () => ApiClient.instance.patch(
        '/api/users/me/notification-preference',
        data: {'enabled': enabled},
      ),
      (data) => UserProfile.fromJson(data as Map<String, dynamic>),
    );
  }

  static Future<void> withdraw() {
    return ApiResult.unwrap(
      () => ApiClient.instance.delete('/api/users/me'),
      (_) {},
    );
  }
}
