class DateTimeParsing {
  DateTimeParsing._();

  static DateTime? tryParseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    return DateTime.tryParse(date);
  }

  static String formatDate(String? date) {
    final dt = tryParseDate(date);
    if (dt == null) return '--';
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)}';
  }

  static String? tryParseTime(String? time) {
    if (time == null || time.isEmpty) return null;
    final cleaned = time.replaceAll('Z', '');
    try {
      final parts = cleaned.split(':');
      if (parts.length >= 2) {
        final hours = int.parse(parts[0].padLeft(2, '0'));
        final minutes = int.parse(parts[1].padLeft(2, '0'));
        if (hours >= 0 && hours < 24 && minutes >= 0 && minutes < 60) {
          return '${_pad(hours)}:${_pad(minutes)}';
        }
      }
    } catch (_) {}
    return time;
  }

  static String formatTime(String? time) {
    return tryParseTime(time) ?? '--:--';
  }

  static bool isExpired(String? expiresAt) {
    final dt = tryParseDate(expiresAt);
    if (dt == null) return true;
    return dt.isBefore(DateTime.now());
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
