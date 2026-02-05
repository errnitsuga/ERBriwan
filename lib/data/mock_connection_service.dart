/// Result of checking connection to ESP32 device (mock).
enum ConnectionScenario {
  senderWithProfile,
  receiverWithProfile,
  senderWithoutProfile,
  receiverWithoutProfile,
  noDevice,
}

extension ConnectionScenarioExtension on ConnectionScenario {
  String get message {
    switch (this) {
      case ConnectionScenario.senderWithProfile:
        return 'Sender device connected with existing profile';
      case ConnectionScenario.receiverWithProfile:
        return 'Receiver device connected with existing profile';
      case ConnectionScenario.senderWithoutProfile:
        return 'Sender device connected without existing profile';
      case ConnectionScenario.receiverWithoutProfile:
        return 'Receiver device connected without existing profile';
      case ConnectionScenario.noDevice:
        return 'No device detected – try again';
    }
  }

  bool get hasDevice => this != ConnectionScenario.noDevice;
}

/// Mock service to simulate device connection check.
/// In production this would call the ESP32 / backend.
class MockConnectionService {
  MockConnectionService._();

  /// Simulate checking device. Returns the chosen scenario (for mock, chosen by user in UI).
  static Future<ConnectionScenario> checkDevice() async {
    await Future.delayed(const Duration(milliseconds: 400));
    // In real app: detect device type and profile from ESP32.
    // For mock, the UI passes the selected scenario.
    return ConnectionScenario.senderWithProfile;
  }

  /// Simulate device has internet (for mock, chosen by user in UI).
  static bool get deviceHasInternet => true;
}
