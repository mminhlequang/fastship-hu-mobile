 
import 'package:tuple/tuple.dart';
import 'dart:math';
 

///
/// Stateful instance for encoding and decoding on a sequence of Coordinates
/// part of a request.
/// Instance should be specific to type of coordinates (e.g. Lat, Lng)
/// so that specific type delta is computed for encoding.
/// Lat0 Lng0 3rd0 (Lat1-Lat0) (Lng1-Lng0) (3rdDim1-3rdDim0)
///
class Converter {
  final int precision;
  late int multiplier;
  int lastValue = 0;

  Converter(this.precision) {
    multiplier = pow(10, precision) as int;
  }

  // Returns decoded int, new index in tuple
  static Tuple2<int, int> decodeUnsignedVarint(
      List<String> encoded, int index) {
    int shift = 0;
    int delta = 0;
    int value;

    while (index < encoded.length) {
      value = decodeChar(encoded[index]);
      if (value < 0) {
        throw ArgumentError("Invalid encoding");
      }
      index++;
      delta |= (value & 0x1F) << shift;
      if ((value & 0x20) == 0) {
        return Tuple2(delta, index);
      } else {
        shift += 5;
      }
    }

    if (shift > 0) {
      throw ArgumentError("Invalid encoding");
    }
    return Tuple2(0, index);
  }

  // Decode single coordinate (say lat|lng|z) starting at index
  // Returns decoded coordinate, new index in tuple
  Tuple2<double, int> decodeValue(List<String> encoded, int index) {
    final Tuple2<int, int> result = decodeUnsignedVarint(encoded, index);
    double coordinate = 0;
    int delta = result.item1;
    if ((delta & 1) != 0) {
      delta = ~delta;
    }
    delta = delta >> 1;
    lastValue += delta;
    coordinate = lastValue / multiplier;
    return Tuple2(coordinate, result.item2);
  }

  static String encodeUnsignedVarint(int value) {
    String result = '';
    while (value > 0x1F) {
      int pos = ((value & 0x1F) | 0x20);
      result += FlexiblePolyline.encodingTable[pos];
      value >>= 5;
    }
    result += (FlexiblePolyline.encodingTable[value]);
    return result;
  }

  // Encode a single double to a string
  String encodeValue(double value) {
    /*
     * Round-half-up
     * round(-1.4) --> -1
     * round(-1.5) --> -2
     * round(-2.5) --> -3
     */
    final double scaledValue = (value * multiplier).abs().round() * value.sign;
    int delta = (scaledValue - lastValue).toInt();
    final bool negative = delta < 0;

    lastValue = scaledValue.toInt();

    // make room on lowest bit
    delta <<= 1;

    // invert bits if the value is negative
    if (negative) {
      delta = ~delta;
    }
    return encodeUnsignedVarint(delta);
  }

  //Decode a single char to the corresponding value
  static int decodeChar(String charValue) {
    final int pos = charValue.codeUnitAt(0) - 45;
    if (pos < 0 || pos > 77) {
      return -1;
    }
    return FlexiblePolyline.decodingTable[pos];
  }
}


class FlexiblePolyline {
  static const int version = 1;
  static final List<String> encodingTable =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
          .split('');
  static final List<int> decodingTable = [
    62,
    -1,
    -1,
    52,
    53,
    54,
    55,
    56,
    57,
    58,
    59,
    60,
    61,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    -1,
    -1,
    -1,
    -1,
    63,
    -1,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    50,
    51
  ];

  ///
  /// Decode the encoded input {@link String} to {@link List} of coordinate
  /// triples.
  ///
  /// @param encoded URL-safe encoded {@link String}
  /// @return {@link List} of coordinate triples that are decoded from input
  ///
  /// @see FlexiblePolyline#getThirdDimension(String) getThirdDimension
  /// @see LatLngZ
  ///
  static List<LatLngZ> decode(String encoded) {
    if (encoded.trim().isEmpty) {
      throw ArgumentError("Invalid argument!");
    }
    final List<LatLngZ> results = [];
    final _Decoder dec = _Decoder(encoded);
    LatLngZ? result;

    do {
      result = dec.decodeOne();
      if (result != null) results.add(result);
    } while (result != null);
    return results;
  }

  ///
  /// Encode the list of coordinate triples.<BR><BR>
  /// The third dimension value will be eligible for encoding only when
  /// ThirdDimension is other than ABSENT.
  /// This is lossy compression based on precision accuracy.
  ///
  /// @param coordinates {@link List} of coordinate triples that to be encoded.
  /// @param precision   Floating point precision of the coordinate to be
  /// encoded.
  /// @param thirdDimension {@link ThirdDimension} which may be a level,
  /// altitude, elevation or some other custom value
  /// @param thirdDimPrecision Floating point precision for thirdDimension value
  /// @return URL-safe encoded {@link String} for the given coordinates.
  ///
  static String encode(List<LatLngZ>? coordinates, int precision,
      ThirdDimension? thirdDimension, int thirdDimPrecision) {
    if (coordinates == null || coordinates.isEmpty) {
      throw ArgumentError("Invalid coordinates!");
    }
    if (thirdDimension == null) {
      throw ArgumentError("Invalid thirdDimension");
    }
    final _Encoder enc = _Encoder(precision, thirdDimension, thirdDimPrecision);
    final Iterator<LatLngZ> iter = coordinates.iterator;
    while (iter.moveNext()) {
      enc.add(iter.current);
    }
    return enc.getEncoded();
  }

