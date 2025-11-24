import 'dart:async';

class BaseViewModel {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<String> viewDialogLieData = StreamController();
}