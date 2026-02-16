// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sakani';

  @override
  String get home => 'Home';

  @override
  String get cheques => 'Cheques';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get profile => 'Profile';

  @override
  String get units => 'Units';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get tickets => 'Tickets';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get phone => 'Phone Number';

  @override
  String get fullName => 'Full Name';

  @override
  String get qatarId => 'Qatar ID (QID)';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get chequeNumber => 'Cheque Number';

  @override
  String get chequeDate => 'Cheque Date';

  @override
  String get chequeAmount => 'Amount';

  @override
  String get chequeBankName => 'Bank Name';

  @override
  String get chequeStatusPending => 'Pending';

  @override
  String get chequeStatusDeposited => 'Deposited';

  @override
  String get chequeStatusCleared => 'Cleared';

  @override
  String get chequeStatusBounced => 'Bounced';

  @override
  String get chequeStatusReplaced => 'Replaced';

  @override
  String get upcomingCheques => 'Upcoming Cheques';

  @override
  String get overdueCheques => 'Overdue Cheques';

  @override
  String get addCheque => 'Add Cheque';

  @override
  String get scanCheque => 'Scan Cheque';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get maintenanceCategory => 'Category';

  @override
  String get categoryAc => 'AC';

  @override
  String get categoryPlumbing => 'Plumbing';

  @override
  String get categoryElectrical => 'Electrical';

  @override
  String get categoryPainting => 'Painting';

  @override
  String get categoryPestControl => 'Pest Control';

  @override
  String get categoryAppliance => 'Appliance';

  @override
  String get categoryGeneral => 'General';

  @override
  String get urgencyRoutine => 'Routine';

  @override
  String get urgencyUrgent => 'Urgent';

  @override
  String get urgencyEmergency => 'Emergency';

  @override
  String get description => 'Description';

  @override
  String get attachPhotos => 'Attach Photos';

  @override
  String get compound => 'Compound';

  @override
  String get building => 'Building';

  @override
  String get unit => 'Unit';

  @override
  String get tenant => 'Tenant';

  @override
  String get landlord => 'Landlord';

  @override
  String get lease => 'Lease';

  @override
  String get leaseStart => 'Lease Start';

  @override
  String get leaseEnd => 'Lease End';

  @override
  String get monthlyRent => 'Monthly Rent';

  @override
  String get qar => 'QAR';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get noData => 'No data available';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred';

  @override
  String get success => 'Success';

  @override
  String get loginTagline => 'Smart living starts here';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to manage your home';

  @override
  String get phoneHint => '1234 5678';

  @override
  String get forgotPassword => 'Forgot?';

  @override
  String get signIn => 'Sign In';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign up';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get nextPayment => 'Next Payment';

  @override
  String get onTrack => 'On Track';

  @override
  String get dueSoon => 'Due soon';

  @override
  String dueDateLabel(String date) {
    return 'Due $date';
  }

  @override
  String chequesClearedProgress(int cleared, int total) {
    return '$cleared of $total cheques cleared';
  }

  @override
  String get scan => 'Scan';

  @override
  String get payRent => 'Pay Rent';

  @override
  String get repair => 'Repair';

  @override
  String get utilities => 'Utilities';

  @override
  String get seeAll => 'See all';

  @override
  String get noUpcomingCheques => 'No upcoming cheques';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get chequeDetail => 'Cheque Detail';

  @override
  String chequeNumberLabel(String number) {
    return 'Cheque #$number';
  }

  @override
  String get all => 'All';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get noChequesFound => 'No cheques found';

  @override
  String get bank => 'Bank';

  @override
  String get dueDate => 'Due Date';

  @override
  String get payee => 'Payee';

  @override
  String get property => 'Property';

  @override
  String get timeline => 'Timeline';

  @override
  String get chequeSubmitted => 'Cheque submitted';

  @override
  String get dateUnknown => 'Date unknown';

  @override
  String get verifiedByLandlord => 'Verified by landlord';

  @override
  String get verified => 'Verified';

  @override
  String get awaitingClearing => 'Awaiting clearing';

  @override
  String scheduledForDate(String date) {
    return 'Scheduled for $date';
  }

  @override
  String get download => 'Download';

  @override
  String get contactBank => 'Contact Bank';

  @override
  String get newRequest => 'New';

  @override
  String get serviceCategories => 'Service Categories';

  @override
  String get historySection => 'History';

  @override
  String get noCompletedRequests => 'No completed requests yet';

  @override
  String get categoryOther => 'Other';

  @override
  String get inProgress => 'In Progress';

  @override
  String get done => 'Done';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinSubtitle => 'Join Sakani today';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get iAmA => 'I am a...';

  @override
  String get roleTenant => 'Tenant';

  @override
  String get roleLandlord => 'Landlord / Manager';

  @override
  String get roleMaintenance => 'Maintenance Team';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get nameRequired => 'Please enter your name';

  @override
  String get newMaintenanceRequest => 'New Request';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get titleLabel => 'Title';

  @override
  String get titleHint => 'Brief summary of the issue';

  @override
  String get titleRequired => 'Please enter a title';

  @override
  String get descriptionHint => 'Describe the issue in detail...';

  @override
  String get descriptionRequired => 'Please enter a description';

  @override
  String get urgencyLevel => 'Urgency';

  @override
  String get preferredDate => 'Preferred Date';

  @override
  String get selectDate => 'Select date';

  @override
  String get submitting => 'Submitting...';

  @override
  String get requestSubmitted => 'Maintenance request submitted successfully';

  @override
  String get optional => 'Optional';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tapToRetry => 'Tap to retry';

  @override
  String get noItemsYet => 'No items yet';

  @override
  String get noCheques => 'No cheques to show';

  @override
  String get noMaintenanceRequests => 'No maintenance requests';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get connectionError => 'Could not connect to server';

  @override
  String get checkConnection =>
      'Please check your internet connection and try again';

  @override
  String get comingSoon => 'Coming soon';
}
