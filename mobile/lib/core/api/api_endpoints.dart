abstract class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8000/api/v1';

  // Auth
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String refreshToken = '/auth/token/refresh/';
  static const String logout = '/auth/logout/';
  static const String profile = '/auth/profile/';
  static const String changePassword = '/auth/change-password/';

  // Compounds
  static const String compounds = '/compounds/';
  static String compoundDetail(String id) => '/compounds/$id/';
  static String compoundOccupancy(String id) => '/compounds/$id/occupancy/';
  static String compoundBuildings(String id) => '/compounds/$id/buildings/';

  // Buildings
  static const String buildings = '/buildings/';
  static String buildingDetail(String id) => '/buildings/$id/';
  static String buildingUnits(String id) => '/buildings/$id/units/';

  // Units
  static const String units = '/units/';
  static String unitDetail(String id) => '/units/$id/';

  // Leases
  static const String leases = '/leases/';
  static String leaseDetail(String id) => '/leases/$id/';
  static String leaseActivate(String id) => '/leases/$id/activate/';
  static String leaseTerminate(String id) => '/leases/$id/terminate/';

  // Cheques
  static const String cheques = '/cheques/';
  static String chequeDetail(String id) => '/cheques/$id/';
  static String chequeDeposit(String id) => '/cheques/$id/deposit/';
  static String chequeClear(String id) => '/cheques/$id/clear/';
  static String chequeBounce(String id) => '/cheques/$id/bounce/';
  static String chequeReplace(String id) => '/cheques/$id/replace/';
  static const String chequeBulkCreate = '/cheques/bulk_create/';
  static const String chequeUpcoming = '/cheques/upcoming/';
  static const String chequeOverdue = '/cheques/overdue/';
  static const String chequeDashboard = '/cheques/dashboard/';

  // Maintenance
  static const String maintenanceCategories = '/maintenance/categories/';
  static const String maintenanceRequests = '/maintenance/requests/';
  static String maintenanceDetail(String id) => '/maintenance/requests/$id/';
  static String maintenanceImages(String id) => '/maintenance/requests/$id/images/';
  static String maintenanceQuote(String id) => '/maintenance/requests/$id/quote/';
  static String maintenanceAcceptQuote(String id) =>
      '/maintenance/requests/$id/accept_quote/';
  static String maintenanceRejectQuote(String id) =>
      '/maintenance/requests/$id/reject_quote/';
  static String maintenanceComplete(String id) =>
      '/maintenance/requests/$id/complete/';
  static String maintenanceRate(String id) => '/maintenance/requests/$id/rate/';
  static String maintenanceComments(String id) =>
      '/maintenance/requests/$id/comments/';

  // Notifications
  static const String notifications = '/notifications/';
  static String notificationRead(String id) => '/notifications/$id/read/';
  static const String notificationsReadAll = '/notifications/read_all/';
  static const String notificationsUnreadCount = '/notifications/unread_count/';
  static const String devices = '/devices/';
}
