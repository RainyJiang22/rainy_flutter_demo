import 'package:first_flutter_demo/pages/stopwatch/build_tools.dart';
import 'package:first_flutter_demo/pages/stopwatch/model/time_record.dart';
import 'package:first_flutter_demo/pages/stopwatch/record_panel.dart';
import 'package:first_flutter_demo/pages/stopwatch/stop_watch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({super.key});

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  StopWatchType _type = StopWatchType.none;
  Duration _duration = Duration.zero;
  late Ticker _ticker;
  List<TimeRecord> _record = [];

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick);
  }

  Duration dt = Duration.zero;
  Duration lastDuration = Duration.zero;

  void _onTick(Duration elasped) {
    setState(() {
      dt = elasped - lastDuration;
      _duration += dt;
      lastDuration = elasped;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: buildActions(),
      ),
      body: Column(
        children: [buildStopWatchPanel(), buildRecordPanel(), buildTools()],
      ),
    );
  }

  List<Widget> buildActions() {
    return [
      PopupMenuButton<String>(
        itemBuilder: _buildItem,
        onSelected: _onSelectItem,
        icon: const Icon(Icons.more_vert_outlined, color: Color(0xff262626)),
        position: PopupMenuPosition.under,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ];
  }

  List<PopupMenuEntry<String>> _buildItem(BuildContext context) {
    return const [
      PopupMenuItem<String>(
        value: "设置",
        child: Center(child: Text("设置")),
      ),
    ];
  }

  void _onSelectItem(String value) {}

  Widget buildStopWatchPanel() {
    //MediaQuery.size 获取屏幕尺寸
    double radius = MediaQuery.of(context).size.width / 2 * 0.75;
    return StopwatchWidget(radius: radius, duration: _duration);
  }

  Widget buildRecordPanel() {
    return Expanded(child: RecordPanel(record: _record));
  }

  Widget buildTools() {
    return ButtonTools(
      state: _type,
      onRecoder: onRecorder,
      onReset: onReset,
      toggle: toggle,
    );
  }

  void onReset() {
    setState(() {
      _duration = Duration.zero;
      _type = StopWatchType.none;
      _record.clear();
    });
  }

  void onRecorder() {
    Duration current = _duration;
    Duration addition = _duration;
    if (_record.isNotEmpty) {
      addition = _duration - _record.last.record;
    }
    setState(() {
      _record.add(TimeRecord(record: current, addition: addition));
    });
  }

  void toggle() {
    bool running = _type == StopWatchType.running;
    if (running) {
      _ticker.stop();
      lastDuration = Duration.zero;
    } else {
      _ticker.start();
    }
    setState(() {
      _type = running ? StopWatchType.stopped : StopWatchType.running;
    });
  }
}
