
import 'package:chopar_app/models/user.dart';

abstract class UserAuthState {}

class UserUnauthorizedState extends UserAuthState {}

class UserAuthOtpSent extends UserAuthState {
  String otpToken;
  UserAuthOtpSent({required this.otpToken}): assert(otpToken != null);
}

class UserAuthorized extends UserAuthState {
  UserData userData;
  UserAuthorized({required this.userData}) : assert(userData != null);
}

class UserIsLoading extends UserAuthState {}

class UserOtpRequireName extends UserAuthState {}