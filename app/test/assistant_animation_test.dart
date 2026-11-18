import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('assistant animation asset parses and has a duration', () async {
    final data = await rootBundle.load('assets/assistant_pulse.json');
    final composition = LottieComposition.parseJsonBytes(
      data.buffer.asUint8List(),
    );
    expect(composition.duration, greaterThan(Duration.zero));
  });
}
