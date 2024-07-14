import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:audio_session/audio_session.dart';
import 'package:record/record.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../../../models/message_model/message_model.dart';
import '../../../models/social_user_model/social_user_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/cubits/layout_cubit/cubit.dart';
import '../../../shared/cubits/layout_cubit/states.dart';
import '../../../shared/style/icon_broken.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({required this.userModel, Key? key})
      : super(key: key);

  final SocialUserModel userModel;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

// class AudioPlayerWidget extends StatefulWidget {
//   final String audioPath;

//   const AudioPlayerWidget({Key? key, required this.audioPath}) : super(key: key);

//   @override
//   // _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
// }

// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   // late AudioPlayer _audioPlayer;

// @override
// void initState() {
//   super.initState();
//   _audioPlayer = AudioPlayer();
// }

// @override
// void dispose() {
//   _audioPlayer.dispose();
//   super.dispose();
// }

// void _playAudio() async {
//   try {

//      Source UrlSource = UrlSource(audioPath);
//      await AudioPlayer.play(UrlSource);
//     // await _audioPlayer.play(UrlSource(widget.audioPath));
//     // If no exception is thrown, assume audio is playing successfully
//     print('Audio playing');
//   } catch (e) {
//     print('Error playing audio: $e');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.play_arrow),
//       onPressed: _playAudio,
//     );
//   }
//  }

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  late TextEditingController messageController;
  // late FlutterSoundRecorder _flutterSoundRecorder;

  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = "";
  late RecorderController recorderController;
  bool isAudioPlaying = false;
  late Map<MessageModel, bool> isPlayingMap;
 dynamic Duration;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
    messageController = TextEditingController();
    recorderController = RecorderController();
    isPlayingMap = {};
   
    // _flutterSoundRecorder = FlutterSoundRecorder();

    // _initAudioRecorder();
  }

  @override
  void dispose() {
    // _flutterSoundRecorder.closeRecorder();
    audioRecord.dispose();
    audioPlayer.dispose();

    messageController.dispose();
    super.dispose();
  }

  // void _initAudioRecorder() async {
  //   await _flutterSoundRecorder.openRecorder();
  //   final session = await AudioSession.instance;
  //   await session.configure(AudioSessionConfiguration(
  //     avAudioSessionCategoryOptions:
  //         AVAudioSessionCategoryOptions.allowBluetooth |
  //             AVAudioSessionCategoryOptions.defaultToSpeaker,
  //     avAudioSessionMode: AVAudioSessionMode.spokenAudio,
  //     avAudioSessionRouteSharingPolicy:
  //         AVAudioSessionRouteSharingPolicy.defaultPolicy,
  //     avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
  //     androidAudioAttributes: const AndroidAudioAttributes(
  //       contentType: AndroidAudioContentType.speech,
  //       flags: AndroidAudioFlags.none,
  //       usage: AndroidAudioUsage.voiceCommunication,
  //     ),
  //     androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
  //     androidWillPauseWhenDucked: true,
  //   ));
  //   _flutterSoundRecorder.setSubscriptionDuration(
  //     const Duration(milliseconds: 120),
  //   );
  // }

  Future<void> _startRecording() async {
    try {
      print(
          "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}");
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
      // await _flutterSoundRecorder.startRecorder(
      //   codec: Codec.aacADTS,
      //   sampleRate: 44100,
      //   bitRate: 48000,
      //   toFile: "voice.aac",
      // );

      await recorderController.record(path: pathR); // Path is optional
    } catch (e) {
      print("Error Start Recording :  $e");
    }
  }

  dynamic pathR;

  Future<dynamic> _stopRecording() async {
    try {
      print(
          "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
      final dynamic path = await audioRecord.stop();
      print(
          "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      print(path);
      setState(() {
        isRecording = false;
        audioPath = path!;
        print(path);
        print(audioPath);
      });

      pathR = await recorderController.stop(false);
      return audioPath; // Return an empty string if path is null
    } catch (err) {
      print('Error stopping recording: $err');
      return null;
    }
  }

  void _playAudio(String? audioP,MessageModel messageModel) async {
    try {
      if (audioP != null) {
        print("Playing audio : $audioP");

        Source urlSource = UrlSource(audioP);
        print("audio Url source: $urlSource");
        await audioPlayer.play(urlSource);

        // Update the state to indicate that audio is playing
        setState(() async{
         isPlayingMap[messageModel] = true;
// await Future.delayed(Duration(seconds: 10)); 
        });

        // Listen for when the audio finishes playing
        audioPlayer.onPlayerComplete.listen((event) {
          // Update the state when the audio finishes playing
          setState(() async{
            
          
           isPlayingMap[messageModel] = false;
       
          });
        });


 dynamic State = audioPlayer.state;
 print("State : $State");

 dynamic Mode = audioPlayer.mode;
 print("Mode : $Mode");
        // Duration = await audioPlayer.getDuration;
        // print("Duration : $Duration");

        // If no exception is thrown, assume audio is playing successfully
        print('Audio playing');
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<bool> hasPermission(Permission permission) async {
    final status = await permission.status;
    return status == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getmessages(receiverId: widget.userModel.uId!);
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.userModel.image!),
              ),
              const SizedBox(width: 15),
              Text(widget.userModel.name!),
            ],
          ),
        ),
        body: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ConditionalBuilder(
                    condition: SocialCubit.get(context).messages.isNotEmpty,
                    builder: (context) => Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var message =
                              SocialCubit.get(context).messages[index];
                          if (SocialCubit.get(context).userModel!.uId ==
                              message.senderId) {
                            return buildMyMessage(message);
                          }
                          return buildOtherMessage(message);
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: SocialCubit.get(context).messages.length,
                      ),
                    ),
                    fallback: (context) => const Expanded(
                      child: Center(
                        child: Text('say hi'),
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: isRecording
                        ? Row(
                            children: [
                              AudioWaveforms(
                                enableGesture: true,
                                recorderController: recorderController,
                                size: Size(
                                  MediaQuery.of(context).size.width / 2,
                                  50,
                                ),
                                waveStyle: const WaveStyle(
                                  waveColor: Color.fromARGB(255, 9, 59, 117),
                                  extendWaveform: true,
                                  showMiddleLine: false,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(left: 28),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                              ),
                              IconButton(
                                color: defaultColor,
                                onPressed: () async {
                                  final String? audioPath =
                                      await _stopRecording();
                                  if (audioPath != null) {
                                    // Send audio message
                                    SocialCubit.get(context).sendMessage(
                                      receiverId: widget.userModel.uId!,
                                      dateTime: DateTime.now().toString(),
                                      audioPath: audioPath,
                                    );
                                  }
                                },
                                icon: Icon(IconBroken.Send),
                                // color: Colors.white,
                                // Customize color as needed
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: TextFormField(
                                    controller: messageController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'type your message...'),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _startRecording();
                                },
                                icon: Icon(IconBroken.Voice_2),
                                color: isRecording ? Colors.purple : null,
                              ),
                              Container(
                                height: 50,
                                color: defaultColor,
                                child: MaterialButton(
                                  onPressed: () {
                                    SocialCubit.get(context).sendMessage(
                                      receiverId: widget.userModel.uId!,
                                      dateTime: DateTime.now().toString(),
                                      text: messageController.text,
                                    );
                                    messageController.clear();
                                  },
                                  child: const Icon(
                                    IconBroken.Send,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                  )
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildMyMessage(MessageModel messageModel) => Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(.2),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            ),
          ),
          child: messageModel.text != null
              ? Text(messageModel.text!)
              : messageModel.audioPath != null
                  ? Container(
                      width: MediaQuery.of(context).size.width *
                          0.6, // Adjust the percentage as needed
                      child: Row(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/images/waveform.png',
                              width: 10,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              isPlayingMap[messageModel] == true ? Icons.pause : Icons.play_arrow,
                            ),
                            onPressed: () => _playAudio(messageModel.audioPath, messageModel),
                          ),
                        ],
                      ),
                    )
                  : Container(),
        ),
      );

  Widget buildOtherMessage(MessageModel messageModel) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            ),
          ),
          child: messageModel.text != null
              ? Text(messageModel.text!)
              : messageModel.audioPath != null
                  ? Container(
                      width: MediaQuery.of(context).size.width *
                          0.6, // Adjust the percentage as needed
                      child: Row(
                        children: [
                           IconButton(
                            icon: Icon(
                             isPlayingMap[messageModel] == true ? Icons.pause : Icons.play_arrow,
                            ),
                            onPressed: () => _playAudio(messageModel.audioPath, messageModel),
                          ),
                          Expanded(
                            child: Image.asset(
                              'assets/images/waveform.png',
                              width: 10,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // SizedBox(width: 8),
                         
                        ],
                      ),
                    )
                  : Container(),
        ),
      );
}
