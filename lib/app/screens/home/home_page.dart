import 'dart:async';
import 'dart:developer';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember_me/app/screens/home/logic/home_provider.dart';
import 'package:remember_me/app/screens/home/logic/home_state.dart';
import 'package:remember_me/app/screens/home/widgets/home_answer_page.dart';
import 'package:remember_me/app/screens/home/widgets/home_bottom_bar.dart';
import 'package:remember_me/constants.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final RecorderController recorderController = RecorderController();
  String? recordedFilePath;
  bool isRecording = false;
  Timer? timer;
  int recordedDuration = 0;
  // late Record _recorder;
  // late StreamSubscription<RecordState> _recordSub;
  // late StreamSubscription<List<int>> _audioStreamSubscription;
  // late StreamController<List<int>> _audioStreamController;
  // late SpeechToText _speechToText;
  // String _transcription = '';

  String get formattedDuration {
    final minutes = (recordedDuration / 60000).floor();
    final seconds = ((recordedDuration % 60000) / 1000).floor();
    final milliseconds = (recordedDuration % 1000) ~/ 100;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(1, '0')}';
  }

  @override
  void initState() {
    super.initState();
    recorderController.checkPermission();
  }

  @override
  void dispose() {
    recorderController.dispose();
    timer?.cancel();

    super.dispose();
  }

  void _stop(WidgetRef ref) async {
    setState(() {
      isRecording = false;
      recordedDuration = 0;
    });
    timer?.cancel();
    timer = null;

    recordedFilePath = await recorderController.stop();
    if (recordedFilePath == null) {
      return;
    }
    ref.read(homeProvider.notifier).saveRecording(recordedFilePath!);
  }

  void _record() async {
    setState(() {
      isRecording = true;
    });

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        recordedDuration += 100;
      });
    });
    recorderController.record();
  }

  Widget _buildRecordingPage() {
    return Column(
      key: const Key('recording_page'),
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child:
                      isRecording
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                width: 10,
                                height: 10,
                              ),
                              SizedBox(width: 10),
                              Text(
                                formattedDuration,
                                style: TextStyle(fontSize: 50),
                              ),
                            ],
                          )
                          : Text(
                            "Press the record button to save\n your memories",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AudioWaveforms(
                    recorderController: recorderController,
                    waveStyle: WaveStyle(
                      extendWaveform: true,
                      showMiddleLine: false,
                      scaleFactor: 50,
                      spacing: 5,
                      waveThickness: 2,
                    ),
                    size: Size(200, 150),
                  ),
                ),
              ),
              Expanded(child: SingleChildScrollView(child: Text(""))),
            ],
          ),
        ),
        SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[200],
                padding: EdgeInsets.all(20),
              ),
              onPressed: () {
                ref.read(homeProvider.notifier).pickImage();
              },
              icon: Icon(Icons.camera_alt),
              iconSize: 30,
            ),
            Center(
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: EdgeInsets.all(20),
                ),
                onPressed: () async {
                  if (recorderController.isRecording) {
                    _stop(ref);
                    return;
                  }
                  if (recorderController.hasPermission) {
                    _record();
                    return;
                  }
                },
                icon: Icon(isRecording ? Icons.stop : Icons.mic),
                iconSize: 70,
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[200],
                padding: EdgeInsets.all(20),
              ),
              onPressed: () {
                // Handle play button press
              },
              icon: Icon(Icons.history),
              iconSize: 30,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnsweringPage() {
    return HomeAnswerPage(key: const Key('answering_page'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 24),
            Text('Remember Me', style: TextStyle(fontSize: 16)),
            SizedBox(height: 17),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () {
                // Handle item tap
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle item tap
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('License'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LicensePage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.maxFinite),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  key: ValueKey<Key?>(child.key),
                  opacity: Tween<double>(
                    begin: 0.3,
                    end: 1.0,
                  ).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-0.03, 0.0),
                      end: const Offset(0.0, 0.0),
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              layoutBuilder: (currentChild, child) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    ...child,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child:
                  ref.watch(
                            homeProvider.select((state) => state.selectedTab),
                          ) ==
                          HomeTabs.record
                      ? _buildRecordingPage()
                      : _buildAnsweringPage(),
            ),
          ),
          SizedBox(height: 30),
          HomeBottomBar(),
        ],
      ),
    );
  }
}
