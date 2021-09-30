import 'package:chopar_app/cubit/user/state.dart';
import 'package:chopar_app/services/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserAuthState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserUnauthorizedState());

  Future<void> sendOtpToken() async {
    try {
      emit(UserIsLoading());
      final String otpToken = await userRepository.sendOtpToken();
      emit(UserAuthOtpSent(otpToken: otpToken));
    } catch(_) {
      emit(UserOtpRequireName());
    }
  }

}