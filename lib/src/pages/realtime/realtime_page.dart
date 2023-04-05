import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:temperature/src/constants/color.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:temperature/src/pages/Chart/chart_page.dart';
import 'package:temperature/src/widgets/drawer_widgets.dart';
import 'package:temperature/src/services/network_service.dart';
import 'package:temperature/src/pages/average/average_page.dart';
import 'package:temperature/src/pages/realtime/widget/temp_widget.dart';
import 'package:temperature/src/models/response_request_line_model.dart';
import 'package:temperature/src/widgets/dialog/login_custom_dialog.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({Key? key}) : super(key: key);

  @override
  State<RealtimePage> createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late AudioPlayer alarmPlayer;

  late AudioPlayer alarmA;
  late AudioPlayer alarmB;
  late AudioPlayer alarmD;

  bool isSwitched = true;

  bool isSwitchedA = true;
  bool isSwitchedB = true;
  bool isSwitchedD = true;

  Timer? alarmTimer;

  Timer? alarmTimerA;
  Timer? alarmTimerB;
  Timer? alarmTimerD;

  AppLifecycleState? _lastLifecycleState;
  StreamSubscription? _subscriptionRealTimeTemp;

  bool loopRealTimeTemp = true;
  bool soundSelect = true;

  bool soundSelectA = true;
  bool soundSelectB = true;
  bool soundSelectD = true;

  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;

  Future<void> playAlarm() async {
    await alarmPlayer.setLoopMode(LoopMode.all);
    alarmPlayer.play();
  }

  Future<void> playAlarmA() async {
    await alarmA.setLoopMode(LoopMode.all);
    alarmA.play();
  }

  Future<void> playAlarmB() async {
    await alarmB.setLoopMode(LoopMode.all);
    alarmB.play();
  }

  Future<void> playAlarmD() async {
    await alarmD.setLoopMode(LoopMode.all);
    alarmD.play();
  }

  Stream<dynamic> realTimeTempStream() async* {
    final result = await NetworkService.requestLine();

    yield result;
    log("**************** Initial Real Time Temp ****************");

    while (loopRealTimeTemp) {
      _subscriptionRealTimeTemp = await Future.delayed(const Duration(milliseconds: 2000));

      final result = await NetworkService.requestLine();

      List<ResponseRequestLineModel>? tempList = result;

      for (var item in tempList!) {
        if (item.lineId == "A") {
          if (item.drying.pv >= item.drying.max && item.drying.status == "on" ||
              item.curing.pv >= item.curing.max && item.curing.status == "on" ||
              item.drying.pv <= item.drying.min && item.drying.status == "on" ||
              item.curing.pv <= item.curing.min && item.curing.status == "on") {
            if (soundSelectA == true) {
              soundSelectA = false;
              playAlarmA();
              log("<<<<<<<<<<<<< Alarm A On >>>>>>>>>>>>");
              // alarmTimerA = Timer(const Duration(minutes: 1), () {
              //   log("<<<<<<<<<<<<< Alarm A On >>>>>>>>>>>>");
              //   playAlarmA();
              // });
            }
          } else {
            alarmTimerA?.cancel();
            soundSelectA = true;
            alarmA.stop();
            log("<<<<<<<<<<<<< Alarm A Off >>>>>>>>>>>>");
          }
        }

        if (item.lineId == "B") {
          if (item.drying.pv >= item.drying.max && item.drying.status == "on" ||
              item.curing.pv >= item.curing.max && item.curing.status == "on" ||
              item.drying.pv <= item.drying.min && item.drying.status == "on" ||
              item.curing.pv <= item.curing.min && item.curing.status == "on") {
            if (soundSelectB == true) {
              soundSelectB = false;
              playAlarmB();
              log("<<<<<<<<<<<<< Alarm B On >>>>>>>>>>>>");
              // alarmTimerB = Timer(const Duration(minutes: 1), () {
              //   log("<<<<<<<<<<<<< Alarm B On >>>>>>>>>>>>");
              //   playAlarmB();
              // });
            }
          } else {
            alarmTimerB?.cancel();
            soundSelectB = true;
            alarmB.stop();
            log("<<<<<<<<<<<<< Alarm B Off >>>>>>>>>>>>");
          }
        }

        if (item.lineId == "D") {
          if (item.drying.pv >= item.drying.max && item.drying.status == "on" ||
              item.curing.pv >= item.curing.max && item.curing.status == "on" ||
              item.drying.pv <= item.drying.min && item.drying.status == "on" ||
              item.curing.pv <= item.curing.min && item.curing.status == "on") {
            if (soundSelectD == true) {
              soundSelectD = false;
              playAlarmD();
              log("<<<<<<<<<<<<< Alarm D On >>>>>>>>>>>>");
              // alarmTimerD = Timer(const Duration(minutes: 1), () {
              //   log("<<<<<<<<<<<<< Alarm D On >>>>>>>>>>>>");
              //   playAlarmD();
              // });
            }
          } else {
            alarmTimerD?.cancel();
            soundSelectD = true;
            alarmD.stop();
            log("<<<<<<<<<<<<< Alarm D Off >>>>>>>>>>>>");
          }
        }
      }

      // List<ResponseRequestLineModel>? tempList = result;
      //
      // List dryingList = [];
      // List curingList = [];

      // for (var item in tempList!) {
      //   if (item.drying.pv >= item.drying.max || item.curing.pv >= item.curing.max || item.drying.pv <= item.drying.min || item.curing.pv <= item.curing.min) {
      //     dryingList.add(item.drying.pv);
      //     curingList.add(item.curing.pv);
      //   }
      // }
      //
      // int dryingLength = dryingList.length;
      // int curingLength = dryingList.length;
      //
      // if (dryingLength > 0 || curingLength > 0) {
      //   if (soundSelect == true) {
      //     soundSelect = false;
      //     alarmTimer = Timer(const Duration(minutes: 1), () {
      //       log("<<<<<<<<<<<<< Alarm On >>>>>>>>>>>>");
      //       playAlarm();
      //     });
      //   }
      // } else {
      //   alarmTimer?.cancel();
      //   soundSelect = true;
      //   alarmPlayer.stop();
      //   log("<<<<<<<<<<<<< Alarm Off >>>>>>>>>>>>");
      // }
      yield result;
    }
  }

  @override
  void initState() {
    alarmA = AudioPlayer()..setAsset('assets/audio/Alarm.mp3');
    alarmB = AudioPlayer()..setAsset('assets/audio/Alarm.mp3');
    alarmD = AudioPlayer()..setAsset('assets/audio/Alarm.mp3');

    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });
    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    alarmTimerA?.cancel();
    alarmTimerB?.cancel();
    alarmTimerD?.cancel();

    alarmA.dispose();
    alarmB.dispose();
    alarmD.dispose();

    VolumeController().removeListener();
    _subscriptionRealTimeTemp?.cancel();
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.paused == state) {
      loopRealTimeTemp = false;
      _subscriptionRealTimeTemp?.pause();
    }
    if (AppLifecycleState.resumed == state) {
      loopRealTimeTemp = true;
      _subscriptionRealTimeTemp?.resume();
    }
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.black87,
        appBar: _buildAppbar(),
        drawer: SizedBox(
          width: 800,
          child: drawerWidgets(
            () => Get.back(),
            () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ChartPage(),
                ),
              );
            },
            () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AveragePage(),
                ),
              );
            },
            () {
              Get.back();
              loginCustomDialog(Icons.login, Colors.white, "Login", "Enter password to setting page", true);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            Text(
                              "Realtime Temperature Data",
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.amber.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 60,
                                ),
                                onPressed: () {
                                  soundSelectA = true;
                                  soundSelectB = true;
                                  soundSelectD = true;
                                  setState(() {
                                    //todo
                                  });
                                }),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 16,
                        child: StreamBuilder(
                          stream: realTimeTempStream(),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              List<ResponseRequestLineModel>? data = snapshot.data;
                              if (data == null || data.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'Not have data !',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                );
                              }
                              return _buildStreamRealtimeTemp(data);
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                  ' Error data !',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              width: 130,
                              height: 70,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/logo_automation.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'Prepared by Automation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 80.0,
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FloatingActionButton(
                  heroTag: 'tag1',
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    isSwitchedA = !isSwitchedA;
                    if (isSwitchedA) {
                      alarmA.setVolume(1.0);
                      setState(() {
                        //todo
                      });
                    } else {
                      alarmA.setVolume(0.0);
                      setState(() {
                        //todo
                      });
                    }
                  },
                  backgroundColor: isSwitchedA == true ? CustomColors.primaryColor : Colors.grey,
                  child: isSwitchedA == true
                      ? const Icon(
                          Icons.volume_up_rounded,
                          size: 60.0,
                        )
                      : const Icon(
                          Icons.volume_off_rounded,
                          size: 60.0,
                        ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FloatingActionButton(
                  heroTag: 'tag2',
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    isSwitchedB = !isSwitchedB;
                    if (isSwitchedB) {
                      alarmB.setVolume(1.0);
                      setState(() {
                        //todo
                      });
                    } else {
                      alarmB.setVolume(0.0);
                      setState(() {
                        //todo
                      });
                    }
                  },
                  backgroundColor: isSwitchedB == true ? CustomColors.primaryColor : Colors.grey,
                  child: isSwitchedB == true
                      ? const Icon(
                          Icons.volume_up_rounded,
                          size: 60.0,
                        )
                      : const Icon(
                          Icons.volume_off_rounded,
                          size: 60.0,
                        ),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FloatingActionButton(
                  heroTag: 'tag2',
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    isSwitchedD = !isSwitchedD;
                    if (isSwitchedD) {
                      alarmD.setVolume(1.0);
                      setState(() {
                        //todo
                      });
                    } else {
                      alarmD.setVolume(0.0);
                      setState(() {
                        //todo
                      });
                    }
                  },
                  backgroundColor: isSwitchedD == true ? CustomColors.primaryColor : Colors.grey,
                  child: isSwitchedD == true
                      ? const Icon(
                          Icons.volume_up_rounded,
                          size: 60.0,
                        )
                      : const Icon(
                          Icons.volume_off_rounded,
                          size: 60.0,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildStreamRealtimeTemp(List<ResponseRequestLineModel>? data) {
    final tempList = data;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var item in tempList!)
          TempWidget(
            line: "Line ${item.lineId}",
            statusD: item.drying.status,
            pvD: item.drying.pv.toDouble(),
            svD: item.drying.sv.toDouble(),
            minD: item.drying.min.toInt(),
            maxD: item.drying.max.toInt(),
            updateD: item.drying.updateAt.toString(),
            statusC: item.curing.status,
            pvC: item.curing.pv.toDouble(),
            svC: item.curing.sv.toDouble(),
            minC: item.curing.min.toInt(),
            maxC: item.curing.max.toInt(),
            updateC: item.curing.updateAt.toString(),
          ),
      ],
    );
  }

  _buildAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: AppBar(
        leadingWidth: 80,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 60,
          ),
          onPressed: () => _key.currentState!.openDrawer(),
        ),
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                "assets/images/logo_jinpao2.png",
                fit: BoxFit.contain,
                height: 60,
              ),
            ),
          ),
        ),
        actions: [
          Center(
            child: Row(
              children: [
                Text(
                  "Temperature Profile  ",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ),
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }
}
