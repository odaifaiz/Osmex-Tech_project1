// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سيتي فيكس';

  @override
  String get home => 'الرئيسية';

  @override
  String get myReports => 'بلاغاتي';

  @override
  String get map => 'الخريطة';

  @override
  String get settings => 'الإعدادات';

  @override
  String welcome(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get communityBetter => 'لمجتمع أفضل';

  @override
  String get totalReports => 'إجمالي البلاغات';

  @override
  String get resolved => 'تم الحل';

  @override
  String get inProgress => 'قيد المعالجة';

  @override
  String get recentReports => 'آخر بلاغاتي';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get createReport => 'إنشاء بلاغ';

  @override
  String get noReports => 'لا توجد بلاغات';

  @override
  String get createFirstReport => 'قم بإنشاء أول بلاغ لك الآن';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errorLoadingReports => 'حدث خطأ في تحميل البلاغات';

  @override
  String get statusPending => 'جديد';

  @override
  String get statusInProgress => 'قيد المعالجة';

  @override
  String get statusResolved => 'تم الحل';

  @override
  String get statusRejected => 'مرفوض';

  @override
  String get statusClosed => 'مغلق';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get reportDetails => 'تفاصيل البلاغ';

  @override
  String get reportNumber => 'رقم البلاغ';

  @override
  String get onMap => 'الخريطة';

  @override
  String get reportDescription => 'وصف البلاغ';

  @override
  String get ratingText => 'شاركنا رأيك لتحسين الخدمة';

  @override
  String get rateNow => 'قيم الآن';

  @override
  String get timeline => 'مراحل التنفيذ';

  @override
  String get timelineCreated => 'تم إنشاء البلاغ';

  @override
  String get timelineReceived => 'تم استلام البلاغ';

  @override
  String get timelineInProgress => 'تمت المعالجة';

  @override
  String get timelineResolved => 'تم حل المشكلة';

  @override
  String get timelineClosed => 'إغلاق البلاغ';

  @override
  String get pendingWait => 'قيد الانتظار';

  @override
  String get reviewWait => 'في انتظار المراجعة';

  @override
  String get share => 'مشاركة';

  @override
  String get copyNumber => 'نسخ الرقم';

  @override
  String get numberCopied => 'تم نسخ رقم البلاغ';

  @override
  String get reportNotFound => 'لم يتم العثور على البلاغ';

  @override
  String get reportSent => 'تم إرسال البلاغ';

  @override
  String get successTitle => 'تم الإرسال بنجاح!';

  @override
  String get successMessage => 'شكراً لمساهمتك في تحسين مدينتك!';

  @override
  String get reportIdLabel => 'رقم البلاغ';

  @override
  String get reviewPeriod => 'سيتم المراجعة خلال 24 ساعة';

  @override
  String get viewMyReports => 'عرض صفحة بلاغاتي';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get failureTitle => 'فشل إرسال البلاغ';

  @override
  String get reportFailure =>
      'فشلت عملية إرسال البلاغ. يرجى التأكد من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get saveDraft => 'حفظ في المسودات';

  @override
  String get mapTitle => 'خريطة البلاغات';

  @override
  String get searchMapHint => 'ابحث برقم البلاغ، العنوان، أو الموقع...';

  @override
  String get loadingMap => 'جاري تحميل الخريطة...';

  @override
  String get all => 'الكل';

  @override
  String get filterNew => 'جديد';

  @override
  String get filterInProgress => 'قيد المعالجة';

  @override
  String get filterResolved => 'محلول';

  @override
  String get filterClosed => 'مغلق';

  @override
  String get analyticsTitle => 'تحليل المنطقة المحيطة';

  @override
  String get nearbyReportsCount => 'بلاغات أخرى قريبة';

  @override
  String get responseTime => 'متوسط وقت الاستجابة';

  @override
  String get lastReport => 'آخر بلاغ';

  @override
  String get days => 'يوم';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get navigate => 'توجيه';

  @override
  String similarReportAlert(int distance) {
    return 'يوجد بلاغ مشابه على بعد $distance متر';
  }

  @override
  String get similarReportNote =>
      'تم رصد بلاغ مماثل مؤخراً في هذا النطاق الجغرافي. يرجى التحقق من التفاصيل لتجنب التكرار.';

  @override
  String get viewExistingReport => 'عرض البلاغ الموجود';

  @override
  String get createNewReport => 'إنشاء بلاغ جديد';

  @override
  String get expandSearch => 'توسيع نطاق البحث';

  @override
  String get showAnalytics => 'عرض التحليل الذكي';

  @override
  String get pendingNearby => 'بلاغات قيد الانتظار';

  @override
  String get nearbyFound => 'بلاغات قريبة';

  @override
  String get avgResponse => 'متوسط وقت الاستجابة';

  @override
  String get lastReported => 'آخر بلاغ';

  @override
  String get similarReportFound => 'بلاغ مشابه في هذه المنطقة';

  @override
  String get viewExisting => 'مشاهدة البلاغ الحالي';

  @override
  String get createNewAnyway => 'إنشاء بلاغ جديد على كل حال';

  @override
  String get reviewReport => 'مراجعة البلاغ';

  @override
  String get attachedImages => 'الصور المرفقة';

  @override
  String imagesCount(int count) {
    return '$count صور';
  }

  @override
  String get noImages => 'لا توجد صور مرفقة';

  @override
  String get declarationText => 'أقر بأن جميع المعلومات المقدمة صحيحة ودقيقة';

  @override
  String get confirmAndSend => 'تأكيد وإرسال ➤';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String get loginFirst => 'يجب تسجيل الدخول أولاً لإرسال بلاغ';

  @override
  String get categoryError => 'حدث خطأ في تحديد التصنيف';

  @override
  String get confirmationTitle => 'تأكيد الإرسال';

  @override
  String get confirmationMessage =>
      'سيتم حفظ البلاغ محلياً ومزامنته فور توفر الإنترنت.';

  @override
  String get warning => 'تنبيه';

  @override
  String get activateDeclaration => 'يرجى تفعيل مربع الإقرار قبل إرسال البلاغ.';

  @override
  String get ok => 'حسناً';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get reportTitleLabel => 'عنوان البلاغ';

  @override
  String get urgentReport => 'بلاغ طارئ';

  @override
  String get profile => 'ملفي الشخصي';

  @override
  String get edit => 'تعديل';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmTitle => 'تأكيد تسجيل الخروج';

  @override
  String get logoutConfirmMessage => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get createReportTitle => 'إنشاء بلاغ جديد';

  @override
  String get captureImage => 'التقط صورة للمشكلة (1-4 صور)';

  @override
  String get category => 'التصنيف';

  @override
  String get selectCategory => 'اختر التصنيف';

  @override
  String get reportTitleHint => 'مثال: حفرة في منتصف الطريق';

  @override
  String get location => 'الموقع';

  @override
  String get descriptionHint => 'يرجى كتابة تفاصيل المشكلة هنا...';

  @override
  String get urgentText => 'مشكلة طارئة؟';

  @override
  String get continueText => 'متابعة ←';

  @override
  String get selectLocationError => 'الرجاء تحديد موقع المشكلة';

  @override
  String get selectCategoryError => 'الرجاء اختيار تصنيف المشكلة';

  @override
  String get selectTitleError => 'الرجاء إدخال عنوان المشكلة';

  @override
  String get selectDescriptionError => 'الرجاء إدخال وصف المشكلة';

  @override
  String get search => 'بحث';

  @override
  String get drafts => 'المسودات';

  @override
  String get latestReports => 'آخر البلاغات';

  @override
  String get total => 'الإجمالي';

  @override
  String get accountSecurity => 'الحساب والأمان';

  @override
  String get notifications => 'التنبيهات';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get supportHelp => 'الدعم والمساعدة';

  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get chooseTheme => 'اختر المظهر';

  @override
  String get autoSystem => 'تلقائي (حسب النظام)';

  @override
  String get language => 'اللغة';

  @override
  String get appearance => 'المظهر';

  @override
  String get fontSize => 'حجم الخط';

  @override
  String get clearCache => 'مسح التخزين المؤقت';

  @override
  String get cacheCleared => 'تم مسح التخزين المؤقت بنجاح';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'تلقائي';

  @override
  String get small => 'صغير';

  @override
  String get medium => 'متوسط';

  @override
  String get large => 'كبير';

  @override
  String get veryLarge => 'كبير جداً';

  @override
  String get back => 'رجوع';
}
