import 'package:intl/intl.dart';

class Formatters {
  /// Format amount in QAR: "12,500.00 QAR" or "١٢,٥٠٠.٠٠ ر.ق"
  static String currency(double amount, {bool arabic = false}) {
    final formatter = NumberFormat('#,##0.00');
    final formatted = formatter.format(amount);
    return arabic ? '$formatted ر.ق' : 'QAR $formatted';
  }

  /// Format Qatar phone: "+974 1234 5678"
  static String phone(String phone) {
    if (phone.startsWith('+974') && phone.length == 12) {
      return '+974 ${phone.substring(4, 8)} ${phone.substring(8)}';
    }
    return phone;
  }

  /// Format date: "15 Jan 2026"
  static String date(DateTime date, {String locale = 'en'}) {
    return DateFormat('dd MMM yyyy', locale).format(date);
  }

  /// Format date relative: "in 3 days", "2 days ago"
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays == -1) return 'Yesterday';
    if (diff.inDays > 0) return 'In ${diff.inDays} days';
    return '${diff.inDays.abs()} days ago';
  }
}
