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
/// import 'l10n/app_localizations.dart';
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

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'سيتي فيكس'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @myReports.
  ///
  /// In ar, this message translates to:
  /// **'بلاغاتي'**
  String get myReports;

  /// No description provided for @map.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get map;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً، {name}'**
  String welcome(String name);

  /// No description provided for @communityBetter.
  ///
  /// In ar, this message translates to:
  /// **'لمجتمع أفضل'**
  String get communityBetter;

  /// No description provided for @totalReports.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي البلاغات'**
  String get totalReports;

  /// No description provided for @resolved.
  ///
  /// In ar, this message translates to:
  /// **'تم الحل'**
  String get resolved;

  /// No description provided for @inProgress.
  ///
  /// In ar, this message translates to:
  /// **'قيد المعالجة'**
  String get inProgress;

  /// No description provided for @recentReports.
  ///
  /// In ar, this message translates to:
  /// **'آخر بلاغاتي'**
  String get recentReports;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @createReport.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء بلاغ'**
  String get createReport;

  /// No description provided for @noReports.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بلاغات'**
  String get noReports;

  /// No description provided for @createFirstReport.
  ///
  /// In ar, this message translates to:
  /// **'قم بإنشاء أول بلاغ لك الآن'**
  String get createFirstReport;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @errorLoadingReports.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في تحميل البلاغات'**
  String get errorLoadingReports;

  /// No description provided for @statusPending.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get statusPending;

  /// No description provided for @statusInProgress.
  ///
  /// In ar, this message translates to:
  /// **'قيد المعالجة'**
  String get statusInProgress;

  /// No description provided for @statusResolved.
  ///
  /// In ar, this message translates to:
  /// **'تم الحل'**
  String get statusResolved;

  /// No description provided for @statusRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get statusRejected;

  /// No description provided for @statusClosed.
  ///
  /// In ar, this message translates to:
  /// **'مغلق'**
  String get statusClosed;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In ar, this message translates to:
  /// **'أمس'**
  String get yesterday;

  /// No description provided for @reportDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل البلاغ'**
  String get reportDetails;

  /// No description provided for @reportNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم البلاغ'**
  String get reportNumber;

  /// No description provided for @onMap.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get onMap;

  /// No description provided for @reportDescription.
  ///
  /// In ar, this message translates to:
  /// **'وصف البلاغ'**
  String get reportDescription;

  /// No description provided for @ratingText.
  ///
  /// In ar, this message translates to:
  /// **'شاركنا رأيك لتحسين الخدمة'**
  String get ratingText;

  /// No description provided for @rateNow.
  ///
  /// In ar, this message translates to:
  /// **'قيم الآن'**
  String get rateNow;

  /// No description provided for @timeline.
  ///
  /// In ar, this message translates to:
  /// **'مراحل التنفيذ'**
  String get timeline;

  /// No description provided for @timelineCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء البلاغ'**
  String get timelineCreated;

  /// No description provided for @timelineReceived.
  ///
  /// In ar, this message translates to:
  /// **'تم استلام البلاغ'**
  String get timelineReceived;

  /// No description provided for @timelineInProgress.
  ///
  /// In ar, this message translates to:
  /// **'تمت المعالجة'**
  String get timelineInProgress;

  /// No description provided for @timelineResolved.
  ///
  /// In ar, this message translates to:
  /// **'تم حل المشكلة'**
  String get timelineResolved;

  /// No description provided for @timelineClosed.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق البلاغ'**
  String get timelineClosed;

  /// No description provided for @pendingWait.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار'**
  String get pendingWait;

  /// No description provided for @reviewWait.
  ///
  /// In ar, this message translates to:
  /// **'في انتظار المراجعة'**
  String get reviewWait;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get share;

  /// No description provided for @copyNumber.
  ///
  /// In ar, this message translates to:
  /// **'نسخ الرقم'**
  String get copyNumber;

  /// No description provided for @numberCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ رقم البلاغ'**
  String get numberCopied;

  /// No description provided for @reportNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على البلاغ'**
  String get reportNotFound;

  /// No description provided for @reportSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال البلاغ'**
  String get reportSent;

  /// No description provided for @successTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم الإرسال بنجاح!'**
  String get successTitle;

  /// No description provided for @successMessage.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لمساهمتك في تحسين مدينتك!'**
  String get successMessage;

  /// No description provided for @reportIdLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم البلاغ'**
  String get reportIdLabel;

  /// No description provided for @reviewPeriod.
  ///
  /// In ar, this message translates to:
  /// **'سيتم المراجعة خلال 24 ساعة'**
  String get reviewPeriod;

  /// No description provided for @viewMyReports.
  ///
  /// In ar, this message translates to:
  /// **'عرض صفحة بلاغاتي'**
  String get viewMyReports;

  /// No description provided for @backToHome.
  ///
  /// In ar, this message translates to:
  /// **'العودة للرئيسية'**
  String get backToHome;

  /// No description provided for @failureTitle.
  ///
  /// In ar, this message translates to:
  /// **'فشل إرسال البلاغ'**
  String get failureTitle;

  /// No description provided for @reportFailure.
  ///
  /// In ar, this message translates to:
  /// **'فشلت عملية إرسال البلاغ. يرجى التأكد من اتصالك بالإنترنت والمحاولة مرة أخرى.'**
  String get reportFailure;

  /// No description provided for @saveDraft.
  ///
  /// In ar, this message translates to:
  /// **'حفظ في المسودات'**
  String get saveDraft;

  /// No description provided for @mapTitle.
  ///
  /// In ar, this message translates to:
  /// **'خريطة البلاغات'**
  String get mapTitle;

  /// No description provided for @searchMapHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث برقم البلاغ، العنوان، أو الموقع...'**
  String get searchMapHint;

  /// No description provided for @loadingMap.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الخريطة...'**
  String get loadingMap;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @filterNew.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get filterNew;

  /// No description provided for @filterInProgress.
  ///
  /// In ar, this message translates to:
  /// **'قيد المعالجة'**
  String get filterInProgress;

  /// No description provided for @filterResolved.
  ///
  /// In ar, this message translates to:
  /// **'محلول'**
  String get filterResolved;

  /// No description provided for @filterClosed.
  ///
  /// In ar, this message translates to:
  /// **'مغلق'**
  String get filterClosed;

  /// No description provided for @analyticsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحليل المنطقة المحيطة'**
  String get analyticsTitle;

  /// No description provided for @nearbyReportsCount.
  ///
  /// In ar, this message translates to:
  /// **'بلاغات أخرى قريبة'**
  String get nearbyReportsCount;

  /// No description provided for @responseTime.
  ///
  /// In ar, this message translates to:
  /// **'متوسط وقت الاستجابة'**
  String get responseTime;

  /// No description provided for @lastReport.
  ///
  /// In ar, this message translates to:
  /// **'آخر بلاغ'**
  String get lastReport;

  /// No description provided for @days.
  ///
  /// In ar, this message translates to:
  /// **'يوم'**
  String get days;

  /// No description provided for @viewDetails.
  ///
  /// In ar, this message translates to:
  /// **'عرض التفاصيل'**
  String get viewDetails;

  /// No description provided for @navigate.
  ///
  /// In ar, this message translates to:
  /// **'توجيه'**
  String get navigate;

  /// No description provided for @similarReportAlert.
  ///
  /// In ar, this message translates to:
  /// **'يوجد بلاغ مشابه على بعد {distance} متر'**
  String similarReportAlert(int distance);

  /// No description provided for @similarReportNote.
  ///
  /// In ar, this message translates to:
  /// **'تم رصد بلاغ مماثل مؤخراً في هذا النطاق الجغرافي. يرجى التحقق من التفاصيل لتجنب التكرار.'**
  String get similarReportNote;

  /// No description provided for @viewExistingReport.
  ///
  /// In ar, this message translates to:
  /// **'عرض البلاغ الموجود'**
  String get viewExistingReport;

  /// No description provided for @createNewReport.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء بلاغ جديد'**
  String get createNewReport;

  /// No description provided for @expandSearch.
  ///
  /// In ar, this message translates to:
  /// **'توسيع نطاق البحث'**
  String get expandSearch;

  /// No description provided for @showAnalytics.
  ///
  /// In ar, this message translates to:
  /// **'عرض التحليل الذكي'**
  String get showAnalytics;

  /// No description provided for @pendingNearby.
  ///
  /// In ar, this message translates to:
  /// **'بلاغات قيد الانتظار'**
  String get pendingNearby;

  /// No description provided for @nearbyFound.
  ///
  /// In ar, this message translates to:
  /// **'بلاغات قريبة'**
  String get nearbyFound;

  /// No description provided for @avgResponse.
  ///
  /// In ar, this message translates to:
  /// **'متوسط وقت الاستجابة'**
  String get avgResponse;

  /// No description provided for @lastReported.
  ///
  /// In ar, this message translates to:
  /// **'آخر بلاغ'**
  String get lastReported;

  /// No description provided for @similarReportFound.
  ///
  /// In ar, this message translates to:
  /// **'بلاغ مشابه في هذه المنطقة'**
  String get similarReportFound;

  /// No description provided for @viewExisting.
  ///
  /// In ar, this message translates to:
  /// **'مشاهدة البلاغ الحالي'**
  String get viewExisting;

  /// No description provided for @createNewAnyway.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء بلاغ جديد على كل حال'**
  String get createNewAnyway;

  /// No description provided for @reviewReport.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة البلاغ'**
  String get reviewReport;

  /// No description provided for @attachedImages.
  ///
  /// In ar, this message translates to:
  /// **'الصور المرفقة'**
  String get attachedImages;

  /// No description provided for @imagesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} صور'**
  String imagesCount(int count);

  /// No description provided for @noImages.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد صور مرفقة'**
  String get noImages;

  /// No description provided for @declarationText.
  ///
  /// In ar, this message translates to:
  /// **'أقر بأن جميع المعلومات المقدمة صحيحة ودقيقة'**
  String get declarationText;

  /// No description provided for @confirmAndSend.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد وإرسال ➤'**
  String get confirmAndSend;

  /// No description provided for @saving.
  ///
  /// In ar, this message translates to:
  /// **'جاري الحفظ...'**
  String get saving;

  /// No description provided for @loginFirst.
  ///
  /// In ar, this message translates to:
  /// **'يجب تسجيل الدخول أولاً لإرسال بلاغ'**
  String get loginFirst;

  /// No description provided for @categoryError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في تحديد التصنيف'**
  String get categoryError;

  /// No description provided for @confirmationTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الإرسال'**
  String get confirmationTitle;

  /// No description provided for @confirmationMessage.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حفظ البلاغ محلياً ومزامنته فور توفر الإنترنت.'**
  String get confirmationMessage;

  /// No description provided for @warning.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه'**
  String get warning;

  /// No description provided for @activateDeclaration.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تفعيل مربع الإقرار قبل إرسال البلاغ.'**
  String get activateDeclaration;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get ok;

  /// No description provided for @categoryLabel.
  ///
  /// In ar, this message translates to:
  /// **'الفئة'**
  String get categoryLabel;

  /// No description provided for @reportTitleLabel.
  ///
  /// In ar, this message translates to:
  /// **'عنوان البلاغ'**
  String get reportTitleLabel;

  /// No description provided for @urgentReport.
  ///
  /// In ar, this message translates to:
  /// **'بلاغ طارئ'**
  String get urgentReport;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'ملفي الشخصي'**
  String get profile;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد تسجيل الخروج'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من رغبتك في تسجيل الخروج؟'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @createReportTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء بلاغ جديد'**
  String get createReportTitle;

  /// No description provided for @captureImage.
  ///
  /// In ar, this message translates to:
  /// **'التقط صورة للمشكلة (1-4 صور)'**
  String get captureImage;

  /// No description provided for @category.
  ///
  /// In ar, this message translates to:
  /// **'التصنيف'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In ar, this message translates to:
  /// **'اختر التصنيف'**
  String get selectCategory;

  /// No description provided for @reportTitleHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: حفرة في منتصف الطريق'**
  String get reportTitleHint;

  /// No description provided for @location.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get location;

  /// No description provided for @descriptionHint.
  ///
  /// In ar, this message translates to:
  /// **'يرجى كتابة تفاصيل المشكلة هنا...'**
  String get descriptionHint;

  /// No description provided for @urgentText.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة طارئة؟'**
  String get urgentText;

  /// No description provided for @continueText.
  ///
  /// In ar, this message translates to:
  /// **'متابعة ←'**
  String get continueText;

  /// No description provided for @selectLocationError.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء تحديد موقع المشكلة'**
  String get selectLocationError;

  /// No description provided for @selectCategoryError.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تصنيف المشكلة'**
  String get selectCategoryError;

  /// No description provided for @selectTitleError.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال عنوان المشكلة'**
  String get selectTitleError;

  /// No description provided for @selectDescriptionError.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال وصف المشكلة'**
  String get selectDescriptionError;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @drafts.
  ///
  /// In ar, this message translates to:
  /// **'المسودات'**
  String get drafts;

  /// No description provided for @latestReports.
  ///
  /// In ar, this message translates to:
  /// **'آخر البلاغات'**
  String get latestReports;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get total;

  /// No description provided for @accountSecurity.
  ///
  /// In ar, this message translates to:
  /// **'الحساب والأمان'**
  String get accountSecurity;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'التنبيهات'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية'**
  String get privacy;

  /// No description provided for @supportHelp.
  ///
  /// In ar, this message translates to:
  /// **'الدعم والمساعدة'**
  String get supportHelp;

  /// No description provided for @aboutApp.
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get aboutApp;

  /// No description provided for @appSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات التطبيق'**
  String get appSettings;

  /// No description provided for @chooseLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اختر اللغة'**
  String get chooseLanguage;

  /// No description provided for @chooseTheme.
  ///
  /// In ar, this message translates to:
  /// **'اختر المظهر'**
  String get chooseTheme;

  /// No description provided for @autoSystem.
  ///
  /// In ar, this message translates to:
  /// **'تلقائي (حسب النظام)'**
  String get autoSystem;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @appearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get appearance;

  /// No description provided for @fontSize.
  ///
  /// In ar, this message translates to:
  /// **'حجم الخط'**
  String get fontSize;

  /// No description provided for @clearCache.
  ///
  /// In ar, this message translates to:
  /// **'مسح التخزين المؤقت'**
  String get clearCache;

  /// No description provided for @cacheCleared.
  ///
  /// In ar, this message translates to:
  /// **'تم مسح التخزين المؤقت بنجاح'**
  String get cacheCleared;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @light.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In ar, this message translates to:
  /// **'تلقائي'**
  String get system;

  /// No description provided for @small.
  ///
  /// In ar, this message translates to:
  /// **'صغير'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In ar, this message translates to:
  /// **'متوسط'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In ar, this message translates to:
  /// **'كبير'**
  String get large;

  /// No description provided for @veryLarge.
  ///
  /// In ar, this message translates to:
  /// **'كبير جداً'**
  String get veryLarge;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;
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
