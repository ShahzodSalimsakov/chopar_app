import 'package:chopar_app/cubit/user/cubit.dart';
import 'package:chopar_app/cubit/user/state.dart';
import 'package:chopar_app/services/user_repository.dart';
import 'package:chopar_app/widgets/auth/modal.dart';
import 'package:chopar_app/widgets/home/ChooseCity.dart';
import 'package:chopar_app/widgets/profile/PagesList.dart';
import 'package:chopar_app/widgets/profile/UserName.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileIndex extends StatelessWidget {
  final userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>(
      create: (context) => UserCubit(userRepository),
      child: BlocConsumer<UserCubit, UserAuthState>(
        listener: (context, state) {
          if (state is UserUnauthorizedState) {
            Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (context) => AuthModal(),
                fullscreenDialog: true,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserUnauthorizedState) {
            return Container(
              margin: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  ChooseCity(),
                  UserName(),
                  PagesList()
                ],
              ),
            );
          }
          return Container(
            child: Column(
              children: [
                ChooseCity(),
                UserName(),
                PagesList()
              ],
            ),
          );
        },
      ),
    );
  }
}
