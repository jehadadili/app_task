import 'dart:async';

class QuizTimerService {
  Timer? _timer;
  DateTime? _questionStartTime;
  
  void Function()? onTimeUp;
  void Function(int remainingTime)? onTick;

  void startTimer(int timeLimit) {
    _timer?.cancel();
    _questionStartTime = DateTime.now();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLimit <= 1) {
        timer.cancel();
        onTimeUp?.call();
      } else {
        timeLimit--;
        onTick?.call(timeLimit);
      }
    });
  }

  int calculateTimeTaken(int questionTimeLimit) {
    if (_questionStartTime == null) return questionTimeLimit;
    
    final duration = DateTime.now().difference(_questionStartTime!);
    return duration.inSeconds > questionTimeLimit 
        ? questionTimeLimit 
        : duration.inSeconds;
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  void resetQuestionStartTime() {
    _questionStartTime = DateTime.now();
  }

  void dispose() {
    _timer?.cancel();
    _questionStartTime = null;
  }
}