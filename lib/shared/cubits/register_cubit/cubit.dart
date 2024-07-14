import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/social_user_model/social_user_model.dart';
import 'states.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterState> {
  SocialRegisterCubit() : super(SocialRegisterIntialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  //register
  userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      print('error from register $error');
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  //save user data in firestore
  userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) {
    SocialUserModel model = SocialUserModel(
      email: email,
      name: name,
      phone: phone,
      bio: 'write your bio ...',
      uId: uId,
      cover:
          'https://img.freepik.com/free-photo/excited-curly-haired-girl-sunglasses-pointing-right-showing-way_176420-20192.jpg?w=996&t=st=1709222732~exp=1709223332~hmac=97e4896259c9234bded3b91d0d881740b6d650b098a6b108e1b3d39b868bf715',
      image:
          'https://img.freepik.com/free-vector/hand-drawn-caricature-illustration_23-2149831816.jpg?t=st=1709219686~exp=1709223286~hmac=dd85624837e88fabae87cef7725f0b2d60592a56746b2bfbc068d138d3502f75&w=740',
      isEmailVerified: false,
    );
    //send data to save in firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState(uId: uId));
    }).catchError((error) {
      print('error from firestore $error');
      emit(SocialCreateUserErrorState(error));
    });
  }

  bool showPassword = true;

  toggleIconAndPassword() {
    showPassword = !showPassword;
    emit(ChangePasswordAndIconRegisterState());
  }
}
