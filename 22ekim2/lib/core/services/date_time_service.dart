/// Injectable Date & Time service to allow deterministic unit testing
abstract class DateTimeService {
  DateTime now();
  DateTime today();

  static DateTime normalize(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }
}

class DefaultDateTimeService implements DateTimeService {
  const DefaultDateTimeService();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime today() {
    final current = DateTime.now();
    return DateTime(current.year, current.month, current.day);
  }
}

class MockDateTimeService implements DateTimeService {
  MockDateTimeService(DateTime initialTime) : _current = initialTime;

  DateTime _current;

  void setTime(DateTime time) {
    _current = time;
  }

  void advanceDays(int days) {
    _current = _current.add(Duration(days: days));
  }

  @override
  DateTime now() => _current;

  @override
  DateTime today() => DateTime(_current.year, _current.month, _current.day);
}
