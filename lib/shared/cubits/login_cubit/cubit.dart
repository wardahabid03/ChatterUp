import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class SocialLoginCubit extends Cubit<SocialLoginState> {
  SocialLoginCubit() : super(SocialLoginIntialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(SocialLoginSuccessState(uId: value.user!.uid));
    }).catchError((onError) {
      emit(SocialLoginErrorState(onError.toString()));
    });
  }

  bool showPassword = true;

  toggleIconAndPassword() {
    showPassword = !showPassword;
    emit(ChangePasswordAndIconState());
  }
}
