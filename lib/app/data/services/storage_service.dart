import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  final GetStorage _box = GetStorage();

  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyIsFirstTime = 'is_first_time';

  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  // Auth Token
  String? get token => _box.read<String>(_keyToken);
  Future<void> saveToken(String token) async => await _box.write(_keyToken, token);
  Future<void> removeToken() async => await _box.remove(_keyToken);

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  // User Data
  Map<String, dynamic>? get user => _box.read<Map<String, dynamic>>(_keyUser);
  Future<void> saveUser(Map<String, dynamic> userMap) async => await _box.write(_keyUser, userMap);
  Future<void> removeUser() async => await _box.remove(_keyUser);

  // Onboarding Status
  bool get isFirstTime => _box.read<bool>(_keyIsFirstTime) ?? true;
  Future<void> setFirstTimeCompleted() async => await _box.write(_keyIsFirstTime, false);

  // Logout
  Future<void> logout() async {
    await removeToken();
    await removeUser();
  }
}
