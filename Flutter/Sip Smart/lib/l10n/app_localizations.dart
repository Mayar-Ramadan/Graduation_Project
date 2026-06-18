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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SipSmart'**
  String get appName;

  /// Subtitle of the application
  ///
  /// In en, this message translates to:
  /// **'Stay Hydrated, Stay Healthy'**
  String get appSubtitle;

  /// Title for error dialog
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// Message for initialization error
  ///
  /// In en, this message translates to:
  /// **'Unable to initialize the app. Please check your connection and try again.'**
  String get initializationFailed;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Track your daily\nwater intake'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Advanced precision tracking to monitor your hydration levels and health progress daily.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Smart Reminders\nTailored to You'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'AI-driven notifications that intelligently adapt to your lifestyle and body needs.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Easy to Use –\nDrink, Tap, Repeat'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Seamless user experience. One tap to log, and the system handles the rest.'**
  String get onboardingDesc3;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back,'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue'**
  String get signInSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get emailHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign in with'**
  String get orSignInWith;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @googleSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in cancelled'**
  String get googleSignInCancelled;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @googleSignInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in successful'**
  String get googleSignInSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again'**
  String get loginFailed;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email'**
  String get userNotFound;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try later'**
  String get tooManyRequests;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us to track your hydration'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get nameHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 25'**
  String get ageHint;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightLabel;

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 70'**
  String get weightHint;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightLabel;

  /// No description provided for @heightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 175'**
  String get heightHint;

  /// No description provided for @activityLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activityLevelLabel;

  /// No description provided for @activitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get activitySedentary;

  /// No description provided for @activityLightly.
  ///
  /// In en, this message translates to:
  /// **'Lightly Active'**
  String get activityLightly;

  /// No description provided for @activityModerately.
  ///
  /// In en, this message translates to:
  /// **'Moderately Active'**
  String get activityModerately;

  /// No description provided for @activityVery.
  ///
  /// In en, this message translates to:
  /// **'Very Active'**
  String get activityVery;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @countryHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your country'**
  String get countryHint;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @resetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a secure link to reset your password'**
  String get resetSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @resetInfoNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you an email with instructions to reset your password securely.'**
  String get resetInfoNote;

  /// No description provided for @sendResetLinkBtn.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLinkBtn;

  /// No description provided for @rememberPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberPasswordText;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLink;

  /// No description provided for @resetEmailSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent! Please check your email.'**
  String get resetEmailSentSuccess;

  /// No description provided for @resetNoUserFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email.'**
  String get resetNoUserFound;

  /// No description provided for @resetInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is not valid.'**
  String get resetInvalidEmail;

  /// No description provided for @resetGenericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get resetGenericError;

  /// No description provided for @resetSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get resetSomethingWentWrong;

  /// No description provided for @sipSmart.
  ///
  /// In en, this message translates to:
  /// **'SipSmart'**
  String get sipSmart;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle'**
  String get navBottle;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Title for recent activity section
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent records found'**
  String get noRecentActivity;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @todaysProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todaysProgress;

  /// No description provided for @smartBottle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Connection'**
  String get smartBottle;

  /// No description provided for @bottleConnected.
  ///
  /// In en, this message translates to:
  /// **'Bottle Connected'**
  String get bottleConnected;

  /// No description provided for @searchingDevices.
  ///
  /// In en, this message translates to:
  /// **'Searching for devices...'**
  String get searchingDevices;

  /// No description provided for @noDeviceConnected.
  ///
  /// In en, this message translates to:
  /// **'No Device Connected'**
  String get noDeviceConnected;

  /// No description provided for @ensureBottleOn.
  ///
  /// In en, this message translates to:
  /// **'Ensure your smart bottle is powered on'**
  String get ensureBottleOn;

  /// No description provided for @connectBottleDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect your smart water bottle to track your hydration'**
  String get connectBottleDesc;

  /// No description provided for @pairBottle.
  ///
  /// In en, this message translates to:
  /// **'Pair Bottle'**
  String get pairBottle;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @pleaseMakeSure.
  ///
  /// In en, this message translates to:
  /// **'Please make sure:'**
  String get pleaseMakeSure;

  /// No description provided for @instructionBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is enabled on your phone'**
  String get instructionBluetooth;

  /// No description provided for @instructionPowerOn.
  ///
  /// In en, this message translates to:
  /// **'Your smart bottle is turned on'**
  String get instructionPowerOn;

  /// No description provided for @instructionProximity.
  ///
  /// In en, this message translates to:
  /// **'The bottle is close to your phone'**
  String get instructionProximity;

  /// No description provided for @enableBluetoothError.
  ///
  /// In en, this message translates to:
  /// **'Please enable Bluetooth first'**
  String get enableBluetoothError;

  /// No description provided for @connectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to'**
  String get connectedTo;

  /// No description provided for @successfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully'**
  String get successfully;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Check your device.'**
  String get connectionFailed;

  /// No description provided for @bestDay.
  ///
  /// In en, this message translates to:
  /// **'Best Day'**
  String get bestDay;

  /// No description provided for @lowestDay.
  ///
  /// In en, this message translates to:
  /// **'Lowest Day'**
  String get lowestDay;

  /// No description provided for @weeklyAvg.
  ///
  /// In en, this message translates to:
  /// **'Weekly Avg'**
  String get weeklyAvg;

  /// No description provided for @averagePerDay.
  ///
  /// In en, this message translates to:
  /// **'Average/Day'**
  String get averagePerDay;

  /// No description provided for @goalRate.
  ///
  /// In en, this message translates to:
  /// **'Goal Rate'**
  String get goalRate;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get successRate;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @monthlyTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly Trend'**
  String get monthlyTrend;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @avgConsumptionTrend.
  ///
  /// In en, this message translates to:
  /// **'Average Consumption Trend'**
  String get avgConsumptionTrend;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activity;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSure;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noUserData.
  ///
  /// In en, this message translates to:
  /// **'No user data found'**
  String get noUserData;

  /// Settings button label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceSub.
  ///
  /// In en, this message translates to:
  /// **'Light or dark mode'**
  String get appearanceSub;

  /// No description provided for @localization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localization;

  /// No description provided for @localizationSub.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get localizationSub;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacySub.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy terms'**
  String get privacySub;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @termsSub.
  ///
  /// In en, this message translates to:
  /// **'App usage terms'**
  String get termsSub;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutSub.
  ///
  /// In en, this message translates to:
  /// **'App version & info'**
  String get aboutSub;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme'**
  String get chooseTheme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @lightModeSub.
  ///
  /// In en, this message translates to:
  /// **'Easy on the eyes during the day'**
  String get lightModeSub;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeSub.
  ///
  /// In en, this message translates to:
  /// **'Perfect for low-light environments'**
  String get darkModeSub;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select App Language'**
  String get selectLanguage;

  /// No description provided for @validatorEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email address is required'**
  String get validatorEmailEmpty;

  /// No description provided for @validatorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validatorEmailInvalid;

  /// No description provided for @validatorPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validatorPasswordEmpty;

  /// No description provided for @validatorPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validatorPasswordShort;

  /// No description provided for @validatorConfirmPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get validatorConfirmPasswordEmpty;

  /// No description provided for @validatorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validatorPasswordMismatch;

  /// No description provided for @validatorFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String validatorFieldRequired(Object fieldName);

  /// No description provided for @howActiveAreYouToday.
  ///
  /// In en, this message translates to:
  /// **'How active are you today?'**
  String get howActiveAreYouToday;

  /// No description provided for @chooseActivityLevelMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose your activity level for a more accurate recommendation.'**
  String get chooseActivityLevelMessage;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @enableLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get enableLocationTitle;

  /// No description provided for @enableLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow location access to get more accurate weather-based hydration recommendations.'**
  String get enableLocationMessage;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @allowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get allowAccess;

  /// No description provided for @progressPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String progressPercent(Object percent);

  /// No description provided for @waterProgress.
  ///
  /// In en, this message translates to:
  /// **'{current}L / {goal}L'**
  String waterProgress(Object current, Object goal);

  /// No description provided for @recommendedToday.
  ///
  /// In en, this message translates to:
  /// **'Recommended today: {amount}L'**
  String recommendedToday(Object amount);

  /// No description provided for @usingSavedLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'Using your last saved location for weather updates. Enable location access for more accurate recommendations.'**
  String get usingSavedLocationMessage;

  /// No description provided for @usingSavedActivityMessage.
  ///
  /// In en, this message translates to:
  /// **'We’re using your last saved activity. Update it for better accuracy.'**
  String get usingSavedActivityMessage;

  /// No description provided for @hydrationPersonalized.
  ///
  /// In en, this message translates to:
  /// **'Your hydration recommendation is now more personalized.'**
  String get hydrationPersonalized;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @activityLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityLabel;

  /// No description provided for @activityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get activityLow;

  /// No description provided for @activityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get activityMedium;

  /// No description provided for @activityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get activityHigh;

  /// No description provided for @bluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get wifi;

  /// No description provided for @wifiTitle.
  ///
  /// In en, this message translates to:
  /// **'WiFi Connection'**
  String get wifiTitle;

  /// No description provided for @networkConnected.
  ///
  /// In en, this message translates to:
  /// **'Network Connected'**
  String get networkConnected;

  /// No description provided for @noNetworkConnected.
  ///
  /// In en, this message translates to:
  /// **'No Network Connected'**
  String get noNetworkConnected;

  /// No description provided for @searchingNetworks.
  ///
  /// In en, this message translates to:
  /// **'Searching for Networks...'**
  String get searchingNetworks;

  /// No description provided for @searchingDescription.
  ///
  /// In en, this message translates to:
  /// **'Searching for nearby high-speed networks...'**
  String get searchingDescription;

  /// No description provided for @wifiEnableCloud.
  ///
  /// In en, this message translates to:
  /// **'Connect your device to WiFi to enable cloud syncing.'**
  String get wifiEnableCloud;

  /// No description provided for @connectWifi.
  ///
  /// In en, this message translates to:
  /// **'Connect to WiFi'**
  String get connectWifi;

  /// No description provided for @makeSure.
  ///
  /// In en, this message translates to:
  /// **'Please make sure:'**
  String get makeSure;

  /// No description provided for @wifiEnabledPhone.
  ///
  /// In en, this message translates to:
  /// **'WiFi is enabled on your phone'**
  String get wifiEnabledPhone;

  /// No description provided for @wifiFrequency.
  ///
  /// In en, this message translates to:
  /// **'Using a 2.4GHz network frequency'**
  String get wifiFrequency;

  /// No description provided for @routerRange.
  ///
  /// In en, this message translates to:
  /// **'Device is within router range'**
  String get routerRange;

  /// No description provided for @chooseWifiNetwork.
  ///
  /// In en, this message translates to:
  /// **'Choose WiFi Network'**
  String get chooseWifiNetwork;

  /// No description provided for @selectWifiOrHidden.
  ///
  /// In en, this message translates to:
  /// **'Select your WiFi network or add hidden network'**
  String get selectWifiOrHidden;

  /// No description provided for @addHiddenNetwork.
  ///
  /// In en, this message translates to:
  /// **'Add Hidden Network'**
  String get addHiddenNetwork;

  /// No description provided for @hiddenNetwork.
  ///
  /// In en, this message translates to:
  /// **'Hidden Network'**
  String get hiddenNetwork;

  /// No description provided for @wifiPassword.
  ///
  /// In en, this message translates to:
  /// **'WiFi Password'**
  String get wifiPassword;

  /// No description provided for @wifiNameSsid.
  ///
  /// In en, this message translates to:
  /// **'WiFi Name (SSID)'**
  String get wifiNameSsid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @noNetworksFound.
  ///
  /// In en, this message translates to:
  /// **'No networks found. Tap refresh to scan again.'**
  String get noNetworksFound;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required'**
  String get locationPermissionRequired;

  /// No description provided for @cannotStartWifiScan.
  ///
  /// In en, this message translates to:
  /// **'Cannot start WiFi scan'**
  String get cannotStartWifiScan;

  /// No description provided for @cannotGetWifiResults.
  ///
  /// In en, this message translates to:
  /// **'Cannot get WiFi results'**
  String get cannotGetWifiResults;

  /// No description provided for @failedSendWifiCredentials.
  ///
  /// In en, this message translates to:
  /// **'Failed to send WiFi credentials to ESP'**
  String get failedSendWifiCredentials;

  /// No description provided for @cannotReachEsp.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach ESP. Connect phone to SmartBottle_Setup first'**
  String get cannotReachEsp;

  /// No description provided for @wrongWifiPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong WiFi password'**
  String get wrongWifiPassword;

  /// No description provided for @espConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to ESP device'**
  String get espConnectionFailed;

  /// No description provided for @wifiConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'WiFi connection timed out'**
  String get wifiConnectionTimeout;

  /// Empty state message for recent activity
  ///
  /// In en, this message translates to:
  /// **'Start Drinking Now!'**
  String get startDrinking;

  /// Live badge label
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// Default status when no status is provided
  ///
  /// In en, this message translates to:
  /// **'Drank water'**
  String get drankWater;

  /// No description provided for @refill.
  ///
  /// In en, this message translates to:
  /// **'Refill'**
  String get refill;

  /// No description provided for @spilling.
  ///
  /// In en, this message translates to:
  /// **'Spilling'**
  String get spilling;

  /// Fallback when time is not available
  ///
  /// In en, this message translates to:
  /// **'No time'**
  String get noTime;

  /// Time label for activities that just happened
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameHint;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile changes saved successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @profileImageUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile image updated successfully'**
  String get profileImageUpdatedSuccess;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields are required'**
  String get allFieldsRequired;

  /// No description provided for @invalidAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age'**
  String get invalidAge;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid weight'**
  String get invalidWeight;

  /// No description provided for @invalidHeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid height'**
  String get invalidHeight;

  /// Time label for activities that happened minutes ago
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String minutesAgo(int minutes);

  /// Title for history screen
  ///
  /// In en, this message translates to:
  /// **'Drinking History'**
  String get historyTitle;

  /// Empty state message for history screen
  ///
  /// In en, this message translates to:
  /// **'No readings yet'**
  String get noHistory;

  /// Milliliter unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get mlUnit;

  /// Title for daily progress section
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get dailyProgress;

  /// Message when location permission is permanently denied
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please enable it from settings.'**
  String get locationDenied;

  /// Status label for water spill
  ///
  /// In en, this message translates to:
  /// **'Spilling'**
  String get spillingStatus;

  /// Status label for remaining water
  ///
  /// In en, this message translates to:
  /// **'Remaining Water'**
  String get remainingWaterStatus;

  /// Status label for normal state
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalStatus;

  /// Word used to indicate remaining amount
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// Description for drank water status
  ///
  /// In en, this message translates to:
  /// **'Water consumed'**
  String get drankWaterDescription;

  /// Description for spilling status
  ///
  /// In en, this message translates to:
  /// **'Spill detected'**
  String get spillingDescription;

  /// Description for remaining water status
  ///
  /// In en, this message translates to:
  /// **'Water remaining in bottle'**
  String get remainingWaterDescription;

  /// Description for normal status
  ///
  /// In en, this message translates to:
  /// **'Normal state'**
  String get normalDescription;

  /// Fallback for unknown status
  ///
  /// In en, this message translates to:
  /// **'Unknown status'**
  String get unknownStatus;

  /// Notification title for water spill
  ///
  /// In en, this message translates to:
  /// **'⚠️ Warning'**
  String get spillWarningTitle;

  /// Notification body for water spill
  ///
  /// In en, this message translates to:
  /// **'Water spill detected!'**
  String get spillWarningBody;

  /// Notification title for drinking water
  ///
  /// In en, this message translates to:
  /// **'💙 Great Job!'**
  String get drinkGreatTitle;

  /// Notification body for drinking water
  ///
  /// In en, this message translates to:
  /// **'You drank {amount} ml water'**
  String drinkGreatBody(int amount);

  /// Notification title for low water
  ///
  /// In en, this message translates to:
  /// **'🚰 Low Water'**
  String get lowWaterTitle;

  /// Notification body for low water
  ///
  /// In en, this message translates to:
  /// **'Please refill your bottle'**
  String get lowWaterBody;

  /// Notification title for hydration reminder
  ///
  /// In en, this message translates to:
  /// **'💧 Stay Hydrated'**
  String get reminderTitle;

  /// Notification body for hydration reminder
  ///
  /// In en, this message translates to:
  /// **'You haven\'t drunk water for {hours} hours'**
  String reminderBody(int hours);

  /// Notification title for goal achieved
  ///
  /// In en, this message translates to:
  /// **'🎉 Well Done!'**
  String get goalAchievedTitle;

  /// Notification body for goal achieved
  ///
  /// In en, this message translates to:
  /// **'You reached your daily goal of {total} ml'**
  String goalAchievedBody(int total);

  /// No description provided for @minutesAgoSuffix.
  ///
  /// In en, this message translates to:
  /// **'min ago'**
  String get minutesAgoSuffix;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Smart Sip'**
  String get app_name;

  /// No description provided for @app_tagline.
  ///
  /// In en, this message translates to:
  /// **'Smart Hydration for a Healthier Life'**
  String get app_tagline;

  /// No description provided for @about_title.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about_title;

  /// No description provided for @version_label.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version_label;

  /// No description provided for @version_value.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get version_value;

  /// No description provided for @build_label.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build_label;

  /// No description provided for @build_value.
  ///
  /// In en, this message translates to:
  /// **'2026.06.18'**
  String get build_value;

  /// No description provided for @release_date_label.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get release_date_label;

  /// No description provided for @release_date_value.
  ///
  /// In en, this message translates to:
  /// **'June 18, 2026'**
  String get release_date_value;

  /// No description provided for @size_label.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size_label;

  /// No description provided for @size_value.
  ///
  /// In en, this message translates to:
  /// **'24.5 MB'**
  String get size_value;

  /// No description provided for @key_features_title.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get key_features_title;

  /// No description provided for @feature_hydration.
  ///
  /// In en, this message translates to:
  /// **'Smart Hydration'**
  String get feature_hydration;

  /// No description provided for @feature_ai_reminders.
  ///
  /// In en, this message translates to:
  /// **'AI Reminders'**
  String get feature_ai_reminders;

  /// No description provided for @feature_weather.
  ///
  /// In en, this message translates to:
  /// **'Weather Sync'**
  String get feature_weather;

  /// No description provided for @feature_bottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle Tracking'**
  String get feature_bottle;

  /// No description provided for @feature_achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get feature_achievements;

  /// No description provided for @feature_statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get feature_statistics;

  /// No description provided for @contact_us_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us_title;

  /// No description provided for @contact_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contact_email;

  /// No description provided for @contact_email_value.
  ///
  /// In en, this message translates to:
  /// **'support@smartsip.com'**
  String get contact_email_value;

  /// No description provided for @contact_website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get contact_website;

  /// No description provided for @contact_website_value.
  ///
  /// In en, this message translates to:
  /// **'smartsip.com'**
  String get contact_website_value;

  /// No description provided for @contact_open_source.
  ///
  /// In en, this message translates to:
  /// **'Open Source'**
  String get contact_open_source;

  /// No description provided for @contact_open_source_value.
  ///
  /// In en, this message translates to:
  /// **'github.com/smartsip'**
  String get contact_open_source_value;

  /// No description provided for @made_with_love.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️'**
  String get made_with_love;

  /// No description provided for @by_team.
  ///
  /// In en, this message translates to:
  /// **'by Smart Sip Team'**
  String get by_team;

  /// No description provided for @copyright_text.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Smart Sip. All rights reserved.'**
  String get copyright_text;

  /// No description provided for @terms_title.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_title;

  /// No description provided for @terms_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: June 18, 2026'**
  String get terms_last_updated;

  /// No description provided for @terms_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Smart Sip'**
  String get terms_welcome_title;

  /// No description provided for @terms_welcome_content.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Smart Sip, your intelligent hydration companion. By using our app, you agree to be bound by these Terms & Conditions. Please read them carefully.'**
  String get terms_welcome_content;

  /// No description provided for @terms_acceptance_title.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get terms_acceptance_title;

  /// No description provided for @terms_acceptance_content.
  ///
  /// In en, this message translates to:
  /// **'By downloading, installing, or using Smart Sip, you agree to these terms. If you do not agree, please discontinue use immediately.'**
  String get terms_acceptance_content;

  /// No description provided for @terms_data_collection_title.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get terms_data_collection_title;

  /// No description provided for @terms_data_collection_content.
  ///
  /// In en, this message translates to:
  /// **'We collect certain data to improve your experience and provide personalized hydration recommendations:'**
  String get terms_data_collection_content;

  /// No description provided for @terms_data_bullet_1.
  ///
  /// In en, this message translates to:
  /// **'Basic profile information (age, weight, height, activity level)'**
  String get terms_data_bullet_1;

  /// No description provided for @terms_data_bullet_2.
  ///
  /// In en, this message translates to:
  /// **'Hydration consumption data (drinking habits, patterns)'**
  String get terms_data_bullet_2;

  /// No description provided for @terms_data_bullet_3.
  ///
  /// In en, this message translates to:
  /// **'Device information (bottle usage, connection data)'**
  String get terms_data_bullet_3;

  /// No description provided for @terms_data_bullet_4.
  ///
  /// In en, this message translates to:
  /// **'Location data (for weather integration and hydration suggestions)'**
  String get terms_data_bullet_4;

  /// No description provided for @terms_privacy_title.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get terms_privacy_title;

  /// No description provided for @terms_privacy_content.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. All personal data is encrypted and stored securely in Firebase. We do not sell or share your data with third parties without your explicit consent.'**
  String get terms_privacy_content;

  /// No description provided for @terms_responsibilities_title.
  ///
  /// In en, this message translates to:
  /// **'User Responsibilities'**
  String get terms_responsibilities_title;

  /// No description provided for @terms_responsibilities_content.
  ///
  /// In en, this message translates to:
  /// **'As a user of Smart Sip, you agree to:'**
  String get terms_responsibilities_content;

  /// No description provided for @terms_responsibilities_bullet_1.
  ///
  /// In en, this message translates to:
  /// **'Provide accurate and truthful information'**
  String get terms_responsibilities_bullet_1;

  /// No description provided for @terms_responsibilities_bullet_2.
  ///
  /// In en, this message translates to:
  /// **'Keep your login credentials secure'**
  String get terms_responsibilities_bullet_2;

  /// No description provided for @terms_responsibilities_bullet_3.
  ///
  /// In en, this message translates to:
  /// **'Use the app responsibly and not for harmful purposes'**
  String get terms_responsibilities_bullet_3;

  /// No description provided for @terms_prohibited_title.
  ///
  /// In en, this message translates to:
  /// **'Prohibited Activities'**
  String get terms_prohibited_title;

  /// No description provided for @terms_prohibited_content.
  ///
  /// In en, this message translates to:
  /// **'The following activities are strictly prohibited:'**
  String get terms_prohibited_content;

  /// No description provided for @terms_prohibited_bullet_1.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access or hacking attempts'**
  String get terms_prohibited_bullet_1;

  /// No description provided for @terms_prohibited_bullet_2.
  ///
  /// In en, this message translates to:
  /// **'Misusing or exploiting app features'**
  String get terms_prohibited_bullet_2;

  /// No description provided for @terms_prohibited_bullet_3.
  ///
  /// In en, this message translates to:
  /// **'Sharing or redistributing app content without permission'**
  String get terms_prohibited_bullet_3;

  /// No description provided for @terms_prohibited_bullet_4.
  ///
  /// In en, this message translates to:
  /// **'Interfering with app functionality or services'**
  String get terms_prohibited_bullet_4;

  /// No description provided for @terms_intellectual_title.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get terms_intellectual_title;

  /// No description provided for @terms_intellectual_content.
  ///
  /// In en, this message translates to:
  /// **'All content, logos, designs, and features of Smart Sip are the intellectual property of Smart Sip. Unauthorized use of any materials may violate copyright and trademark laws.'**
  String get terms_intellectual_content;

  /// No description provided for @terms_termination_title.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get terms_termination_title;

  /// No description provided for @terms_termination_content.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to terminate or suspend access to our app immediately, without prior notice, for any violation of these Terms & Conditions.'**
  String get terms_termination_content;

  /// No description provided for @terms_contact_title.
  ///
  /// In en, this message translates to:
  /// **'Have Questions?'**
  String get terms_contact_title;

  /// No description provided for @terms_contact_content.
  ///
  /// In en, this message translates to:
  /// **'Contact our support team at support@smartsip.com'**
  String get terms_contact_content;

  /// No description provided for @terms_footer.
  ///
  /// In en, this message translates to:
  /// **'By using Smart Sip, you agree to these Terms & Conditions.'**
  String get terms_footer;

  /// No description provided for @privacy_title.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_title;

  /// No description provided for @privacy_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: June 18, 2026'**
  String get privacy_last_updated;

  /// No description provided for @privacy_introduction_title.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get privacy_introduction_title;

  /// No description provided for @privacy_introduction_content.
  ///
  /// In en, this message translates to:
  /// **'Smart Sip is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your personal information when you use our app.'**
  String get privacy_introduction_content;

  /// No description provided for @privacy_collect_title.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacy_collect_title;

  /// No description provided for @privacy_collect_content.
  ///
  /// In en, this message translates to:
  /// **'We collect the following types of information to improve your hydration experience:'**
  String get privacy_collect_content;

  /// No description provided for @privacy_collect_bullet_1.
  ///
  /// In en, this message translates to:
  /// **'Personal information: name, email address, and profile details'**
  String get privacy_collect_bullet_1;

  /// No description provided for @privacy_collect_bullet_2.
  ///
  /// In en, this message translates to:
  /// **'Health data: age, weight, height, and daily hydration goals'**
  String get privacy_collect_bullet_2;

  /// No description provided for @privacy_collect_bullet_3.
  ///
  /// In en, this message translates to:
  /// **'Usage data: app interactions, drinking patterns, and preferences'**
  String get privacy_collect_bullet_3;

  /// No description provided for @privacy_collect_bullet_4.
  ///
  /// In en, this message translates to:
  /// **'Device data: bottle model, connection status, and battery level'**
  String get privacy_collect_bullet_4;

  /// No description provided for @privacy_collect_bullet_5.
  ///
  /// In en, this message translates to:
  /// **'Location data: city and weather information for personalized suggestions'**
  String get privacy_collect_bullet_5;

  /// No description provided for @privacy_use_title.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacy_use_title;

  /// No description provided for @privacy_use_content.
  ///
  /// In en, this message translates to:
  /// **'We use your data for the following purposes:'**
  String get privacy_use_content;

  /// No description provided for @privacy_use_bullet_1.
  ///
  /// In en, this message translates to:
  /// **'To provide personalized hydration recommendations'**
  String get privacy_use_bullet_1;

  /// No description provided for @privacy_use_bullet_2.
  ///
  /// In en, this message translates to:
  /// **'To track your daily water intake and progress'**
  String get privacy_use_bullet_2;

  /// No description provided for @privacy_use_bullet_3.
  ///
  /// In en, this message translates to:
  /// **'To send AI-powered reminders and notifications'**
  String get privacy_use_bullet_3;

  /// No description provided for @privacy_use_bullet_4.
  ///
  /// In en, this message translates to:
  /// **'To integrate with weather data for smart hydration tips'**
  String get privacy_use_bullet_4;

  /// No description provided for @privacy_use_bullet_5.
  ///
  /// In en, this message translates to:
  /// **'To improve app performance and user experience'**
  String get privacy_use_bullet_5;

  /// No description provided for @privacy_use_bullet_6.
  ///
  /// In en, this message translates to:
  /// **'To provide customer support and feedback assistance'**
  String get privacy_use_bullet_6;

  /// No description provided for @privacy_use_bullet_7.
  ///
  /// In en, this message translates to:
  /// **'To analyze trends and enhance features'**
  String get privacy_use_bullet_7;

  /// No description provided for @privacy_storage_title.
  ///
  /// In en, this message translates to:
  /// **'Data Storage & Security'**
  String get privacy_storage_title;

  /// No description provided for @privacy_storage_content.
  ///
  /// In en, this message translates to:
  /// **'All data is stored securely in Firebase Realtime Database with encryption at rest. We implement industry-standard security measures to protect against unauthorized access, data loss, or misuse.'**
  String get privacy_storage_content;

  /// No description provided for @privacy_sharing_title.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get privacy_sharing_title;

  /// No description provided for @privacy_sharing_content.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your data to third parties. However, we may share data in the following cases:'**
  String get privacy_sharing_content;

  /// No description provided for @privacy_sharing_bullet_1.
  ///
  /// In en, this message translates to:
  /// **'With your explicit consent'**
  String get privacy_sharing_bullet_1;

  /// No description provided for @privacy_sharing_bullet_2.
  ///
  /// In en, this message translates to:
  /// **'To comply with legal obligations'**
  String get privacy_sharing_bullet_2;

  /// No description provided for @privacy_sharing_bullet_3.
  ///
  /// In en, this message translates to:
  /// **'To protect our rights and safety'**
  String get privacy_sharing_bullet_3;

  /// No description provided for @privacy_sharing_bullet_4.
  ///
  /// In en, this message translates to:
  /// **'With trusted service providers (e.g., Firebase, weather APIs)'**
  String get privacy_sharing_bullet_4;

  /// No description provided for @privacy_sharing_bullet_5.
  ///
  /// In en, this message translates to:
  /// **'In aggregated, anonymized form for analytics'**
  String get privacy_sharing_bullet_5;

  /// No description provided for @privacy_rights_title.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacy_rights_title;

  /// No description provided for @privacy_rights_content.
  ///
  /// In en, this message translates to:
  /// **'You have the following rights regarding your personal data:'**
  String get privacy_rights_content;

  /// No description provided for @privacy_rights_bullet_1.
  ///
  /// In en, this message translates to:
  /// **'Access your data at any time'**
  String get privacy_rights_bullet_1;

  /// No description provided for @privacy_rights_bullet_2.
  ///
  /// In en, this message translates to:
  /// **'Request corrections to inaccurate information'**
  String get privacy_rights_bullet_2;

  /// No description provided for @privacy_rights_bullet_3.
  ///
  /// In en, this message translates to:
  /// **'Delete your account and associated data'**
  String get privacy_rights_bullet_3;

  /// No description provided for @privacy_rights_bullet_4.
  ///
  /// In en, this message translates to:
  /// **'Object to or restrict data processing'**
  String get privacy_rights_bullet_4;

  /// No description provided for @privacy_rights_bullet_5.
  ///
  /// In en, this message translates to:
  /// **'Export your data in a portable format'**
  String get privacy_rights_bullet_5;

  /// No description provided for @privacy_rights_bullet_6.
  ///
  /// In en, this message translates to:
  /// **'Withdraw consent at any time'**
  String get privacy_rights_bullet_6;

  /// No description provided for @privacy_third_party_title.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get privacy_third_party_title;

  /// No description provided for @privacy_third_party_content.
  ///
  /// In en, this message translates to:
  /// **'We integrate with third-party services including Firebase (data storage), weather APIs (location data), and analytics tools to improve our app. These services have their own privacy policies.'**
  String get privacy_third_party_content;

  /// No description provided for @privacy_children_title.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get privacy_children_title;

  /// No description provided for @privacy_children_content.
  ///
  /// In en, this message translates to:
  /// **'Smart Sip is intended for users aged 13 and above. We do not knowingly collect personal information from children under 13. If you believe we have collected such data, please contact us.'**
  String get privacy_children_content;

  /// No description provided for @privacy_cookies_title.
  ///
  /// In en, this message translates to:
  /// **'Cookies & Tracking'**
  String get privacy_cookies_title;

  /// No description provided for @privacy_cookies_content.
  ///
  /// In en, this message translates to:
  /// **'We use minimal cookies and local storage to improve app performance and remember your preferences. You can clear this data at any time from your device settings.'**
  String get privacy_cookies_content;

  /// No description provided for @privacy_updates_title.
  ///
  /// In en, this message translates to:
  /// **'Policy Updates'**
  String get privacy_updates_title;

  /// No description provided for @privacy_updates_content.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy periodically. We will notify you of any significant changes through the app or via email. Continued use constitutes acceptance of the updated policy.'**
  String get privacy_updates_content;

  /// No description provided for @privacy_contact_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get privacy_contact_title;

  /// No description provided for @privacy_contact_content.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or concerns about our privacy practices, contact us at privacy@smartsip.com'**
  String get privacy_contact_content;

  /// No description provided for @privacy_footer.
  ///
  /// In en, this message translates to:
  /// **'We value your privacy. Thank you for trusting Smart Sip.'**
  String get privacy_footer;

  /// No description provided for @onboarding_complete_message.
  ///
  /// In en, this message translates to:
  /// **'🎉 Great! You\'re all set. Customize your hydration experience.'**
  String get onboarding_complete_message;

  /// No description provided for @activity_skipped_message.
  ///
  /// In en, this message translates to:
  /// **'You skipped selecting your activity level. You can update it later in your profile.'**
  String get activity_skipped_message;

  /// No description provided for @location_skipped_message.
  ///
  /// In en, this message translates to:
  /// **'Location access helps us suggest weather-based hydration. You can enable it later in settings.'**
  String get location_skipped_message;

  /// No description provided for @both_skipped_message.
  ///
  /// In en, this message translates to:
  /// **'For the best experience, please enable location and select your activity level. You can do this anytime in settings.'**
  String get both_skipped_message;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotificationsTitle;

  /// No description provided for @noNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hydration reminders, spill alerts, and daily achievements will appear here.'**
  String get noNotificationsSubtitle;
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
