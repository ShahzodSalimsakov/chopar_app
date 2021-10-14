import 'package:chopar_app/models/user.dart';
import 'package:hive/hive.dart';

class UserRepository {

  bool isAuthorized() {
    User? currentUser = Hive.box<User>('user').get('user');
    return currentUser != null;
  }
}