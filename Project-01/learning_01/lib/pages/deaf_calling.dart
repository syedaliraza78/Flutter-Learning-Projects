import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:sign_speak/firebase_db/firebase_db.dart';

class DeafCalling extends StatefulWidget {
  String localUserID = (Random().nextInt(99999) + 10000).toString();
  final String user;
  final String roomID;
  final String localUserName;

  DeafCalling({required this.user, required this.roomID, super.key})
      : localUserName = user;

  @override
  State<DeafCalling> createState() => _DeafCallingState();
}

class _DeafCallingState extends State<DeafCalling> {
  bool isMicOn = true;
  Widget? localView;
  Widget? remoteView;
  int? localViewID;
  int? remoteViewID;
  bool _engineInitialized = false;

  List<String> imageList = [
    "dataset/image1.jpg",
    "dataset/image2.jpg",
    "dataset/image3.jpg",
    "dataset/image4.jpg",
    "dataset/image5.jpg"
  ]; // List of images
  int imageIndex = 0; 
  late Timer _imageChangeTimer;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    startListenEvent();
    _startImageChangeTimer(); 
    listenForEndCall();
  }

  void _startImageChangeTimer() {
    _imageChangeTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        imageIndex = (imageIndex + 1) % imageList.length;
      });
    });
  }

  Future<void> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      await initializeEngine();
      await loginRoom();
    } else if (status.isDenied) {
      print('Camera Permission Denied');
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> initializeEngine() async {
    WidgetsFlutterBinding.ensureInitialized();
    const int appID = 884839325;
    const String appSign =
        "5aae21a9e6e3b602e5eee833c4f4a722542264e7d7f49903d9fd1d2cd53e0250";

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
    ZegoExpressEngine.onRoomStreamUpdate =
        (roomID, updateType, streamList, extendedData) {
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
    print("Starting to play stream: $streamID");
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      remoteViewID = viewID;
      final canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
    }).then((canvasViewWidget) {
      setState(() => remoteView = canvasViewWidget);
    }).catchError((error) {
      print("Error in startPlayStream: $error");
    });
  }

  Future<void> stopPlayStream(String streamID) async {
    ZegoExpressEngine.instance.stopPlayingStream(streamID);
    if (remoteViewID != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
      setState(() {
        remoteViewID = null;
        remoteView = null;
      });
    }
  }

  Future<ZegoRoomLoginResult> loginRoom() async {
    if (!_engineInitialized) {
      print("Engine not initialized yet.");
      return Future.error("Engine not initialized.");
    }

    final user = ZegoUser(widget.localUserID, widget.localUserName);
    final roomConfig = ZegoRoomConfig.defaultConfig()
      ..isUserStatusNotify = true;

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
    ZegoExpressEngine.instance.createCanvasView((viewID) {
      localViewID = viewID;
      final canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
      ZegoExpressEngine.instance.startPreview(canvas: canvas);
      ZegoExpressEngine.instance.startPublishingStream(widget.localUserID);
    }).then((canvasViewWidget) {
      setState(() {
        localView = canvasViewWidget;
      });
    }).catchError((error) {
      print("Error in startPublish: $error");
    });
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
    _imageChangeTimer.cancel(); // Cancel the timer on dispose
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
// above api
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.6, top: height * 0.08),
              child: Container(
                width: width * 0.3,
                height: height * 0.2,
                child: localView ?? Container(color: Colors.black),
              ),
            ),
            // Main content area for the changing images
            Container(
                    padding: EdgeInsets.only(top: height * 0.1),
              height: height * 0.6,
              width: width * 0.7,
              child: Column(
                children: [
                  // Main Image Display
                  Container(
                    width: width,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageList[imageIndex]), // Displaying current image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: IconButton(
                      onPressed: () async {
                        if (localView != null) {
                          await stopPlayStream(
                              widget.localUserID); 
                          setState(() {
                            localView = null; 
                          });
                        } else {
                          await startPublish(); 
                          setState(() {
                            localView = Container(
                                color: Colors
                                    .black); 
                          });
                        }
                      },
                      icon: FaIcon(
                        localView != null
                            ? FontAwesomeIcons.video
                            : FontAwesomeIcons.videoSlash,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: IconButton(
                      onPressed: () async {
                        endCallForAll();
                      },
                      icon: const Icon(Icons.call_end,
                          size: 30, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}