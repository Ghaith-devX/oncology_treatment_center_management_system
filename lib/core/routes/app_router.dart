import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/admin_dashboard_screen.dart';
import '../../features/dashboard/screens/doctor_dashboard_screen.dart';
import '../../features/dashboard/screens/laboratory_dashboard_screen.dart';
import '../../features/dashboard/screens/patient_home_screen.dart';
import '../../features/dashboard/screens/reception_dashboard_screen.dart';
import '../../features/employees/screens/employee_details_screen.dart';
import '../../features/employees/screens/employee_form_screen.dart';
import '../../features/employees/screens/employees_list_screen.dart';
import '../../features/patients/screens/patient_details_screen.dart';
import '../../features/patients/screens/patient_form_screen.dart';
import '../../features/patients/screens/patients_list_screen.dart';
import '../../features/notifications/screens/notifications_list_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/users/screens/users_list_screen.dart';
import '../constants/role_constants.dart';
import 'route_names.dart';

GoRouter createRouter(Ref ref) {
  return GoRouter(
    initialLocation: RouteNames.login,
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context, listen: false);
      final authState = container.read(authControllerProvider);
      final isLoggedIn = authState.isAuthenticated;
      final location = state.uri.toString();

      if (!isLoggedIn && location != RouteNames.login) {
        return RouteNames.login;
      }

      if (isLoggedIn && location == RouteNames.login) {
        return _getDashboardForRole(authState.roleType);
      }

      if (isLoggedIn && _isRouteForbidden(location, authState.roleType)) {
        return _getDashboardForRole(authState.roleType);
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        name: 'adminDashboard',
        builder: (_, _) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.doctorDashboard,
        name: 'doctorDashboard',
        builder: (_, _) => const DoctorDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.receptionDashboard,
        name: 'receptionDashboard',
        builder: (_, _) => const ReceptionDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.laboratoryDashboard,
        name: 'laboratoryDashboard',
        builder: (_, _) => const LaboratoryDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.patientHome,
        name: 'patientHome',
        builder: (_, _) => const PatientHomeScreen(),
      ),
      GoRoute(
        path: RouteNames.patients,
        name: 'patients',
        builder: (_, _) => const PatientsListScreen(),
        routes: [
          GoRoute(
            path: 'form',
            name: 'patientForm',
            builder: (_, _) => const PatientFormScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'patientDetails',
            builder: (_, state) => PatientDetailsScreen(
              patientId: int.parse(state.pathParameters['id']!),
            ),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'patientEdit',
                builder: (_, state) => PatientFormScreen(
                  patient: null,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.employees,
        name: 'employees',
        builder: (_, _) => const EmployeesListScreen(),
        routes: [
          GoRoute(
            path: 'form',
            name: 'employeeForm',
            builder: (_, _) => const EmployeeFormScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'employeeDetails',
            builder: (_, state) => EmployeeDetailsScreen(
              employeeId: int.parse(state.pathParameters['id']!),
            ),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'employeeEdit',
                builder: (_, state) => EmployeeFormScreen(
                  employee: null,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.users,
        name: 'users',
        builder: (_, _) => const UsersListScreen(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        name: 'notifications',
        builder: (_, _) => const NotificationsListScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (_, _) => const SettingsScreen(),
      ),
    ],
  );
}

String _getDashboardForRole(RoleType role) {
  switch (role) {
    case RoleType.admin:
      return RouteNames.adminDashboard;
    case RoleType.doctor:
      return RouteNames.doctorDashboard;
    case RoleType.reception:
      return RouteNames.receptionDashboard;
    case RoleType.laboratory:
      return RouteNames.laboratoryDashboard;
    case RoleType.patient:
      return RouteNames.patientHome;
    case RoleType.unknown:
      return RouteNames.login;
  }
}

bool _isRouteForbidden(String location, RoleType role) {
  const adminPaths = [
    RouteNames.users,
    RouteNames.administration,
  ];

  if (role == RoleType.admin) return false;

  for (final path in adminPaths) {
    if (location.startsWith(path)) return true;
  }

  return false;
}
