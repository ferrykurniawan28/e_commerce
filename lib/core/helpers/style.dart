part of 'helpers.dart';

TextStyle titleTextStyle = const TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

TextStyle subtitleTextStyle = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Colors.grey,
);

TextStyle bodyTextStyle = const TextStyle(fontSize: 14, color: Colors.black87);

ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);
