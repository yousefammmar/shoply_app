// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get gotIt => 'حسنًا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get done => 'تم';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get pleaseWait => 'يرجى الانتظار...';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get unavailable => 'غير متاح';

  @override
  String get notProvided => 'غير متوفر';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String errorWithDetails(String details) {
    return 'حدث خطأ ما:\n$details';
  }

  @override
  String get shoplyUser => 'مستخدم Shoply';

  @override
  String get pleaseLogIn => 'يرجى تسجيل الدخول أولًا';

  @override
  String get addToFavorites => 'أضف إلى المفضلة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String favoriteUpdateFailed(Object error) {
    return 'تعذّر تحديث المفضلة: $error';
  }

  @override
  String get total => 'الإجمالي';

  @override
  String get product => 'منتج';

  @override
  String get quantity => 'الكمية';

  @override
  String get onboardingTitle1 => 'اكتشف منتجات مذهلة';

  @override
  String get onboardingDescription1 => 'اعثر على كل ما تحتاجه في مكان واحد.';

  @override
  String get onboardingTitle2 => 'تسوّق بأسلوبك';

  @override
  String get onboardingDescription2 =>
      'أفضل العلامات التجارية، وأسعار رائعة، وأحدث الصيحات.';

  @override
  String get onboardingTitle3 => 'توصيل سريع وآمن';

  @override
  String get onboardingDescription3 => 'استلم طلباتك حتى باب منزلك.';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get skip => 'تخطٍّ';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get signInToContinue => 'سجّل الدخول لمتابعة التسوق';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'البريد الإلكتروني غير صالح';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get loginError => 'خطأ في تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinUs => 'انضم إلينا وابدأ التسوق';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get address => 'العنوان';

  @override
  String get addressRequired => 'العنوان مطلوب';

  @override
  String get passwordTooShort => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get passwordPattern =>
      'يجب أن تحتوي كلمة المرور على حرف كبير واحد ورمز خاص واحد على الأقل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signUpError => 'خطأ في إنشاء الحساب';

  @override
  String get signUpSuccessTitle => 'تم إنشاء الحساب';

  @override
  String get signUpSuccessMessage => 'تم إنشاء حسابك بنجاح.';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل\nلك رابط إعادة التعيين.';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get backToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get forgotPasswordError => 'خطأ في استعادة كلمة المرور';

  @override
  String get resetLinkSentTitle => 'تم إرسال الرابط';

  @override
  String get resetLinkSentMessage => 'تم إرسال بريد إعادة التعيين بنجاح.';

  @override
  String get authErrorInvalidCredential =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة. حاول مرة أخرى.';

  @override
  String get authErrorEmailInUse => 'هذا البريد الإلكتروني مسجّل بالفعل.';

  @override
  String get authErrorWeakPassword =>
      'كلمة المرور ضعيفة جدًا. جرّب مجموعة أطول.';

  @override
  String get authErrorInvalidEmail => 'يرجى إدخال بريد إلكتروني صالح.';

  @override
  String get authErrorUserDisabled => 'تم تعطيل هذا الحساب. تواصل مع الدعم.';

  @override
  String get authErrorUserNotFound =>
      'لا يوجد حساب مرتبط بهذا البريد الإلكتروني.';

  @override
  String get authErrorTooManyRequests =>
      'محاولات كثيرة جدًا. حاول مرة أخرى لاحقًا.';

  @override
  String get authErrorNetwork => 'يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get authErrorImageUpload =>
      'فشل رفع صورة الملف الشخصي. حاول مرة أخرى.';

  @override
  String get authErrorUnexpected => 'حدث خطأ غير متوقع. حاول مرة أخرى.';

  @override
  String get home => 'الرئيسية';

  @override
  String get categories => 'الفئات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get cart => 'السلة';

  @override
  String get myProfile => 'ملفي الشخصي';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get aboutShoply => 'حول Shoply';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutTitle => 'تسجيل الخروج؟';

  @override
  String get logoutMessage =>
      'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك في Shoply؟';

  @override
  String get stay => 'البقاء';

  @override
  String logoutFailed(Object error) {
    return 'فشل تسجيل الخروج: $error';
  }

  @override
  String get trendingProducts => 'المنتجات الرائجة';

  @override
  String get popular => 'الأكثر طلبًا';

  @override
  String get noTrendingProducts => 'لا توجد منتجات رائجة حاليًا';

  @override
  String categoryName(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'clothes': 'ملابس',
      'bags': 'حقائب',
      'shoes': 'أحذية',
      'glasses': 'نظارات شمسية',
      'perfumes': 'عطور',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String get noCategories => 'لا توجد فئات متاحة';

  @override
  String get noProductsInCategory => 'لا توجد منتجات في هذه الفئة';

  @override
  String get noProducts => 'لا توجد منتجات متاحة';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get addedToCart => 'تمت الإضافة إلى السلة!';

  @override
  String addedToCartMessage(String productName, int quantity) {
    return '$productName\nالكمية: $quantity\n\nتمت إضافة المنتج إلى سلة التسوق.';
  }

  @override
  String get continueShopping => 'متابعة التسوق';

  @override
  String addToCartFailed(Object error) {
    return 'تعذّرت الإضافة إلى السلة: $error';
  }

  @override
  String favoritesLoadFailed(Object error) {
    return 'تعذّر تحميل المفضلة:\n$error';
  }

  @override
  String get noFavorites => 'لا توجد عناصر مفضلة بعد';

  @override
  String get noFavoritesHint => 'اضغط على رمز القلب في أي منتج لحفظه هنا.';

  @override
  String get noMatchingFavorites => 'لم يتم العثور على منتجات مفضلة مطابقة.';

  @override
  String removedFromCart(String productName, int quantity) {
    return '$productName\nالكمية: $quantity\nتمت الإزالة من السلة بنجاح!';
  }

  @override
  String removeItemFailed(Object error) {
    return 'تعذّرت إزالة المنتج: $error';
  }

  @override
  String get removeItemTitle => 'إزالة المنتج؟';

  @override
  String removeItemMessage(String productName, int quantity) {
    return 'هل أنت متأكد أنك تريد إزالة هذا المنتج؟\n\n$productName\nالكمية: $quantity';
  }

  @override
  String get remove => 'إزالة';

  @override
  String get keepItem => 'الإبقاء عليه';

  @override
  String updateFailed(Object error) {
    return 'فشل التحديث: $error';
  }

  @override
  String checkoutFailed(Object error) {
    return 'فشل إتمام الطلب: $error';
  }

  @override
  String get cartProductsLoadFailed => 'تعذّر تحميل بعض منتجات السلة.';

  @override
  String get processingOrder => 'جارٍ معالجة الطلب...';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get emptyCart => 'سلتك فارغة';

  @override
  String get emptyCartHint => 'أضف بعض المنتجات للبدء';

  @override
  String get orderPlacedTitle => 'تم تقديم الطلب بنجاح!';

  @override
  String get orderPlacedMessage =>
      'شكرًا لتسوقك مع Shoply!\nتم حفظ طلبك في سجل الطلبات.';

  @override
  String get orderHistory => 'سجل الطلبات';

  @override
  String ordersLoadFailed(Object error) {
    return 'تعذّر تحميل الطلبات:\n$error';
  }

  @override
  String get noOrders => 'لا توجد طلبات بعد';

  @override
  String get noOrdersHint => 'ستظهر طلباتك السابقة هنا.';

  @override
  String get processingDate => 'التاريخ قيد المعالجة';

  @override
  String orderNumber(String id) {
    return 'طلب رقم #$id';
  }

  @override
  String orderStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'placed': 'تم الطلب',
      'pending': 'قيد الانتظار',
      'processing': 'قيد المعالجة',
      'shipped': 'تم الشحن',
      'delivered': 'تم التوصيل',
      'cancelled': 'ملغي',
      'other': '$status',
    });
    return '$_temp0';
  }

  @override
  String couldNotLoadAccount(Object error) {
    return 'تعذّر تحميل الحساب: $error';
  }

  @override
  String get numberOfOrders => 'عدد الطلبات';

  @override
  String get editAccountInformation => 'تعديل معلومات الحساب';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get accountSecurity => 'أمان الحساب';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get passwordUpdatedTitle => 'تم تحديث كلمة المرور!';

  @override
  String get passwordUpdatedMessage =>
      'تم تغيير كلمة المرور بنجاح.\n\nحسابك الآن محمي بكلمة المرور الجديدة.';

  @override
  String couldNotLoadProfile(Object error) {
    return 'تعذّر تحميل الملف الشخصي: $error';
  }

  @override
  String imageSelectionFailed(Object error) {
    return 'فشل اختيار الصورة: $error';
  }

  @override
  String get accountUpdated => 'تم تحديث الحساب بنجاح!';

  @override
  String saveFailed(Object error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get currentEmailAlready => 'هذا هو بريدك الإلكتروني الحالي';

  @override
  String get verificationEmailSent =>
      'تم إرسال رسالة التحقق. تفقّد بريدك الجديد ثم سجّل الدخول مجددًا.';

  @override
  String emailChangeFailed(Object error) {
    return 'فشل تغيير البريد الإلكتروني: $error';
  }

  @override
  String resetEmailSentTo(String email) {
    return 'تم إرسال بريد إعادة تعيين كلمة المرور إلى $email';
  }

  @override
  String couldNotSendResetLink(Object error) {
    return 'تعذّر إرسال رابط إعادة التعيين: $error';
  }

  @override
  String get language => 'اللغة';

  @override
  String get appearance => 'المظهر';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get systemDefault => 'إعداد النظام';

  @override
  String get systemDefaultHint => 'يتبع إعدادات جهازك';

  @override
  String get updatePasswordSubtitle => 'حدّث كلمة المرور الخاصة بك بأمان.';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get enterCurrentPassword => 'أدخل كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get useAtLeast8Characters => 'استخدم 8 أحرف على الأقل';

  @override
  String get chooseDifferentPassword => 'اختر كلمة مرور مختلفة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get update => 'تحديث';

  @override
  String get currentPasswordIncorrect => 'كلمة المرور الحالية غير صحيحة.';

  @override
  String get chooseStrongerPassword => 'يرجى اختيار كلمة مرور أقوى.';

  @override
  String get signInAgainAndRetry => 'يرجى تسجيل الدخول مجددًا ثم المحاولة.';

  @override
  String get unableToUpdatePassword => 'تعذّر تحديث كلمة المرور.';

  @override
  String get noEmailOnAccount => 'لا يحتوي هذا الحساب على بريد إلكتروني.';

  @override
  String get aboutTagline => 'رفيقك اليومي في التسوق';

  @override
  String get aboutTheApplication => 'عن التطبيق';

  @override
  String get aboutParagraph1 =>
      'Shoply تطبيق تسوق إلكتروني حديث صُمّم ليجعل التسوق عبر الإنترنت بسيطًا ومريحًا وممتعًا. يوفر تجربة تسوق منظمة تتيح للمستخدمين استكشاف المنتجات عبر فئات مختلفة، واكتشاف المنتجات الرائجة، والاطلاع على تفاصيل كل منتج.';

  @override
  String get aboutParagraph2 =>
      'مع Shoply يمكن للعملاء حفظ منتجاتهم المفضلة، وإدارة سلة التسوق، وتعديل كميات المنتجات، ومراجعة سجل طلباتهم، وتخصيص معلومات حساباتهم.';

  @override
  String get featureExploreCategories => 'استكشف فئات المنتجات';

  @override
  String get featureSaveFavorites => 'احفظ منتجاتك المفضلة';

  @override
  String get featureManageCart => 'أدِر سلة التسوق';

  @override
  String get featureReviewOrders => 'راجع سجل الطلبات';

  @override
  String get featurePersonalizeAccount => 'خصّص حسابك';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }
}
