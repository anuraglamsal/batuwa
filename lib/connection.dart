import 'package:flutter/foundation.dart';

//This class is being used to connect "signinform" widget to the root widget i.e the "MyApp" widget
//such that real-time state change of "MyApp" is possible.
//To understand more about this, watch this video: https://www.youtube.com/watch?v=d_m5csmrf7I&t=1087s
class Connection_1 with ChangeNotifier{
  bool _logged = false; 
  bool get logged => _logged; 
  set logged(bool val){ 
    _logged = val;
    notifyListeners();
  }
}
