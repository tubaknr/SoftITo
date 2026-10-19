/// Bildirim panelinde gösterilen kayıt.
class AppNotification {
  final String title;
  final String body;
  final DateTime time;

  const AppNotification({
    required this.title,
    required this.body,
    required this.time,
  });
}
