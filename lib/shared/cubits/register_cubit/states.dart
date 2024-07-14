abstract class SocialRegisterState {}

class SocialRegisterIntialState extends SocialRegisterState {}

class SocialRegisterLoadingState extends SocialRegisterState {}

class SocialRegisterSuccessState extends SocialRegisterState {}

class SocialRegisterErrorState extends SocialRegisterState {
  final String error;

  SocialRegisterErrorState(this.error);
}

class SocialCreateUserSuccessState extends SocialRegisterState {
  final String uId;

  SocialCreateUserSuccessState({required this.uId});
}

class SocialCreateUserErrorState extends SocialRegisterState {
  final String error;

  SocialCreateUserErrorState(this.error);
}

class ChangePasswordAndIconRegisterState extends SocialRegisterState {}
