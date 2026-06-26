class Endpoints {
  Endpoints._();

  static const String basePath = '/api';

  static const String login = '$basePath/Auth/login';
  static const String register = '$basePath/Auth/register';

  static const String users = '$basePath/Users';
  static String userById(String id) => '$basePath/Users/$id';

  static const String roles = '$basePath/Roles';
  static String roleById(String id) => '$basePath/Roles/$id';

  static const String employees = '$basePath/Employees';
  static String employeeById(String id) => '$basePath/Employees/$id';

  static const String patients = '$basePath/Patients';
  static String patientById(String id) => '$basePath/Patients/$id';

  static const String laboratory = '$basePath/Laboratory';
  static String laboratoryById(String id) => '$basePath/Laboratory/$id';

  static const String medicines = '$basePath/Medicines';
  static String medicineById(String id) => '$basePath/Medicines/$id';

  static const String treatmentSessions = '$basePath/TreatmentSessions';
  static String treatmentSessionById(String id) => '$basePath/TreatmentSessions/$id';

  static const String notifications = '$basePath/Notifications';
  static String notificationById(String id) => '$basePath/Notifications/$id';

  static const String administration = '$basePath/Administration';
  static String administrationById(String id) => '$basePath/Administration/$id';
}
