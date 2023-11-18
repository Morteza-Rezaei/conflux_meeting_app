import 'package:flutter/foundation.dart';

class PossibleMeetingData extends ChangeNotifier {
  List<String> _participants = [];
  List<DateTime> _possibleMeetingDates = [];
  String _mTitle = '';
  String _mDescription = '';
  String _mMeetingEnteringPassword = '';

  List<String> get participants => _participants;
  List<DateTime> get possibleMeetingDates => _possibleMeetingDates;
  String get mTitle => _mTitle;
  String get mDescription => _mDescription;
  String get mMeetingEnteringPassword => _mMeetingEnteringPassword;

  void addParticipant(String participant) {
    _participants.add(participant);
    notifyListeners();
  }

  void addPossibleMeetingDate(DateTime date) {
    _possibleMeetingDates.add(date);
    notifyListeners();
  }

  void setMTitle(String title) {
    _mTitle = title;
    notifyListeners();
  }

  void setMDescription(String description) {
    _mDescription = description;
    notifyListeners();
  }

  void setMMeetingEnteringPassword(String password) {
    _mMeetingEnteringPassword = password;
    notifyListeners();
  }

  void clear() {
    _participants.clear();
    _possibleMeetingDates.clear();
    _mTitle = '';
    _mDescription = '';
    _mMeetingEnteringPassword = '';
    notifyListeners();
  }
}

class UsernameProvider extends ChangeNotifier {
  String _username = '';

  String get username => _username;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void clear() {
    _username = '';
    notifyListeners();
  }
}

class NewMeetingData extends ChangeNotifier {
  List<String> _participants = [];
  List<DateTime> _possibleMeetingDates = [];
  String _mTitle = '';
  String _mDescription = '';
  String _mMeetingEnteringPassword = '';

  List<String> get participants => _participants;
  List<DateTime> get possibleMeetingDates => _possibleMeetingDates;
  String get mTitle => _mTitle;
  String get mDescription => _mDescription;
  String get mMeetingEnteringPassword => _mMeetingEnteringPassword;

  void addParticipant(String participant) {
    _participants.add(participant);
    notifyListeners();
  }

  void addPossibleMeetingDate(DateTime date) {
    _possibleMeetingDates.add(date);
    notifyListeners();
  }

  void setMTitle(String title) {
    _mTitle = title;
    notifyListeners();
  }

  void setMDescription(String description) {
    _mDescription = description;
    notifyListeners();
  }

  void setMMeetingEnteringPassword(String password) {
    _mMeetingEnteringPassword = password;
    notifyListeners();
  }

  void clear() {
    _participants.clear();
    _possibleMeetingDates.clear();
    _mTitle = '';
    _mDescription = '';
    _mMeetingEnteringPassword = '';
    notifyListeners();
  }
}

class UserMeetingDatesProvider extends ChangeNotifier {
  Map<String, List<DateTime>> _userDates = {};

  Map<String, List<DateTime>> get userDates => _userDates;

  void addDates(String username, List<DateTime> dates) {
    if (!_userDates.containsKey(username)) {
      _userDates[username] = [];
    } else {
      _userDates[username]!.clear();
    }
    _userDates[username]!.addAll(dates);
    notifyListeners();
  }
}