  /// ThirdDimension type from the encoded input {@link String}
  /// @param encoded URL-safe encoded coordinate triples {@link String}
  /// @return type of {@link ThirdDimension}
  static ThirdDimension getThirdDimension(List<String> encoded) {
    int index = 0;
    Tuple2<int, int> headerResult =
        _Decoder.decodeHeaderFromString(encoded, index);
    final int header = headerResult.item1;
    return ThirdDimension.values[(header >> 4) & 7];
  }
}

/// Single instance for decoding an input request.
class _Decoder {
  final String encoded;
  late int index;
  late Converter latConverter;
  late Converter lngConverter;
  late Converter zConverter;
  late List<String> split;

  late int precision;
  late int thirdDimPrecision;
  late ThirdDimension thirdDimension;

  _Decoder(this.encoded) {
    index = 0;
    split = encoded.split('');
    _decodeHeader();
    latConverter = Converter(precision);
    lngConverter = Converter(precision);
    zConverter = Converter(thirdDimPrecision);
  }

  bool hasThirdDimension() => thirdDimension != ThirdDimension.ABSENT;

  void _decodeHeader() {
    final Tuple2<int, int> headerResult = decodeHeaderFromString(split, index);
    int header = headerResult.item1;
    index = headerResult.item2;
    precision = header & 15; // we pick the first 3 bits only
    header = header >> 4;

    thirdDimension =
        ThirdDimension.values[header & 7]; // we pick the first 4 bits only
    thirdDimPrecision = (header >> 3) & 15;
  }

  // Returns polyline header, new index in tuple.
  static Tuple2<int, int> decodeHeaderFromString(
      List<String> encoded, int index) {
    // Decode the header version
    final Tuple2<int, int> result =
        Converter.decodeUnsignedVarint(encoded, index);

    if (result.item1 != FlexiblePolyline.version) {
      throw ArgumentError("Invalid format version");
    }

    // Decode the polyline header
    return Converter.decodeUnsignedVarint(encoded, result.item2);
  }

  LatLngZ? decodeOne() {
    if (index == encoded.length) {
      return null;
    }
    final Tuple2<double, int> latResult =
        latConverter.decodeValue(split, index);
    index = latResult.item2;
    final Tuple2<double, int> lngResult =
        lngConverter.decodeValue(split, index);
    index = lngResult.item2;
    if (hasThirdDimension()) {
      final Tuple2<double, int> zResult = zConverter.decodeValue(split, index);
      index = zResult.item2;
      return LatLngZ(latResult.item1, lngResult.item1, zResult.item1);
    }
    return LatLngZ(latResult.item1, lngResult.item1);
  }
}

/// Single instance for configuration, validation and encoding for an input
/// request.
class _Encoder {
  final int precision;
  final ThirdDimension thirdDimension;
  final int thirdDimPrecision;
  late Converter latConverter;
  late Converter lngConverter;
  late Converter zConverter;
  String result = '';

  _Encoder(this.precision, this.thirdDimension, this.thirdDimPrecision) {
    latConverter = Converter(precision);
    lngConverter = Converter(precision);
    zConverter = Converter(thirdDimPrecision);
    encodeHeader();
  }

  void encodeHeader() {
    final int thirdDimensionValue = thirdDimension.index;

    /// Encode the `precision`, `third_dim` and `third_dim_precision` into one
    /// encoded char
    if (precision < 0 || precision > 15) {
      throw ArgumentError("precision out of range");
    }

    if (thirdDimPrecision < 0 || thirdDimPrecision > 15) {
      throw ArgumentError("thirdDimPrecision out of range");
    }

    if (thirdDimensionValue < 0 || thirdDimensionValue > 7) {
      throw ArgumentError("thirdDimensionValue out of range");
    }
    final double res =
        ((thirdDimPrecision << 7) | (thirdDimensionValue << 4) | precision)
            .toDouble();
    result += Converter.encodeUnsignedVarint(FlexiblePolyline.version);
    result += Converter.encodeUnsignedVarint(res.toInt());
  }

  void addTuple(double lat, double lng) {
    result += latConverter.encodeValue(lat);
    result += lngConverter.encodeValue(lng);
  }

  void addTriple(double lat, double lng, double z) {
    addTuple(lat, lng);
    if (thirdDimension != ThirdDimension.ABSENT) {
      result += zConverter.encodeValue(z);
    }
  }

  void add(LatLngZ? tuple) {
    if (tuple == null) {
      throw ArgumentError("Invalid LatLngZ tuple");
    }
    addTriple(tuple.lat, tuple.lng, tuple.z);
  }

  String getEncoded() => result.toString();
}

/// Coordinate triple
class LatLngZ {
  final double lat;
  final double lng;
  final double z;

  LatLngZ(this.lat, this.lng, [this.z = 0]);

  @override
  String toString() => "LatLngZ [lat=$lat, lng=$lng, z=$z]";

  @override
  bool operator ==(other) =>
      other is LatLngZ && other.lat == lat && other.lng == lng && other.z == z;

  @override
  int get hashCode => lat.hashCode + lng.hashCode + z.hashCode;
}

/// 3rd dimension specification.
/// Example a level, altitude, elevation or some other custom value.
/// ABSENT is default when there is no third dimension en/decoding required.
enum ThirdDimension {
  ABSENT,
  LEVEL,
  ALTITUDE,
  ELEVATION,
  RESERVED1,
  RESERVED2,
  CUSTOM1,
  CUSTOM2
}