  import 'dart:async';
  import 'package:bloc/bloc.dart';
  import 'package:meta/meta.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'dart:convert';

  import '../models/YapilanSporlarModel.dart';

  enum TrainingProgramState { initial, running, paused, finished }

  class TrainingProgramCubit extends Cubit<TrainingProgramState> {
    late Timer _timer;
    int _stepCount = 0;
    double _remainingTime = 0.0;
    List<YapilanSporlarModel> _yapilansporlarliste = [];

    TrainingProgramCubit() : super(TrainingProgramState.initial);

    Future<void> loadDataFromPrefs() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      _yapilansporlarliste = (prefs.getStringList('yapilansporlarliste') ?? [])
          .map((json) => YapilanSporlarModel.fromJson(jsonDecode(json)))
          .toList();

      emit(state);
    }

    Future<void> savedataYeniSporAktivite() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> jsonyapilansporlarliste = _yapilansporlarliste
          .map((aktiviteler) => jsonEncode(aktiviteler.toJson()))
          .toList();
      prefs.setStringList('yapilansporlarliste', jsonyapilansporlarliste);
      emit(state);
    }

    void start(int stepCount, double totalTime) {
      _stepCount = stepCount;
      _remainingTime = totalTime;

      emit(TrainingProgramState.running);

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime <= 0) {
          finish();
          return;
        }

        _remainingTime -= 1;
        if (_remainingTime <= 0) {
          _stepCount--;
          _remainingTime = totalTime;
        }

        if (_stepCount <= 0) {
          finish();
        }

        emit(TrainingProgramState.running);
      });
    }

    void pause() {
      _timer.cancel();
      emit(TrainingProgramState.paused);
    }

    void reset() {
      _timer.cancel();
      _stepCount = 0;
      _remainingTime = 0;
      emit(TrainingProgramState.initial);
    }

    void finish() {
      _timer.cancel();
      emit(TrainingProgramState.finished);
    }

    int get stepCount => _stepCount;
    double get remainingTime => _remainingTime;
  }
