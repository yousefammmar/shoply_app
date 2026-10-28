// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get gotIt => 'Got it';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get done => 'Done';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get loading => 'Loading...';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get notProvided => 'Not provided';

  @override
  String get requiredField => 'Required';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String errorWithDetails(String details) {
    return 'Something went wrong:\n$details';
  }

  @override
  String get shoplyUser => 'Shoply User';

  @override
  String get pleaseLogIn => 'Please log in first';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String favoriteUpdateFailed(Object error) {
    return 'Could not update favorites: $error';
  }

  @override
  String get total => 'Total';

  @override
  String get product => 'Product';

  @override
  String get quantity => 'Quantity';

  @override
  String get onboardingTitle1 => 'Discover Amazing Products';

  @override
  String get onboardingDescription1 => 'Find everything you need in one place.';

  @override
  String get onboardingTitle2 => 'Shop Your Style';

  @override
  String get onboardingDescription2 =>
      'Top brands, great prices and the latest trends.';

  @override
  String get onboardingTitle3 => 'Fast & Safe Delivery';

  @override
  String get onboardingDescription3 =>
      'Get your orders delivered right to your doorstep.';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue shopping';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Email is not valid';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get loginError => 'Login Error';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinUs => 'Join us and start shopping';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameRequired => 'Full Name is required';

  @override
  String get username => 'Username';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get address => 'Address';

  @override
  String get addressRequired => 'Address is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordPattern =>
      'Password must contain at least one uppercase letter and one special character';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordRequired => 'Confirm Password is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signUpError => 'Sign Up Error';

  @override
  String get signUpSuccessTitle => 'Sign Up Success';

  @override
  String get signUpSuccessMessage => 'Your account was created successfully.';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send\nyou a reset link.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get forgotPasswordError => 'Forgot Password Error';

  @override
  String get resetLinkSentTitle => 'Reset Link Sent';

  @override
  String get resetLinkSentMessage => 'Reset email sent successfully.';

  @override
  String get authErrorInvalidCredential =>
      'Incorrect email or password. Please try again.';

  @override
  String get authErrorEmailInUse => 'This email address is already registered.';

  @override
  String get authErrorWeakPassword =>
      'The password entered is too weak. Try a longer combination.';

  @override
  String get authErrorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get authErrorUserDisabled =>
      'This user account has been disabled. Contact support.';

  @override
  String get authErrorUserNotFound => 'No account was found for this email.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get authErrorNetwork => 'Please check your internet connection.';

  @override
  String get authErrorImageUpload =>
      'Profile image upload failed. Please try again.';

  @override
  String get authErrorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get home => 'Home';

  @override
  String get categories => 'Categories';

  @override
  String get favorites => 'Favorites';

  @override
  String get cart => 'Cart';

  @override
  String get myProfile => 'My Profile';

  @override
  String get myOrders => 'My Orders';

  @override
  String get settings => 'Settings';

  @override
  String get aboutShoply => 'About Shoply';

  @override
  String get logout => 'Logout';

  @override
  String get logoutTitle => 'Logout?';

  @override
  String get logoutMessage =>
      'Are you sure you want to logout of your Shoply account?';

  @override
  String get stay => 'Stay';

  @override
  String logoutFailed(Object error) {
    return 'Logout failed: $error';
  }

  @override
  String get trendingProducts => 'Trending Products';

  @override
  String get popular => 'Popular';

  @override
  String get noTrendingProducts => 'No trending products available';

  @override
  String categoryName(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'clothes': 'Tops',
      'bags': 'Bags',
      'shoes': 'Shoes',
      'glasses': 'Sunglasses',
      'perfumes': 'Perfumes',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String get noCategories => 'No categories available';

  @override
  String get noProductsInCategory => 'No products found in this category';

  @override
  String get noProducts => 'No products available';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get addedToCart => 'Added to Cart!';

  @override
  String addedToCartMessage(String productName, int quantity) {
    return '$productName\nQuantity: $quantity\n\nYour product has been added to your shopping cart.';
  }

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String addToCartFailed(Object error) {
    return 'Unable to add to cart: $error';
  }

  @override
  String favoritesLoadFailed(Object error) {
    return 'Failed to load favorites:\n$error';
  }

  @override
  String get noFavorites => 'No favorites yet';

  @override
  String get noFavoritesHint => 'Tap the heart on a product to save it here.';

  @override
  String get noMatchingFavorites => 'No matching favorite products found.';

  @override
  String removedFromCart(String productName, int quantity) {
    return '$productName\nQuantity: $quantity\nRemoved from cart successfully!';
  }

  @override
  String removeItemFailed(Object error) {
    return 'Failed to remove item: $error';
  }

  @override
  String get removeItemTitle => 'Remove Item?';

  @override
  String removeItemMessage(String productName, int quantity) {
    return 'Are you sure you want to remove this product?\n\n$productName\nQuantity: $quantity';
  }

  @override
  String get remove => 'Remove';

  @override
  String get keepItem => 'Keep Item';

  @override
  String updateFailed(Object error) {
    return 'Update failed: $error';
  }

  @override
  String checkoutFailed(Object error) {
    return 'Checkout failed: $error';
  }

  @override
  String get cartProductsLoadFailed =>
      'Some cart products could not be loaded.';

  @override
  String get processingOrder => 'Processing Order...';

  @override
  String get checkout => 'Checkout';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get emptyCartHint => 'Add some products to get started';

  @override
  String get orderPlacedTitle => 'Order Placed Successfully!';

  @override
  String get orderPlacedMessage =>
      'Thank you for shopping with Shoply!\nYour order is saved in Order History.';

  @override
  String get orderHistory => 'Order History';

  @override
  String ordersLoadFailed(Object error) {
    return 'Failed to load orders:\n$error';
  }

  @override
  String get noOrders => 'No orders yet';

  @override
  String get noOrdersHint => 'Your previous orders will appear here.';

  @override
  String get processingDate => 'Processing date';

  @override
  String orderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String orderStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'placed': 'Placed',
      'pending': 'Pending',
      'processing': 'Processing',
      'shipped': 'Shipped',
      'delivered': 'Delivered',
      'cancelled': 'Cancelled',
      'other': '$status',
    });
    return '$_temp0';
  }

  @override
  String couldNotLoadAccount(Object error) {
    return 'Could not load account: $error';
  }

  @override
  String get numberOfOrders => 'Number of Orders';

  @override
  String get editAccountInformation => 'Edit Account Information';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get preferences => 'Preferences';

  @override
  String get accountSecurity => 'Account Security';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get changePassword => 'Change Password';

  @override
  String get passwordUpdatedTitle => 'Password Updated!';

  @override
  String get passwordUpdatedMessage =>
      'Your password has been changed successfully.\n\nYour account is now secured with your new password.';

  @override
  String couldNotLoadProfile(Object error) {
    return 'Could not load profile: $error';
  }

  @override
  String imageSelectionFailed(Object error) {
    return 'Image selection failed: $error';
  }

  @override
  String get accountUpdated => 'Account updated successfully!';

  @override
  String saveFailed(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get currentEmailAlready => 'This is your current email';

  @override
  String get verificationEmailSent =>
      'Verification sent. Check the new email, then sign in again.';

  @override
  String emailChangeFailed(Object error) {
    return 'Email change failed: $error';
  }

  @override
  String resetEmailSentTo(String email) {
    return 'Password reset email sent to $email';
  }

  @override
  String couldNotSendResetLink(Object error) {
    return 'Could not send reset link: $error';
  }

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get systemDefaultHint => 'Follows your device settings';

  @override
  String get updatePasswordSubtitle => 'Update your password securely.';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get enterCurrentPassword => 'Enter your current password';

  @override
  String get newPassword => 'New Password';

  @override
  String get useAtLeast8Characters => 'Use at least 8 characters';

  @override
  String get chooseDifferentPassword => 'Choose a different password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get update => 'Update';

  @override
  String get currentPasswordIncorrect => 'Your current password is incorrect.';

  @override
  String get chooseStrongerPassword => 'Please choose a stronger password.';

  @override
  String get signInAgainAndRetry => 'Please sign in again and retry.';

  @override
  String get unableToUpdatePassword => 'Unable to update password.';

  @override
  String get noEmailOnAccount => 'This account does not have an email address.';

  @override
  String get aboutTagline => 'Your Everyday Shopping Companion';

  @override
  String get aboutTheApplication => 'About the Application';

  @override
  String get aboutParagraph1 =>
      'Shoply is a modern e-commerce mobile application designed to make online shopping simple, convenient, and enjoyable. It provides an organized shopping experience where users can explore products across different categories, discover trending items, and view detailed product information.';

  @override
  String get aboutParagraph2 =>
      'With Shoply, customers can save their favorite products, manage their shopping cart, adjust product quantities, review their order history, and personalize their account information.';

  @override
  String get featureExploreCategories => 'Explore Product Categories';

  @override
  String get featureSaveFavorites => 'Save Favorite Products';

  @override
  String get featureManageCart => 'Manage Shopping Cart';

  @override
  String get featureReviewOrders => 'Review Order History';

  @override
  String get featurePersonalizeAccount => 'Personalize Your Account';

  @override
  String version(String version) {
    return 'Version $version';
  }
}
