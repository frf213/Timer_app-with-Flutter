import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _timerMilliseconds = 0;
  int _pauseTimeMilliseconds = 0;
  int _countdownSeconds = 0;
  bool _isTimerRunning = false;
  bool _isCountdownRunning = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      if (!_isTimerRunning) {
        // Start the timer from the beginning
        _timerMilliseconds = 0;
      }
      _isTimerRunning = true;
    });
    final int startTime = DateTime.now().millisecondsSinceEpoch - _pauseTimeMilliseconds;
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        final int currentTime = DateTime.now().millisecondsSinceEpoch;
        _timerMilliseconds = currentTime - startTime;
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isTimerRunning = false;
      _pauseTimeMilliseconds = _timerMilliseconds;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isTimerRunning = false;
      _timerMilliseconds = 0;
      _pauseTimeMilliseconds = 0;
    });
    _timer?.cancel();
  }

  String _formatMilliseconds(int milliseconds) {
    int hours = (milliseconds ~/ (1000 * 60 * 60)) % 24;
    int minutes = (milliseconds ~/ (1000 * 60)) % 60;
    int seconds = (milliseconds ~/ 1000) % 60;
    int millisecondsPart = milliseconds % 1000;

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds).toString().padLeft(2, '0');
    String millisecondsStr = (millisecondsPart ~/ 10).toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr:$millisecondsStr';
  }

  void _startCountdown() {
    setState(() {
      _isCountdownRunning = true;
    });
    _countdownSeconds = 60; // Set the desired countdown duration in seconds
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds <= 0) {
          _stopCountdown();
        } else {
          _countdownSeconds--;
        }
      });
    });
  }


  void _stopCountdown() {
    setState(() {
      _isCountdownRunning = false;
    });
    _timer?.cancel();
  }

  void _resetCountdown() {
    setState(() {
      _isCountdownRunning = false;
      _countdownSeconds = 0;
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatMilliseconds(_timerMilliseconds);

    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              'Timer: $formattedTime',
              style: TextStyle(fontSize: 24),
            ),

            ElevatedButton(
              onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
              child: Text(_isTimerRunning ? 'Pause Timer' : 'Start Timer'),
            ),

            ElevatedButton(
              onPressed: _resetTimer,
              child: Text('Reset Timer'),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isCountdownRunning ? null : _startCountdown,
              child: Text('Start Countdown'),
            ),

            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: _isCountdownRunning
                        ? _countdownSeconds / 60
                        : 0,
                  ),
                ),

                Text(
                  '$_countdownSeconds',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: _resetCountdown,
              child: Text('Reset Countdown'),
            ),
          ],
        ),
      ),
    );
  }
}
