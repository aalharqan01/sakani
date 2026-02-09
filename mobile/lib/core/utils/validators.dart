class Validators {
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length != 8) return 'Must be 8 digits';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null; // Optional field
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Invalid email format';
    return null;
  }

  static String? qid(String? value) {
    if (value == null || value.isEmpty) return null; // Optional field
    if (value.length != 11 || !RegExp(r'^\d{11}$').hasMatch(value)) {
      return 'Qatar ID must be 11 digits';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Must be at least 8 characters';
    return null;
  }
}
