// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سكني';

  @override
  String get home => 'الرئيسية';

  @override
  String get cheques => 'الشيكات';

  @override
  String get maintenance => 'الصيانة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get units => 'الوحدات';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get tickets => 'التذاكر';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get qatarId => 'الرقم الشخصي (QID)';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get chequeNumber => 'رقم الشيك';

  @override
  String get chequeDate => 'تاريخ الشيك';

  @override
  String get chequeAmount => 'المبلغ';

  @override
  String get chequeBankName => 'اسم البنك';

  @override
  String get chequeStatusPending => 'قيد الانتظار';

  @override
  String get chequeStatusDeposited => 'تم الإيداع';

  @override
  String get chequeStatusCleared => 'تم التحصيل';

  @override
  String get chequeStatusBounced => 'مرتجع';

  @override
  String get chequeStatusReplaced => 'تم الاستبدال';

  @override
  String get upcomingCheques => 'الشيكات القادمة';

  @override
  String get overdueCheques => 'الشيكات المتأخرة';

  @override
  String get addCheque => 'إضافة شيك';

  @override
  String get scanCheque => 'مسح الشيك';

  @override
  String get submitRequest => 'تقديم طلب';

  @override
  String get maintenanceCategory => 'نوع الصيانة';

  @override
  String get categoryAc => 'تكييف';

  @override
  String get categoryPlumbing => 'سباكة';

  @override
  String get categoryElectrical => 'كهرباء';

  @override
  String get categoryPainting => 'دهان';

  @override
  String get categoryPestControl => 'مكافحة حشرات';

  @override
  String get categoryAppliance => 'أجهزة';

  @override
  String get categoryGeneral => 'عام';

  @override
  String get urgencyRoutine => 'عادي';

  @override
  String get urgencyUrgent => 'عاجل';

  @override
  String get urgencyEmergency => 'طوارئ';

  @override
  String get description => 'الوصف';

  @override
  String get attachPhotos => 'إرفاق صور';

  @override
  String get compound => 'المجمع السكني';

  @override
  String get building => 'المبنى';

  @override
  String get unit => 'الوحدة';

  @override
  String get tenant => 'المستأجر';

  @override
  String get landlord => 'المالك';

  @override
  String get lease => 'عقد الإيجار';

  @override
  String get leaseStart => 'بداية العقد';

  @override
  String get leaseEnd => 'نهاية العقد';

  @override
  String get monthlyRent => 'الإيجار الشهري';

  @override
  String get qar => 'ر.ق';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get search => 'بحث';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'حدث خطأ';

  @override
  String get success => 'تم بنجاح';

  @override
  String get loginTagline => 'العيش الذكي يبدأ من هنا';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInSubtitle => 'سجّل دخولك لإدارة منزلك';

  @override
  String get phoneHint => '١٢٣٤ ٥٦٧٨';

  @override
  String get forgotPassword => 'نسيت؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get orContinueWith => 'أو تابع بواسطة';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get nextPayment => 'الدفعة القادمة';

  @override
  String get onTrack => 'في الموعد';

  @override
  String get dueSoon => 'مستحق قريباً';

  @override
  String dueDateLabel(String date) {
    return 'مستحق $date';
  }

  @override
  String chequesClearedProgress(int cleared, int total) {
    return '$cleared من $total شيكات تم تحصيلها';
  }

  @override
  String get scan => 'مسح';

  @override
  String get payRent => 'دفع الإيجار';

  @override
  String get repair => 'إصلاح';

  @override
  String get utilities => 'خدمات';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get noUpcomingCheques => 'لا توجد شيكات قادمة';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get chequeDetail => 'تفاصيل الشيك';

  @override
  String chequeNumberLabel(String number) {
    return 'شيك #$number';
  }

  @override
  String get all => 'الكل';

  @override
  String get upcoming => 'القادمة';

  @override
  String get noChequesFound => 'لا توجد شيكات';

  @override
  String get bank => 'البنك';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get payee => 'المستفيد';

  @override
  String get property => 'العقار';

  @override
  String get timeline => 'الجدول الزمني';

  @override
  String get chequeSubmitted => 'تم تقديم الشيك';

  @override
  String get dateUnknown => 'التاريخ غير معروف';

  @override
  String get verifiedByLandlord => 'تم التحقق من المالك';

  @override
  String get verified => 'تم التحقق';

  @override
  String get awaitingClearing => 'بانتظار التحصيل';

  @override
  String scheduledForDate(String date) {
    return 'مجدول في $date';
  }

  @override
  String get download => 'تحميل';

  @override
  String get contactBank => 'اتصل بالبنك';

  @override
  String get newRequest => 'جديد';

  @override
  String get serviceCategories => 'فئات الخدمات';

  @override
  String get historySection => 'السجل';

  @override
  String get noCompletedRequests => 'لا توجد طلبات مكتملة بعد';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get done => 'مكتمل';

  @override
  String get logoutConfirmMessage => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinSubtitle => 'انضم إلى سكني اليوم';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get iAmA => 'أنا...';

  @override
  String get roleTenant => 'مستأجر';

  @override
  String get roleLandlord => 'مالك / مدير';

  @override
  String get roleMaintenance => 'فريق الصيانة';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get pleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get nameRequired => 'يرجى إدخال الاسم';

  @override
  String get newMaintenanceRequest => 'طلب جديد';

  @override
  String get selectCategory => 'اختر الفئة';

  @override
  String get titleLabel => 'العنوان';

  @override
  String get titleHint => 'ملخص موجز للمشكلة';

  @override
  String get titleRequired => 'يرجى إدخال العنوان';

  @override
  String get descriptionHint => 'صف المشكلة بالتفصيل...';

  @override
  String get descriptionRequired => 'يرجى إدخال الوصف';

  @override
  String get urgencyLevel => 'مستوى الأولوية';

  @override
  String get preferredDate => 'التاريخ المفضل';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get submitting => 'جاري الإرسال...';

  @override
  String get requestSubmitted => 'تم تقديم طلب الصيانة بنجاح';

  @override
  String get optional => 'اختياري';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get tapToRetry => 'اضغط لإعادة المحاولة';

  @override
  String get noItemsYet => 'لا توجد عناصر بعد';

  @override
  String get noCheques => 'لا توجد شيكات للعرض';

  @override
  String get noMaintenanceRequests => 'لا توجد طلبات صيانة';

  @override
  String get pullToRefresh => 'اسحب للتحديث';

  @override
  String get connectionError => 'تعذر الاتصال بالخادم';

  @override
  String get checkConnection =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';
}
