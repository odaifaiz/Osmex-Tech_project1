// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CityFix';

  @override
  String get home => 'Home';

  @override
  String get myReports => 'My Reports';

  @override
  String get map => 'Map';

  @override
  String get settings => 'Settings';

  @override
  String welcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String get communityBetter => 'For a better community';

  @override
  String get totalReports => 'Total Reports';

  @override
  String get resolved => 'Resolved';

  @override
  String get inProgress => 'In Progress';

  @override
  String get recentReports => 'Recent Reports';

  @override
  String get viewAll => 'View All';

  @override
  String get createReport => 'Create Report';

  @override
  String get noReports => 'No Reports';

  @override
  String get createFirstReport => 'Create your first report now';

  @override
  String get retry => 'Retry';

  @override
  String get errorLoadingReports => 'Error loading reports';

  @override
  String get statusPending => 'New';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusResolved => 'Resolved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusClosed => 'Closed';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get reportDetails => 'Report Details';

  @override
  String get reportNumber => 'Report ID';

  @override
  String get onMap => 'On Map';

  @override
  String get reportDescription => 'Report Description';

  @override
  String get ratingText => 'Share your feedback to improve services';

  @override
  String get rateNow => 'Rate Now';

  @override
  String get timeline => 'Timeline';

  @override
  String get timelineCreated => 'Report Created';

  @override
  String get timelineReceived => 'Report Received';

  @override
  String get timelineInProgress => 'In Progress';

  @override
  String get timelineResolved => 'Problem Resolved';

  @override
  String get timelineClosed => 'Report Closed';

  @override
  String get pendingWait => 'Pending';

  @override
  String get reviewWait => 'Waiting for review';

  @override
  String get share => 'Share';

  @override
  String get copyNumber => 'Copy ID';

  @override
  String get numberCopied => 'Report ID copied';

  @override
  String get reportNotFound => 'Report not found';

  @override
  String get reportSent => 'Report Sent';

  @override
  String get successTitle => 'Sent Successfully!';

  @override
  String get successMessage => 'Thank you for contributing to your city!';

  @override
  String get reportIdLabel => 'Report ID';

  @override
  String get reviewPeriod => 'Will be reviewed within 24 hours';

  @override
  String get viewMyReports => 'View My Reports';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get failureTitle => 'Failed to Send Report';

  @override
  String get reportFailure =>
      'Report submission failed. Please check your internet connection and try again.';

  @override
  String get saveDraft => 'Save as Draft';

  @override
  String get mapTitle => 'Reports Map';

  @override
  String get searchMapHint => 'Search by ID, address, or location...';

  @override
  String get loadingMap => 'Loading map...';

  @override
  String get all => 'All';

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
  String get showAnalytics => 'Show Smart Analytics';

  @override
  String get pendingNearby => 'Pending Reports';

  @override
  String get nearbyFound => 'Nearby Reports';

  @override
  String get avgResponse => 'Avg Response Time';

  @override
  String get lastReported => 'Last Reported';

  @override
  String get similarReportFound => 'Similar report found in this area';

  @override
  String get viewExisting => 'View Existing Report';

  @override
  String get createNewAnyway => 'Create New Anyway';

  @override
  String get reviewReport => 'Review Report';

  @override
  String get attachedImages => 'Attached Images';

  @override
  String imagesCount(int count) {
    return '$count images';
  }

  @override
  String get noImages => 'No attached images';

  @override
  String get declarationText =>
      'I declare that all information provided is accurate';

  @override
  String get confirmAndSend => 'Confirm and Send ➤';

  @override
  String get saving => 'Saving...';

  @override
  String get loginFirst => 'You must login first to send a report';

  @override
  String get categoryError => 'Error determining category';

  @override
  String get confirmationTitle => 'Confirm Submission';

  @override
  String get confirmationMessage =>
      'The report will be saved locally and synced once internet is available.';

  @override
  String get warning => 'Warning';

  @override
  String get activateDeclaration =>
      'Please activate the declaration before sending.';

  @override
  String get ok => 'OK';

  @override
  String get categoryLabel => 'Category';

  @override
  String get reportTitleLabel => 'Report Title';

  @override
  String get urgentReport => 'Urgent Report';

  @override
  String get profile => 'My Profile';

  @override
  String get edit => 'Edit';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get email => 'Email Address';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Confirm Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get createReportTitle => 'Create New Report';

  @override
  String get captureImage => 'Take photo of the problem (1-4 images)';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get reportTitleHint => 'e.g., Pothole in middle of road';

  @override
  String get location => 'Location';

  @override
  String get descriptionHint => 'Please write problem details here...';

  @override
  String get urgentText => 'Urgent problem?';

  @override
  String get continueText => 'Continue →';

  @override
  String get selectLocationError => 'Please select problem location';

  @override
  String get selectCategoryError => 'Please select problem category';

  @override
  String get selectTitleError => 'Please enter report title';

  @override
  String get selectDescriptionError => 'Please enter report description';

  @override
  String get search => 'Search';

  @override
  String get drafts => 'Drafts';

  @override
  String get latestReports => 'Latest Reports';

  @override
  String get total => 'Total';

  @override
  String get accountSecurity => 'Account & Security';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Privacy';

  @override
  String get supportHelp => 'Support & Help';

  @override
  String get aboutApp => 'About App';

  @override
  String get appSettings => 'App Settings';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get chooseTheme => 'Choose Appearance';

  @override
  String get autoSystem => 'System (Auto)';

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get fontSize => 'Font Size';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get cacheCleared => 'Cache cleared successfully';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get veryLarge => 'Very Large';

  @override
  String get back => 'Back';
}
