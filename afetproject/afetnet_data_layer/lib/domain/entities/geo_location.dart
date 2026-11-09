import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// Domain katmanını Firestore'dan bağımsız tutan konum değer nesnesi
/// (data katmanında GeoPoint ile dönüştürülür).
class GeoLocation extends Equatable {
  const GeoLocation(this.latitude, this.longitude);

  factory GeoLocation.fromMap(Map<dynamic, dynamic> m) => GeoLocation(
        ((m['lat'] ?? m['latitude']) as num).toDouble(),
        ((m['lng'] ?? m['longitude']) as num).toDouble(),
      );

  final double latitude;
  final double longitude;

  Map<String, double> toMap() => {'lat': latitude, 'lng': longitude};

  /// Haversine mesafesi (metre). Mükerrer çağrı filtresinde (<= 50 m) kullanılır.
  double distanceTo(GeoLocation other) {
    const r = 6371000.0;
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(other.latitude - latitude);
    final dLng = rad(other.longitude - longitude);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(latitude)) *
            math.cos(rad(other.latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * r * math.asin(math.sqrt(a));
  }

  bool isWithin(GeoLocation other, double meters) => distanceTo(other) <= meters;

  @override
  List<Object?> get props => [latitude, longitude];
}
