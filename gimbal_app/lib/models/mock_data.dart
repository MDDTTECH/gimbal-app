class GimbalState {
  final double pan;
  final double tilt;
  final double roll;
  final bool isConnected;
  final int batteryPercent;
  final String mode;
  final double signalStrength;

  const GimbalState({
    this.pan = 0.0,
    this.tilt = 0.0,
    this.roll = 0.0,
    this.isConnected = false,
    this.batteryPercent = 85,
    this.mode = 'Follow',
    this.signalStrength = 0.92,
  });

  GimbalState copyWith({
    double? pan,
    double? tilt,
    double? roll,
    bool? isConnected,
    int? batteryPercent,
    String? mode,
    double? signalStrength,
  }) {
    return GimbalState(
      pan: (pan ?? this.pan).clamp(-180.0, 180.0),
      tilt: (tilt ?? this.tilt).clamp(-90.0, 90.0),
      roll: (roll ?? this.roll).clamp(-180.0, 180.0),
      isConnected: isConnected ?? this.isConnected,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      mode: mode ?? this.mode,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }
}

class MotionSequence {
  final String id;
  final String name;
  final int pointCount;
  final Duration duration;
  final DateTime createdAt;
  final bool isFavorite;

  const MotionSequence({
    required this.id,
    required this.name,
    required this.pointCount,
    required this.duration,
    required this.createdAt,
    this.isFavorite = false,
  });
}

class MockData {
  static const connectedGimbal = GimbalState(
    pan: 12.5,
    tilt: -8.3,
    roll: 0.2,
    isConnected: true,
    batteryPercent: 78,
    mode: 'Follow',
    signalStrength: 0.88,
  );

  static final sequences = [
    MotionSequence(
      id: '1',
      name: 'Product Turntable 360',
      pointCount: 450,
      duration: const Duration(seconds: 30),
      createdAt: DateTime(2026, 2, 14, 10, 30),
      isFavorite: true,
    ),
    MotionSequence(
      id: '2',
      name: 'Slow Pan Left-Right',
      pointCount: 200,
      duration: const Duration(seconds: 15),
      createdAt: DateTime(2026, 2, 13, 15, 45),
    ),
    MotionSequence(
      id: '3',
      name: 'Wildlife Tracking Arc',
      pointCount: 800,
      duration: const Duration(minutes: 1),
      createdAt: DateTime(2026, 2, 13, 9, 15),
      isFavorite: true,
    ),
    MotionSequence(
      id: '4',
      name: 'Time-lapse Sweep',
      pointCount: 1200,
      duration: const Duration(minutes: 5),
      createdAt: DateTime(2026, 2, 12, 14, 20),
    ),
    MotionSequence(
      id: '5',
      name: 'Quick Tilt Down-Up',
      pointCount: 100,
      duration: const Duration(seconds: 8),
      createdAt: DateTime(2026, 2, 12, 11, 0),
    ),
  ];
}
