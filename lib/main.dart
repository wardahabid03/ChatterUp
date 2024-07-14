import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/social_layout/social_layout.dart';
import 'modules/login_screen/login_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/components/components.dart';
import 'shared/components/constants.dart';
import 'shared/cubits/layout_cubit/cubit.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/style/themes.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print((message.data.toString()));

  showToast(state: ToastStates.warning, text: 'from BackgroundHandler');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
         options: const FirebaseOptions(
          apiKey: 'AIzaSyByBxe7ALXnmEu6eOGa87EcPyH8XigA-uc',
          appId: '1:415790923782:android:bff6c3e8b6fedcaeb54387',
          messagingSenderId: '415790923782',
          projectId: 'social-media-4a4ef',
          storageBucket: "social-media-4a4ef.appspot.com",
)

        )
      : await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  print('token $token');


  //foreground fcm
  FirebaseMessaging.onMessage.listen((event) {
    print((event.data.toString()));
    showToast(state: ToastStates.warning, text: 'from onMessage');
  });

  //when clic to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print((event.data.toString()));
    showToast(state: ToastStates.warning, text: 'from onMessageOpenedApp');
  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();

  await SocialacheHelper.init();

  Widget widget;
  userUId = SocialacheHelper.getData(key: 'uId') ?? '';

  if (userUId == '') {
    widget = const LoginScreen();
  } else {
    widget = const SocialLayout();
  }
  runApp(MyApp(widget: widget));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.widget});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social App 2024',
        theme: lightTheme,
        home: widget,
      ),
    );
  }
}
