import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:sign_speak/firebase_db/firebase_db.dart';

class ListenerCalling extends StatefulWidget {
  String localUserID = (Random().nextInt(99999) + 10000).toString();
  final String user;
  final String roomID;
  final String localUserName;

  ListenerCalling({required this.user, required this.roomID, super.key}) : localUserName = user;

  @override
  State<ListenerCalling> createState() => _ListenerCallingState();
}

class _ListenerCallingState extends State<ListenerCalling> {
  bool isMicOn = true;
  Widget? localView;
  Widget? remoteView;
  int? localViewID;
  int? remoteViewID;
  bool _engineInitialized = false;

  @override
  void initState() {
    super.initState();
    _requestMicPermission();
    startListenEvent();
    listenForEndCall();
  }

  Future<void> _requestMicPermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      await initializeEngine();
      await loginRoom();
    } else if (status.isDenied) {
      print('Microphone Permission Denied');
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> initializeEngine() async {
    WidgetsFlutterBinding.ensureInitialized();
    const int appID = 884839325;
    const String appSign = "5aae21a9e6e3b602e5eee833c4f4a722542264e7d7f49903d9fd1d2cd53e0250";

    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
      appID,
      ZegoScenario.Default,
      appSign: appSign,
    ));
    setState(() {
      _engineInitialized = true;
    });
    print("Zego engine initialized.");
  }

  void startListenEvent() {
    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, streamList, extendedData) {
      if (updateType == ZegoUpdateType.Add) {
        for (final stream in streamList) {
          print("Stream added: ${stream.streamID}");
          startPlayStream(stream.streamID);
        }
      } else if (updateType == ZegoUpdateType.Delete) {
        for (final stream in streamList) {
          print("Stream removed: ${stream.streamID}");
          stopPlayStream(stream.streamID);
        }
      }
    };
  }

  Future<void> startPlayStream(String streamID) async {
    print("Starting to play audio stream: $streamID");
    await ZegoExpressEngine.instance.startPlayingStream(streamID);
  }

  Future<void> stopPlayStream(String streamID) async {
    print("Stopping stream: $streamID");
    await ZegoExpressEngine.instance.stopPlayingStream(streamID);
  }

  Future<ZegoRoomLoginResult> loginRoom() async {
    if (!_engineInitialized) {
      print("Engine not initialized yet.");
      return Future.error("Engine not initialized.");
    }

    final user = ZegoUser(widget.localUserID, widget.localUserName);
    final roomConfig = ZegoRoomConfig.defaultConfig()..isUserStatusNotify = true;

    final roomID = widget.roomID;
    return ZegoExpressEngine.instance
        .loginRoom(roomID, user, config: roomConfig)
        .then((loginRoomResult) {
      if (loginRoomResult.errorCode == 0) {
        print("Logged in successfully to room: $roomID");
        startPublish();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${loginRoomResult.errorCode}')),
        );
      }
      return loginRoomResult;
    }).catchError((error) {
      print("Error in loginRoom: $error");
      return Future.error(error);
    });
  }

  Future<void> startPublish() async {
    await ZegoExpressEngine.instance.startPublishingStream(widget.localUserID);
  }
  Future<void> logoutRoom() async {
    ZegoExpressEngine.instance.logoutRoom(widget.roomID);
    print("Logged out from the room.");
  }


void endCallForAll() async {
  if (_engineInitialized) {
    await ZegoExpressEngine.instance.sendBroadcastMessage(
      widget.roomID,
      "END_CALL",
    );

    // Delete room from Firestore
    await FirestoreService.deleteSessionCode(widget.roomID);

    await logoutRoom();
    Navigator.pushNamed(context, '/endmeeting', arguments: widget.user);
  }
}


void listenForEndCall() {
  ZegoExpressEngine.onIMRecvBroadcastMessage = (roomID, messageList) {
    for (var message in messageList) {
      print("Received message: ${message.message}");
      if (message.message == "END_CALL") {
        logoutRoom();
        Navigator.pushNamed(context, '/endmeeting', arguments: widget.user);
        FirestoreService.deleteSessionCode(roomID);
      }
    }
  };
}

  @override
  void dispose() {
    super.dispose();
    ZegoExpressEngine.instance.stopPreview();
    ZegoExpressEngine.instance.stopPublishingStream();
    ZegoExpressEngine.instance.logoutRoom(widget.roomID);
    ZegoExpressEngine.destroyEngine();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

// PI calling of voice
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          children: [
           
            Container(
              height: height * 0.9,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: IconButton(
                      onPressed: () async {
                        if (isMicOn) {
                          // Mute the mic
                          await ZegoExpressEngine.instance.muteMicrophone(true);
                        } else {
                          // Unmute the mic
                          await ZegoExpressEngine.instance.muteMicrophone(false);
                        }
                        setState(() {
                          isMicOn = !isMicOn;
                        });
                      },
                      icon: FaIcon(
                        isMicOn ? FontAwesomeIcons.microphone : FontAwesomeIcons.microphoneSlash,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: IconButton(
                      onPressed: () async {
                        endCallForAll();
                      },
                      icon: const Icon(Icons.call_end, size: 30, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
