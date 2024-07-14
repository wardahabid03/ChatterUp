import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/social_layout/social_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubits/login_cubit/cubit.dart';
import '../../shared/cubits/login_cubit/states.dart';
import '../../shared/network/local/cache_helper.dart';
import '../register_screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  var passwordContrlor = TextEditingController();

  var emailContrlor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SocialLoginCubit(),
        child: BlocConsumer<SocialLoginCubit, SocialLoginState>(
          listener: (context, state) {
            if (state is SocialLoginErrorState) {
              showToast(
                state: ToastStates.error,
                text: state.error,
              );
            }
            if (state is SocialLoginSuccessState) {
              SocialacheHelper.saveData(key: 'uId', value: state.uId)
                  .then((value) {
                userUId = state.uId;
                print("????????????????????");
                print(userUId);
                navigateTo(context, const SocialLayout(),backOrNo: false);
              });
            }
          },
          builder: (context, state) => Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  // for validate
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'Login now to get a new friends',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(height: 20),
                        defaultFormFeild(
                          inputType: TextInputType.emailAddress,
                          validat: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                            return null;
                          },
                          controller: emailContrlor,
                          labelText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 15),
                        defaultFormFeild(
                          controller: passwordContrlor,
                          labelText: 'Password',
                          prefixIcon: Icons.lock,
                          inputType: TextInputType.visiblePassword,
                          isPassword:
                              SocialLoginCubit.get(context).showPassword,
                          suffixOnPressed: () => SocialLoginCubit.get(context)
                              .toggleIconAndPassword(),
                          validat: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                  email: emailContrlor.text,
                                  password: passwordContrlor.text,
                                  context: context,
                                );
                              }
                            },
                            text: 'login',
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account? '),
                            defaultTextButton(
                              onPress: () {
                                navigateTo(context, SocialRegisterScreen());
                              },
                              text: 'register now',
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
