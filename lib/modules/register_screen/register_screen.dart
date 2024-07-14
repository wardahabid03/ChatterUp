import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import '../../layout/social_layout/social_layout.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubits/register_cubit/cubit.dart';
import '../../shared/cubits/register_cubit/states.dart';
import '../../shared/network/local/cache_helper.dart';

// ignore: must_be_immutable
class SocialRegisterScreen extends StatelessWidget {
  SocialRegisterScreen({super.key});

  var emailContrlor = TextEditingController();
  var passwordContrlor = TextEditingController();
  var nameContrlor = TextEditingController();
  var phoneContrlor = TextEditingController();

  var globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterState>(
        listener: (context, state) {
          if (state is SocialRegisterErrorState) {
            showToast(
              state: ToastStates.error,
              text: state.error,
            );
          }
          if (state is SocialCreateUserSuccessState) {
            SocialacheHelper.saveData(key: 'uId', value: state.uId)
                .then((value) {
              userUId = state.uId;
              navigateTo(context, const SocialLayout(),backOrNo: false);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  // for validate
                  child: Form(
                    key: globalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'Rregister now to get a new friends',
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
                          inputType: TextInputType.phone,
                          validat: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone';
                            }
                            return null;
                          },
                          controller: phoneContrlor,
                          labelText: 'Phone Number',
                          prefixIcon: Icons.phone,
                        ),
                        const SizedBox(height: 15),
                        defaultFormFeild(
                          inputType: TextInputType.name,
                          validat: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                            return null;
                          },
                          controller: nameContrlor,
                          labelText: 'Full Name',
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 15),
                        defaultFormFeild(
                          controller: passwordContrlor,
                          labelText: 'Password',
                          prefixIcon: Icons.lock,
                          inputType: TextInputType.visiblePassword,
                          isPassword:
                              SocialRegisterCubit.get(context).showPassword,
                          suffixOnPressed: () =>
                              SocialRegisterCubit.get(context)
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
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (globalKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  email: emailContrlor.text,
                                  password: passwordContrlor.text,
                                  name: nameContrlor.text,
                                  phone: phoneContrlor.text,
                                );
                              }
                            },
                            text: 'REGISTER',
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
