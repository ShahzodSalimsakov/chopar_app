// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TrackPointLocationData {
  double latitude;
  double longitude;

  TrackPointLocationData({
    required this.latitude,
    required this.longitude,
  });

  TrackPointLocationData copyWith({
    double? latitude,
    double? longitude,
  }) {
    return TrackPointLocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory TrackPointLocationData.fromMap(Map<String, dynamic> map) {
    return TrackPointLocationData(
      latitude: double.parse(map['latitude']) as double,
      longitude: double.parse(map['longitude']) as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackPointLocationData.fromJson(String source) =>
      TrackPointLocationData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TrackPointLocationData(latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(covariant TrackPointLocationData other) {
    if (identical(this, other)) return true;

    return other.latitude == latitude && other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

class TrackPointCourier {
  String last_name;
  String first_name;
  String phone;

  TrackPointCourier({
    required this.last_name,
    required this.first_name,
    required this.phone,
  });

  TrackPointCourier copyWith({
    String? last_name,
    String? first_name,
    String? phone,
  }) {
    return TrackPointCourier(
      last_name: last_name ?? this.last_name,
      first_name: first_name ?? this.first_name,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'last_name': last_name,
      'first_name': first_name,
      'phone': phone,
    };
  }

  factory TrackPointCourier.fromMap(Map<String, dynamic> map) {
    return TrackPointCourier(
      last_name: map['last_name'] as String,
      first_name: map['first_name'] as String,
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackPointCourier.fromJson(String source) =>
      TrackPointCourier.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TrackPointCourier(last_name: $last_name, first_name: $first_name, phone: $phone)';

  @override
  bool operator ==(covariant TrackPointCourier other) {
    if (identical(this, other)) return true;

    return other.last_name == last_name &&
        other.first_name == first_name &&
        other.phone == phone;
  }

  @override
  int get hashCode => last_name.hashCode ^ first_name.hashCode ^ phone.hashCode;
}

class TrackPointLat {
  double lat;
  double lon;

  TrackPointLat({
    required this.lat,
    required this.lon,
  });

  TrackPointLat copyWith({
    double? lat,
    double? lon,
  }) {
    return TrackPointLat(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lon': lon,
    };
  }

  factory TrackPointLat.fromMap(Map<String, dynamic> map) {
    return TrackPointLat(
      lat: map['lat'] as double,
      lon: map['lon'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackPointLat.fromJson(String source) =>
      TrackPointLat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TrackPointLat(lat: $lat, lon: $lon)';

  @override
  bool operator ==(covariant TrackPointLat other) {
    if (identical(this, other)) return true;

    return other.lat == lat && other.lon == lon;
  }

  @override
  int get hashCode => lat.hashCode ^ lon.hashCode;
}

class TrackPoint {
  bool success;
  String? message;
  TrackPointLocationData? data;
  TrackPointCourier? courier;
  TrackPointLat? fromLocation;
  TrackPointLat? toLocation;

  TrackPoint({
    required this.success,
    this.message,
    this.data,
    this.courier,
    this.fromLocation,
    this.toLocation,
  });

  TrackPoint copyWith({
    bool? success,
    String? message,
  }) {
    return TrackPoint(
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'message': message,
    };
  }

  factory TrackPoint.fromMap(Map<String, dynamic> map) {
    return TrackPoint(
      success: map['success'] as bool,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null
          ? TrackPointLocationData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
      courier: map['courier'] != null
          ? TrackPointCourier.fromMap(map['courier'] as Map<String, dynamic>)
          : null,
      fromLocation: map['from_location'] != null
          ? TrackPointLat.fromMap(map['from_location'] as Map<String, dynamic>)
          : null,
      toLocation: map['to_location'] != null
          ? TrackPointLat.fromMap(map['to_location'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackPoint.fromJson(String source) =>
      TrackPoint.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TrackPoint(success: $success, message: $message)';

  @override
  bool operator ==(covariant TrackPoint other) {
    if (identical(this, other)) return true;

    return other.success == success && other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode;
}
