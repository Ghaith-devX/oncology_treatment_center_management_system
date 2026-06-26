class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredCheck = required(value);
    if (requiredCheck != null) return requiredCheck;
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value!.trim())) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredCheck = required(value);
    if (requiredCheck != null) return requiredCheck;
    if (value!.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  static String? number(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (double.tryParse(value.trim()) == null) {
      return 'يجب أن يكون رقمًا صحيحًا';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!RegExp(r'^\+?[\d\- ]{7,15}$').hasMatch(value.trim())) {
      return 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    final numCheck = number(value);
    if (numCheck != null) return numCheck;
    if (value != null && value.trim().isNotEmpty) {
      final num = double.tryParse(value.trim());
      if (num != null && num < 0) {
        return 'يجب أن يكون رقمًا موجبًا';
      }
    }
    return null;
  }
}
