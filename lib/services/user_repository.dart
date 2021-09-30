import 'package:chopar_app/cubit/user/state.dart';
import 'package:chopar_app/services/user_api_provider.dart';

class UserRepository {
  UserProvider _userProvider = UserProvider();
  Future<String> sendOtpToken() => _userProvider.sendOtpCode();
}