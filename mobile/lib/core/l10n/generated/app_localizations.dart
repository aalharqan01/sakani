import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Sakani'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @cheques.
  ///
  /// In en, this message translates to:
  /// **'Cheques'**
  String get cheques;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @qatarId.
  ///
  /// In en, this message translates to:
  /// **'Qatar ID (QID)'**
  String get qatarId;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chequeNumber.
  ///
  /// In en, this message translates to:
  /// **'Cheque Number'**
  String get chequeNumber;

  /// No description provided for @chequeDate.
  ///
  /// In en, this message translates to:
  /// **'Cheque Date'**
  String get chequeDate;

  /// No description provided for @chequeAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get chequeAmount;

  /// No description provided for @chequeBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get chequeBankName;

  /// No description provided for @chequeStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get chequeStatusPending;

  /// No description provided for @chequeStatusDeposited.
  ///
  /// In en, this message translates to:
  /// **'Deposited'**
  String get chequeStatusDeposited;

  /// No description provided for @chequeStatusCleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get chequeStatusCleared;

  /// No description provided for @chequeStatusBounced.
  ///
  /// In en, this message translates to:
  /// **'Bounced'**
  String get chequeStatusBounced;

  /// No description provided for @chequeStatusReplaced.
  ///
  /// In en, this message translates to:
  /// **'Replaced'**
  String get chequeStatusReplaced;

  /// No description provided for @upcomingCheques.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Cheques'**
  String get upcomingCheques;

  /// No description provided for @overdueCheques.
  ///
  /// In en, this message translates to:
  /// **'Overdue Cheques'**
  String get overdueCheques;

  /// No description provided for @addCheque.
  ///
  /// In en, this message translates to:
  /// **'Add Cheque'**
  String get addCheque;

  /// No description provided for @scanCheque.
  ///
  /// In en, this message translates to:
  /// **'Scan Cheque'**
  String get scanCheque;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @maintenanceCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get maintenanceCategory;

  /// No description provided for @categoryAc.
  ///
  /// In en, this message translates to:
  /// **'AC'**
  String get categoryAc;

  /// No description provided for @categoryPlumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get categoryPlumbing;

  /// No description provided for @categoryElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get categoryElectrical;

  /// No description provided for @categoryPainting.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get categoryPainting;

  /// No description provided for @categoryPestControl.
  ///
  /// In en, this message translates to:
  /// **'Pest Control'**
  String get categoryPestControl;

  /// No description provided for @categoryAppliance.
  ///
  /// In en, this message translates to:
  /// **'Appliance'**
  String get categoryAppliance;

  /// No description provided for @categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get categoryGeneral;

  /// No description provided for @urgencyRoutine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get urgencyRoutine;

  /// No description provided for @urgencyUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgencyUrgent;

  /// No description provided for @urgencyEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get urgencyEmergency;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @attachPhotos.
  ///
  /// In en, this message translates to:
  /// **'Attach Photos'**
  String get attachPhotos;

  /// No description provided for @compound.
  ///
  /// In en, this message translates to:
  /// **'Compound'**
  String get compound;

  /// No description provided for @building.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get building;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @tenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenant;

  /// No description provided for @landlord.
  ///
  /// In en, this message translates to:
  /// **'Landlord'**
  String get landlord;

  /// No description provided for @lease.
  ///
  /// In en, this message translates to:
  /// **'Lease'**
  String get lease;

  /// No description provided for @leaseStart.
  ///
  /// In en, this message translates to:
  /// **'Lease Start'**
  String get leaseStart;

  /// No description provided for @leaseEnd.
  ///
  /// In en, this message translates to:
  /// **'Lease End'**
  String get leaseEnd;

  /// No description provided for @monthlyRent.
  ///
  /// In en, this message translates to:
  /// **'Monthly Rent'**
  String get monthlyRent;

  /// No description provided for @qar.
  ///
  /// In en, this message translates to:
  /// **'QAR'**
  String get qar;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart living starts here'**
  String get loginTagline;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your home'**
  String get signInSubtitle;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'1234 5678'**
  String get phoneHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @nextPayment.
  ///
  /// In en, this message translates to:
  /// **'Next Payment'**
  String get nextPayment;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// No description provided for @dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get dueSoon;

  /// No description provided for @dueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueDateLabel(String date);

  /// No description provided for @chequesClearedProgress.
  ///
  /// In en, this message translates to:
  /// **'{cleared} of {total} cheques cleared'**
  String chequesClearedProgress(int cleared, int total);

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @payRent.
  ///
  /// In en, this message translates to:
  /// **'Pay Rent'**
  String get payRent;

  /// No description provided for @repair.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get repair;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noUpcomingCheques.
  ///
  /// In en, this message translates to:
  /// **'No upcoming cheques'**
  String get noUpcomingCheques;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @chequeDetail.
  ///
  /// In en, this message translates to:
  /// **'Cheque Detail'**
  String get chequeDetail;

  /// No description provided for @chequeNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Cheque #{number}'**
  String chequeNumberLabel(String number);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @noChequesFound.
  ///
  /// In en, this message translates to:
  /// **'No cheques found'**
  String get noChequesFound;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @payee.
  ///
  /// In en, this message translates to:
  /// **'Payee'**
  String get payee;

  /// No description provided for @property.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get property;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @chequeSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Cheque submitted'**
  String get chequeSubmitted;

  /// No description provided for @dateUnknown.
  ///
  /// In en, this message translates to:
  /// **'Date unknown'**
  String get dateUnknown;

  /// No description provided for @verifiedByLandlord.
  ///
  /// In en, this message translates to:
  /// **'Verified by landlord'**
  String get verifiedByLandlord;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @awaitingClearing.
  ///
  /// In en, this message translates to:
  /// **'Awaiting clearing'**
  String get awaitingClearing;

  /// No description provided for @scheduledForDate.
  ///
  /// In en, this message translates to:
  /// **'Scheduled for {date}'**
  String scheduledForDate(String date);

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @contactBank.
  ///
  /// In en, this message translates to:
  /// **'Contact Bank'**
  String get contactBank;

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newRequest;

  /// No description provided for @serviceCategories.
  ///
  /// In en, this message translates to:
  /// **'Service Categories'**
  String get serviceCategories;

  /// No description provided for @historySection.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historySection;

  /// No description provided for @noCompletedRequests.
  ///
  /// In en, this message translates to:
  /// **'No completed requests yet'**
  String get noCompletedRequests;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @quoted.
  ///
  /// In en, this message translates to:
  /// **'Quoted'**
  String get quoted;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Sakani today'**
  String get joinSubtitle;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @iAmA.
  ///
  /// In en, this message translates to:
  /// **'I am a...'**
  String get iAmA;

  /// No description provided for @roleTenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get roleTenant;

  /// No description provided for @roleLandlord.
  ///
  /// In en, this message translates to:
  /// **'Landlord / Manager'**
  String get roleLandlord;

  /// No description provided for @roleMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Team'**
  String get roleMaintenance;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameRequired;

  /// No description provided for @newMaintenanceRequest.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get newMaintenanceRequest;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'Brief summary of the issue'**
  String get titleHint;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get titleRequired;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue in detail...'**
  String get descriptionHint;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get descriptionRequired;

  /// No description provided for @urgencyLevel.
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get urgencyLevel;

  /// No description provided for @preferredDate.
  ///
  /// In en, this message translates to:
  /// **'Preferred Date'**
  String get preferredDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @requestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Maintenance request submitted successfully'**
  String get requestSubmitted;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tapToRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get tapToRetry;

  /// No description provided for @noItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No items yet'**
  String get noItemsYet;

  /// No description provided for @noCheques.
  ///
  /// In en, this message translates to:
  /// **'No cheques to show'**
  String get noCheques;

  /// No description provided for @noMaintenanceRequests.
  ///
  /// In en, this message translates to:
  /// **'No maintenance requests'**
  String get noMaintenanceRequests;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to server'**
  String get connectionError;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get checkConnection;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @markAsDeposited.
  ///
  /// In en, this message translates to:
  /// **'Mark as Deposited'**
  String get markAsDeposited;

  /// No description provided for @markAsCleared.
  ///
  /// In en, this message translates to:
  /// **'Mark as Cleared'**
  String get markAsCleared;

  /// No description provided for @markAsBounced.
  ///
  /// In en, this message translates to:
  /// **'Mark as Bounced'**
  String get markAsBounced;

  /// No description provided for @depositConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm that this cheque has been deposited at the bank?'**
  String get depositConfirm;

  /// No description provided for @clearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm that this cheque has been cleared successfully?'**
  String get clearConfirm;

  /// No description provided for @bounceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mark this cheque as bounced?'**
  String get bounceConfirm;

  /// No description provided for @bounceReason.
  ///
  /// In en, this message translates to:
  /// **'Bounce reason'**
  String get bounceReason;

  /// No description provided for @bounceReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Insufficient funds'**
  String get bounceReasonHint;

  /// No description provided for @chequeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Cheque status updated successfully'**
  String get chequeUpdated;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any notes (optional)'**
  String get notesHint;

  /// No description provided for @statusActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get statusActions;

  /// No description provided for @maintenanceDetail.
  ///
  /// In en, this message translates to:
  /// **'Request Detail'**
  String get maintenanceDetail;

  /// No description provided for @requestInfo.
  ///
  /// In en, this message translates to:
  /// **'Request Info'**
  String get requestInfo;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @urgency.
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get urgency;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @submittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submittedOn;

  /// No description provided for @scheduledFor.
  ///
  /// In en, this message translates to:
  /// **'Scheduled for'**
  String get scheduledFor;

  /// No description provided for @completedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedOn;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get assignedTo;

  /// No description provided for @notAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get notAssigned;

  /// No description provided for @quote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get quote;

  /// No description provided for @laborCost.
  ///
  /// In en, this message translates to:
  /// **'Labor Cost'**
  String get laborCost;

  /// No description provided for @materialCost.
  ///
  /// In en, this message translates to:
  /// **'Material Cost'**
  String get materialCost;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @estimatedDays.
  ///
  /// In en, this message translates to:
  /// **'Estimated Days'**
  String get estimatedDays;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysUnit(int count);

  /// No description provided for @acceptQuote.
  ///
  /// In en, this message translates to:
  /// **'Accept Quote'**
  String get acceptQuote;

  /// No description provided for @rejectQuote.
  ///
  /// In en, this message translates to:
  /// **'Reject Quote'**
  String get rejectQuote;

  /// No description provided for @acceptQuoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Accept this quote and proceed with the work?'**
  String get acceptQuoteConfirm;

  /// No description provided for @rejectQuoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reject this quote?'**
  String get rejectQuoteConfirm;

  /// No description provided for @quoteAccepted.
  ///
  /// In en, this message translates to:
  /// **'Quote accepted'**
  String get quoteAccepted;

  /// No description provided for @quoteRejected.
  ///
  /// In en, this message translates to:
  /// **'Quote rejected'**
  String get quoteRejected;

  /// No description provided for @markComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get markComplete;

  /// No description provided for @completeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mark this maintenance request as completed?'**
  String get completeConfirm;

  /// No description provided for @requestCompleted.
  ///
  /// In en, this message translates to:
  /// **'Request marked as completed'**
  String get requestCompleted;

  /// No description provided for @rateService.
  ///
  /// In en, this message translates to:
  /// **'Rate Service'**
  String get rateService;

  /// No description provided for @rateServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How was the maintenance service?'**
  String get rateServiceSubtitle;

  /// No description provided for @ratingComment.
  ///
  /// In en, this message translates to:
  /// **'Leave a comment (optional)'**
  String get ratingComment;

  /// No description provided for @submitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get submitRating;

  /// No description provided for @ratingSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback'**
  String get ratingSubmitted;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// No description provided for @sendComment.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendComment;

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noComments;

  /// No description provided for @statusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get statusSubmitted;

  /// No description provided for @statusAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get statusAcknowledged;

  /// No description provided for @statusQuoted.
  ///
  /// In en, this message translates to:
  /// **'Quoted'**
  String get statusQuoted;

  /// No description provided for @statusQuoteAccepted.
  ///
  /// In en, this message translates to:
  /// **'Quote Accepted'**
  String get statusQuoteAccepted;

  /// No description provided for @statusQuoteRejected.
  ///
  /// In en, this message translates to:
  /// **'Quote Rejected'**
  String get statusQuoteRejected;

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get statusScheduled;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @notificationsChequeReminder.
  ///
  /// In en, this message translates to:
  /// **'Cheque Reminder'**
  String get notificationsChequeReminder;

  /// No description provided for @notificationsChequeBounced.
  ///
  /// In en, this message translates to:
  /// **'Cheque Bounced'**
  String get notificationsChequeBounced;

  /// No description provided for @notificationsChequeCleared.
  ///
  /// In en, this message translates to:
  /// **'Cheque Cleared'**
  String get notificationsChequeCleared;

  /// No description provided for @notificationsMaintenanceUpdate.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Update'**
  String get notificationsMaintenanceUpdate;

  /// No description provided for @notificationsMaintenanceQuote.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Quote'**
  String get notificationsMaintenanceQuote;

  /// No description provided for @notificationsLeaseExpiry.
  ///
  /// In en, this message translates to:
  /// **'Lease Expiry'**
  String get notificationsLeaseExpiry;

  /// No description provided for @notificationsAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get notificationsAnnouncement;

  /// No description provided for @notificationsSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notificationsSystem;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
