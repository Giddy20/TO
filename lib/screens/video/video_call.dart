import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../widgets/custom_app_bar.dart';

String get appId {
  // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
  return const String.fromEnvironment('TEST_APP_ID',
      defaultValue: '997a347b092146889f186f49f36c4661');
}

/*
/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
String get token {
  // Allow pass a `token` as an environment variable with name `TEST_TOEKN` by using --dart-define
  return const String.fromEnvironment('TEST_TOEKN',
      defaultValue:
          '006997a347b092146889f186f49f36c4661IACUL0lOtbmJ0lbFbKseH6kR9DP2juAHKNG0bBWwqPMI9ZpjTicAAAAAEABrDG+d95xLYgEAAQD3nEti');
}

/// Your channel ID
String get channelId {
  // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
  return const String.fromEnvironment(
    'TEST_CHANNEL_ID',
    defaultValue: 'Testing',
  );
}
*/
/// Your int user ID
const int uid = 0;

/// Your user ID for the screen sharing
const int screenSharingUid = 10;

/// Your string user ID
const String stringUid = '0';

class VideoCall extends StatefulWidget {
  final String channelName;
  const VideoCall(this.channelName, {Key? key}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late final RtcEngine _engine;
  bool loading = false;
  String channelName = '';

  String token = '';

  bool isJoined = false, switchCamera = true, switchRender = true;
  List<int> remoteUid = [];
  bool _isRenderSurfaceView = false;

  @override
  void initState() {
    super.initState();
    //channelName = widget.channelName;
    channelName = 'Testing';
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  void getToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getToken');
      final results = await callable({'channelName': channelName});
      if (results.data != 'error') {
        setState(() {
          loading = false;
        });
        token = results.data;
        _initEngine();
      } else {
        Constants.showMessage(
            context, "Video call is unavailable, please try again later");
      }
    }
  }

  Future<void> _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  void _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        log('warning $warningCode');
      },
      error: (errorCode) {
        log('error $errorCode');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        log('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        log('userJoined  $uid $elapsed');
        setState(() {
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        log('userOffline  $uid $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      },
      leaveChannel: (stats) {
        log('leaveChannel ${stats.toJson()}');
        updateChat(false);
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannel(token, channelName, null, uid).then((value) {
      updateChat(true);
    }).catchError((onError) {
      log(onError);
    });
    //await _engine.joinChannel(token, widget.channelName, null, uid);
  }

  void updateChat(bool joined) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      Timestamp timestamp = Timestamp.now();
      String messageID =
          FirebaseFirestore.instance.collection("chatMessages").doc().id;
      SharedPreferences prefs = await Constants.getPrefs();
      String firstname = prefs.getString('firstname') ?? '';
      String message =
          "$firstname has ${joined ? 'started' : 'ended'} a video call";

      batch.update(
        FirebaseFirestore.instance
            .collection("chatRooms")
            .doc(widget.channelName),
        {
          'lastMessageBy': user.uid,
          'lastMessage': message,
          'lastMessageID': messageID,
          'timestamp': timestamp,
          'isVideo': joined,
        },
      );
      batch.set(
        FirebaseFirestore.instance
            .collection("chatMessages")
            .doc(widget.channelName)
            .collection("Messages")
            .doc(messageID),
        {
          'sender': user.uid,
          'content': message,
          'type': 'text',
          'timestamp': timestamp,
        },
      );
      batch.commit().then((value) {}).catchError(
        (onError) {
          log("Error");
        },
      );
    }
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      log('switchCamera $err');
    });
  }

  _switchRender() {
    /*
    setState(() {
      switchRender = !switchRender;
      remoteUid = List.of(remoteUid.reversed);
    });
    */
  }

  void goBack() async {
    if (!loading) {
      try {
        await _leaveChannel();
      } catch (e) {
        log(e.toString());
      }
      Navigator.of(context).pop();
    }
  }

  Widget getBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: goBack,
      color: Colors.white,
    );
  }

  List<Widget> getActions() {
    List<Widget> actions = [];
    actions.add(
      IconButton(
        onPressed: _switchCamera,
        icon: const Icon(
          Icons.switch_camera_rounded,
          color: Colors.white,
        ),
      ),
    );

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: CustomAppBar(getBackButton(), "Video Call", getActions()),
          preferredSize: Size(MediaQuery.of(context).size.width, appBarHeight),
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  _renderVideo(),
                  if (defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: isJoined ? _leaveChannel : _joinChannel,
                        child: Text('${isJoined ? 'End' : 'Start'} video'),
                        style: ElevatedButton.styleFrom(primary: goldColor),
                      ),
                    )
                ],
              ),
      ),
    );
  }

  _renderVideo() {
    if (remoteUid.isEmpty) {
      return Container(
        child: (kIsWeb || _isRenderSurfaceView)
            ? const rtc_local_view.SurfaceView(
                zOrderMediaOverlay: true,
                zOrderOnTop: true,
              )
            : const rtc_local_view.TextureView(),
      );
    } else {
      return Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.of(
                remoteUid.map(
                  (e) => GestureDetector(
                    onTap: _switchRender,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: (kIsWeb || _isRenderSurfaceView)
                          ? rtc_remote_view.SurfaceView(
                              uid: e,
                              channelId: channelName,
                            )
                          : rtc_remote_view.TextureView(
                              uid: e,
                              channelId: channelName,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 120,
              width: 120,
              child: (kIsWeb || _isRenderSurfaceView)
                  ? const rtc_local_view.SurfaceView(
                      zOrderMediaOverlay: true,
                      zOrderOnTop: true,
                    )
                  : const rtc_local_view.TextureView(),
            ),
          ),
        ],
      );
    }
  }
/*
  _renderVideo() {
    return Stack(
      children: [
        Container(
          child: (kIsWeb || _isRenderSurfaceView)
              ? const rtc_local_view.SurfaceView(
                  zOrderMediaOverlay: true,
                  zOrderOnTop: true,
                )
              : const rtc_local_view.TextureView(),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.of(remoteUid.map(
                (e) => GestureDetector(
                  onTap: _switchRender,
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: (kIsWeb || _isRenderSurfaceView)
                        ? rtc_remote_view.SurfaceView(
                            uid: e,
                            channelId: channelName,
                          )
                        : rtc_remote_view.TextureView(
                            uid: e,
                            channelId: channelName,
                          ),
                  ),
                ),
              ),),
            ),
          ),
        ),


      ],
    );
  }
  */
}
