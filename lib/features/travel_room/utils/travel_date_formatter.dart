import '../models/travel_date_type.dart';

class TravelDateFormatter {
  const TravelDateFormatter._();

  static String format({
    required TravelDateType type,
    String? startDate,
    String? endDate,
    String? yearMonth,
    String? durationText,
  }) {
    switch (type) {
      case TravelDateType.date:
        return _formatDateRange(startDate: startDate, endDate: endDate);

      case TravelDateType.duration:
        return _formatDuration(
          yearMonth: yearMonth,
          durationText: durationText,
        );
    }
  }

  static String _formatDateRange({String? startDate, String? endDate}) {
    if (startDate == null ||
        startDate.isEmpty ||
        endDate == null ||
        endDate.isEmpty) {
      return '';
    }

    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);

    if (start == null || end == null) {
      return '';
    }

    return '${_formatDate(start)} - ${_formatDate(end)}';
  }

  static String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];

    final weekday = weekdays[date.weekday - 1];

    return '${date.month}.${date.day}($weekday)';
  }

  static String _formatDuration({String? yearMonth, String? durationText}) {
    if (yearMonth == null ||
        yearMonth.isEmpty ||
        durationText == null ||
        durationText.isEmpty) {
      return '';
    }

    final parts = yearMonth.split('-');

    if (parts.length != 2) {
      return '';
    }

    final month = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return '';
    }

    return '$month월 - $durationText';
  }
}
