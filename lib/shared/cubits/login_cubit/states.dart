abstract class SocialLoginState {}

class SocialLoginIntialState extends SocialLoginState {}

class SocialLoginLoadingState extends SocialLoginState {}

class SocialLoginSuccessState extends SocialLoginState {
  final String uId;

  SocialLoginSuccessState({required this.uId});
}

class SocialLoginErrorState extends SocialLoginState {
  final String error;

  SocialLoginErrorState(this.error);
}

class SocialRegisterLoadingState extends SocialLoginState {}

class SocialRegisterSuccessState extends SocialLoginState {}

class SocialRegisterErrorState extends SocialLoginState {
  final String error;

  SocialRegisterErrorState(this.error);
}

class ChangePasswordAndIconState extends SocialLoginState {}
