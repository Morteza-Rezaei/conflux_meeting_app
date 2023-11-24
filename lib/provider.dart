// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PossibleMeetingData extends ChangeNotifier {
  List<String> _participants = [];
  List<DateTime> _possibleMeetingDates = [];
  String _mTitle = '';
  String _mDescription = '';
  String _mMeetingEnteringPassword = '';
  int? _meetingDurationMinutes;

  List<String> get participants => _participants;
  List<DateTime> get possibleMeetingDates => _possibleMeetingDates;
  String get mTitle => _mTitle;
  String get mDescription => _mDescription;
  String get mMeetingEnteringPassword => _mMeetingEnteringPassword;
  int? get meetingDurationMinutes => _meetingDurationMinutes;

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

  void setMeetingDurationMinutes(int? minutes) {
    _meetingDurationMinutes = minutes;
    notifyListeners();
  }

  void clear() {
    _participants.clear();
    _possibleMeetingDates.clear();
    _mTitle = '';
    _mDescription = '';
    _mMeetingEnteringPassword = '';
    _meetingDurationMinutes = null;
    notifyListeners();
  }
}

class NewMeetingData extends ChangeNotifier {
  List<String> _participants = [];
  DateTime? _meetingDate;
  String _mTitle = '';
  String _mDescription = '';
  String _mMeetingEnteringPassword = '';
  int? _meetingDurationMinutes;

  List<String> get participants => _participants;
  DateTime? get meetingDate => _meetingDate;
  String get mTitle => _mTitle;
  String get mDescription => _mDescription;
  String get mMeetingEnteringPassword => _mMeetingEnteringPassword;
  int? get meetingDurationMinutes => _meetingDurationMinutes;

  void addParticipant(String participant) {
    _participants.add(participant);
    notifyListeners();
  }

  void setMeetingDate(DateTime? date) {
    _meetingDate = date;
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

  void setMeetingDurationMinutes(int? minutes) {
    _meetingDurationMinutes = minutes;
    notifyListeners();
  }

  void clear() {
    _participants.clear();
    _meetingDate = null;
    _mTitle = '';
    _mDescription = '';
    _mMeetingEnteringPassword = '';
    _meetingDurationMinutes = null;
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

class UserMeetingDatesProvider extends ChangeNotifier {
  Map<String, List<DateTime>> _userDates = {};

  Future<Map<String, List<DateTime>>> fetchUserDates() async {
    final url = Uri.https('conflux-meeting-app-default-rtdb.firebaseio.com',
        'users-selected-dates.json');
    final response = await http.get(url);
    final userDatesData = json.decode(response.body) as Map<String, dynamic>;
    return userDatesData.map((username, datesData) {
      List<DateTime> dates =
          (datesData as List).map((date) => DateTime.parse(date)).toList();
      return MapEntry(username, dates);
    });
  }

  Future<void> addDates(String username, List<DateTime> dates) async {
    if (!_userDates.containsKey(username)) {
      _userDates[username] = [];
    } else {
      _userDates[username]!.clear();
    }
    final url = Uri.https('conflux-meeting-app-default-rtdb.firebaseio.com',
        'users-selected-dates/$username.json');
    final response = await http.put(url,
        body:
            json.encode(dates.map((date) => date.toIso8601String()).toList()));
    //_userDates[username]!.addAll(dates);
    if (response.statusCode >= 400) {
      throw Exception('Failed to save dates');
    }
    notifyListeners();
  }

  Future<void> resetUsersSelectedDateData() async {
    _userDates.clear();
    final url = Uri.https('conflux-meeting-app-default-rtdb.firebaseio.com',
        'users-selected-dates.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw Exception('Failed to reset dates');
    }
    notifyListeners();
  }

  Map<String, List<DateTime>> get userDates => _userDates;
}
