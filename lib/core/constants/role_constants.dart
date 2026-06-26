enum RoleType {
  admin,
  doctor,
  reception,
  patient,
  laboratory,
  unknown;

  static RoleType fromRoleName(String? roleName) {
    if (roleName == null) return RoleType.unknown;
    switch (roleName.toLowerCase().trim()) {
      case 'admin':
        return RoleType.admin;
      case 'doctor':
        return RoleType.doctor;
      case 'reception':
        return RoleType.reception;
      case 'patient':
        return RoleType.patient;
      case 'laboratory':
        return RoleType.laboratory;
      default:
        return RoleType.unknown;
    }
  }

  String get label {
    switch (this) {
      case RoleType.admin:
        return 'مدير';
      case RoleType.doctor:
        return 'طبيب';
      case RoleType.reception:
        return 'استقبال';
      case RoleType.patient:
        return 'مريض';
      case RoleType.laboratory:
        return 'مختبر';
      case RoleType.unknown:
        return 'غير معروف';
    }
  }
}
