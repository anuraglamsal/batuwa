import 'package:flutter/foundation.dart';

class Connection with ChangeNotifier{
  bool _logged = false;
  bool get logged => _logged;
  set logged(bool val){
    _logged = val;
    notifyListeners();
  }
}
