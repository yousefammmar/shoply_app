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
    Locale('en'),
  ];

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

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

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong:\n{details}'**
  String errorWithDetails(String details);

  /// No description provided for @shoplyUser.
  ///
  /// In en, this message translates to:
  /// **'Shoply User'**
  String get shoplyUser;

  /// No description provided for @pleaseLogIn.
  ///
  /// In en, this message translates to:
  /// **'Please log in first'**
  String get pleaseLogIn;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @favoriteUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update favorites: {error}'**
  String favoriteUpdateFailed(Object error);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Discover Amazing Products'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Find everything you need in one place.'**
  String get onboardingDescription1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Shop Your Style'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Top brands, great prices and the latest trends.'**
  String get onboardingDescription2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Fast & Safe Delivery'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Get your orders delivered right to your doorstep.'**
  String get onboardingDescription3;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue shopping'**
  String get signInToContinue;

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

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Email is not valid'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login Error'**
  String get loginError;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinUs.
  ///
  /// In en, this message translates to:
  /// **'Join us and start shopping'**
  String get joinUs;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full Name is required'**
  String get fullNameRequired;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordPattern.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter and one special character'**
  String get passwordPattern;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signUpError.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Error'**
  String get signUpError;

  /// No description provided for @signUpSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Success'**
  String get signUpSuccessTitle;

  /// No description provided for @signUpSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account was created successfully.'**
  String get signUpSuccessMessage;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send\nyou a reset link.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @forgotPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password Error'**
  String get forgotPasswordError;

  /// No description provided for @resetLinkSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Link Sent'**
  String get resetLinkSentTitle;

  /// No description provided for @resetLinkSentMessage.
  ///
  /// In en, this message translates to:
  /// **'Reset email sent successfully.'**
  String get resetLinkSentMessage;

  /// No description provided for @authErrorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password. Please try again.'**
  String get authErrorInvalidCredential;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email address is already registered.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password entered is too weak. Try a longer combination.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This user account has been disabled. Contact support.'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account was found for this email.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorImageUpload.
  ///
  /// In en, this message translates to:
  /// **'Profile image upload failed. Please try again.'**
  String get authErrorImageUpload;

  /// No description provided for @authErrorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get authErrorUnexpected;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @aboutShoply.
  ///
  /// In en, this message translates to:
  /// **'About Shoply'**
  String get aboutShoply;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout of your Shoply account?'**
  String get logoutMessage;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed: {error}'**
  String logoutFailed(Object error);

  /// No description provided for @trendingProducts.
  ///
  /// In en, this message translates to:
  /// **'Trending Products'**
  String get trendingProducts;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @noTrendingProducts.
  ///
  /// In en, this message translates to:
  /// **'No trending products available'**
  String get noTrendingProducts;

  /// Display name for a Firestore category id; unknown ids show the stored name.
  ///
  /// In en, this message translates to:
  /// **'{id, select, clothes{Tops} bags{Bags} shoes{Shoes} glasses{Sunglasses} perfumes{Perfumes} other{{fallback}}}'**
  String categoryName(String id, String fallback);

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategories;

  /// No description provided for @noProductsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No products found in this category'**
  String get noProductsInCategory;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProducts;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to Cart!'**
  String get addedToCart;

  /// No description provided for @addedToCartMessage.
  ///
  /// In en, this message translates to:
  /// **'{productName}\nQuantity: {quantity}\n\nYour product has been added to your shopping cart.'**
  String addedToCartMessage(String productName, int quantity);

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @addToCartFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to add to cart: {error}'**
  String addToCartFailed(Object error);

  /// No description provided for @favoritesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load favorites:\n{error}'**
  String favoritesLoadFailed(Object error);

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavorites;

  /// No description provided for @noFavoritesHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on a product to save it here.'**
  String get noFavoritesHint;

  /// No description provided for @noMatchingFavorites.
  ///
  /// In en, this message translates to:
  /// **'No matching favorite products found.'**
  String get noMatchingFavorites;

  /// No description provided for @removedFromCart.
  ///
  /// In en, this message translates to:
  /// **'{productName}\nQuantity: {quantity}\nRemoved from cart successfully!'**
  String removedFromCart(String productName, int quantity);

  /// No description provided for @removeItemFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove item: {error}'**
  String removeItemFailed(Object error);

  /// No description provided for @removeItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Item?'**
  String get removeItemTitle;

  /// No description provided for @removeItemMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this product?\n\n{productName}\nQuantity: {quantity}'**
  String removeItemMessage(String productName, int quantity);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @keepItem.
  ///
  /// In en, this message translates to:
  /// **'Keep Item'**
  String get keepItem;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String updateFailed(Object error);

  /// No description provided for @checkoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Checkout failed: {error}'**
  String checkoutFailed(Object error);

  /// No description provided for @cartProductsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Some cart products could not be loaded.'**
  String get cartProductsLoadFailed;

  /// No description provided for @processingOrder.
  ///
  /// In en, this message translates to:
  /// **'Processing Order...'**
  String get processingOrder;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// No description provided for @emptyCartHint.
  ///
  /// In en, this message translates to:
  /// **'Add some products to get started'**
  String get emptyCartHint;

  /// No description provided for @orderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully!'**
  String get orderPlacedTitle;

  /// No description provided for @orderPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for shopping with Shoply!\nYour order is saved in Order History.'**
  String get orderPlacedMessage;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @ordersLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders:\n{error}'**
  String ordersLoadFailed(Object error);

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrders;

  /// No description provided for @noOrdersHint.
  ///
  /// In en, this message translates to:
  /// **'Your previous orders will appear here.'**
  String get noOrdersHint;

  /// No description provided for @processingDate.
  ///
  /// In en, this message translates to:
  /// **'Processing date'**
  String get processingDate;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderNumber(String id);

  /// Order status stored in Firestore; unknown values are shown as stored.
  ///
  /// In en, this message translates to:
  /// **'{status, select, placed{Placed} pending{Pending} processing{Processing} shipped{Shipped} delivered{Delivered} cancelled{Cancelled} other{{status}}}'**
  String orderStatus(String status);

  /// No description provided for @couldNotLoadAccount.
  ///
  /// In en, this message translates to:
  /// **'Could not load account: {error}'**
  String couldNotLoadAccount(Object error);

  /// No description provided for @numberOfOrders.
  ///
  /// In en, this message translates to:
  /// **'Number of Orders'**
  String get numberOfOrders;

  /// No description provided for @editAccountInformation.
  ///
  /// In en, this message translates to:
  /// **'Edit Account Information'**
  String get editAccountInformation;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get accountSecurity;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @passwordUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Updated!'**
  String get passwordUpdatedTitle;

  /// No description provided for @passwordUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully.\n\nYour account is now secured with your new password.'**
  String get passwordUpdatedMessage;

  /// No description provided for @couldNotLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile: {error}'**
  String couldNotLoadProfile(Object error);

  /// No description provided for @imageSelectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Image selection failed: {error}'**
  String imageSelectionFailed(Object error);

  /// No description provided for @accountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account updated successfully!'**
  String get accountUpdated;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(Object error);

  /// No description provided for @currentEmailAlready.
  ///
  /// In en, this message translates to:
  /// **'This is your current email'**
  String get currentEmailAlready;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification sent. Check the new email, then sign in again.'**
  String get verificationEmailSent;

  /// No description provided for @emailChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Email change failed: {error}'**
  String emailChangeFailed(Object error);

  /// No description provided for @resetEmailSentTo.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent to {email}'**
  String resetEmailSentTo(String email);

  /// No description provided for @couldNotSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Could not send reset link: {error}'**
  String couldNotSendResetLink(Object error);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @systemDefaultHint.
  ///
  /// In en, this message translates to:
  /// **'Follows your device settings'**
  String get systemDefaultHint;

  /// No description provided for @updatePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password securely.'**
  String get updatePasswordSubtitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterCurrentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @useAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get useAtLeast8Characters;

  /// No description provided for @chooseDifferentPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a different password'**
  String get chooseDifferentPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Your current password is incorrect.'**
  String get currentPasswordIncorrect;

  /// No description provided for @chooseStrongerPassword.
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password.'**
  String get chooseStrongerPassword;

  /// No description provided for @signInAgainAndRetry.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again and retry.'**
  String get signInAgainAndRetry;

  /// No description provided for @unableToUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Unable to update password.'**
  String get unableToUpdatePassword;

  /// No description provided for @noEmailOnAccount.
  ///
  /// In en, this message translates to:
  /// **'This account does not have an email address.'**
  String get noEmailOnAccount;

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Everyday Shopping Companion'**
  String get aboutTagline;

  /// No description provided for @aboutTheApplication.
  ///
  /// In en, this message translates to:
  /// **'About the Application'**
  String get aboutTheApplication;

  /// No description provided for @aboutParagraph1.
  ///
  /// In en, this message translates to:
  /// **'Shoply is a modern e-commerce mobile application designed to make online shopping simple, convenient, and enjoyable. It provides an organized shopping experience where users can explore products across different categories, discover trending items, and view detailed product information.'**
  String get aboutParagraph1;

  /// No description provided for @aboutParagraph2.
  ///
  /// In en, this message translates to:
  /// **'With Shoply, customers can save their favorite products, manage their shopping cart, adjust product quantities, review their order history, and personalize their account information.'**
  String get aboutParagraph2;

  /// No description provided for @featureExploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Explore Product Categories'**
  String get featureExploreCategories;

  /// No description provided for @featureSaveFavorites.
  ///
  /// In en, this message translates to:
  /// **'Save Favorite Products'**
  String get featureSaveFavorites;

  /// No description provided for @featureManageCart.
  ///
  /// In en, this message translates to:
  /// **'Manage Shopping Cart'**
  String get featureManageCart;

  /// No description provided for @featureReviewOrders.
  ///
  /// In en, this message translates to:
  /// **'Review Order History'**
  String get featureReviewOrders;

  /// No description provided for @featurePersonalizeAccount.
  ///
  /// In en, this message translates to:
  /// **'Personalize Your Account'**
  String get featurePersonalizeAccount;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);
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
    'that was used.',
  );
}
