import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/geo_location.dart';

/// Timestamp / GeoPoint / ISO-string / Map dönüşümleri. Hem Firestore hem Hive verisini tolere eder.
class FsConverters {
  FsConverters._();

  static DateTime? toDate(Object? v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    return null;
  }

  static Timestamp? fromDate(DateTime? d) => d == null ? null : Timestamp.fromDate(d);

  static GeoLocation? toGeo(Object? v) {
    if (v is GeoPoint){ 
      return GeoLocation(v.latitude, v.longitude);
    }
    if (v is Map) {
      return GeoLocation.fromMap(v);
    } 
    return null;
  }

  static GeoPoint? fromGeo(GeoLocation? g) => g == null ? null : GeoPoint(g.latitude, g.longitude);

  static List<dynamic> toList(Object? v) => v is Iterable ? v.toList() : <dynamic>[];

  static List<String> toStringList(Object? v) =>
      v is Iterable ? v.map((e) => e.toString()).toList() : <String>[];
}
