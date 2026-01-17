import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('en'),
    Locale('es'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'FoodJury'**
  String get appTitle;

  /// App tagline shown on splash screen
  ///
  /// In en, this message translates to:
  /// **'Order in the kitchen!'**
  String get appTagline;

  /// Generic OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_ok;

  /// Generic cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// Generic delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// Generic save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// Generic yes confirmation
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get common_yes;

  /// Generic no confirmation
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get common_no;

  /// Back navigation label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_close;

  /// Morning greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'Good morning, hungry one!'**
  String get greeting_morning;

  /// Afternoon greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, hungry one!'**
  String get greeting_afternoon;

  /// Evening greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'Good evening, hungry one!'**
  String get greeting_evening;

  /// Late night greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'Good night, hungry one!'**
  String get greeting_night;

  /// Button to start a new food decision
  ///
  /// In en, this message translates to:
  /// **'New Decision'**
  String get home_newDecision;

  /// Section header for recent decisions
  ///
  /// In en, this message translates to:
  /// **'Recent Verdicts'**
  String get home_recentVerdicts;

  /// Title for empty state when user has no decisions
  ///
  /// In en, this message translates to:
  /// **'No verdicts yet...'**
  String get home_emptyTitle;

  /// Message for empty state on home screen
  ///
  /// In en, this message translates to:
  /// **'The court is empty! Time to bring a case.'**
  String get home_emptyMessage;

  /// Button text for first decision on empty home screen
  ///
  /// In en, this message translates to:
  /// **'Start Your First Case'**
  String get home_emptyAction;

  /// Header for new decision screen
  ///
  /// In en, this message translates to:
  /// **'What\'s the dilemma?'**
  String get decision_screenTitle;

  /// Section header for food options list
  ///
  /// In en, this message translates to:
  /// **'YOUR OPTIONS'**
  String get decision_yourOptions;

  /// Button to add a new food option
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get decision_addOption;

  /// Placeholder text for add option button
  ///
  /// In en, this message translates to:
  /// **'Tap to add'**
  String get decision_tapToAdd;

  /// Section header for objective selection
  ///
  /// In en, this message translates to:
  /// **'WHAT\'S YOUR GOAL?'**
  String get decision_whatsYourGoal;

  /// Submit button to get verdict
  ///
  /// In en, this message translates to:
  /// **'Let the Judge Decide'**
  String get decision_letJudgeDecide;

  /// Error shown when trying to submit with less than 2 options
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 options to proceed'**
  String get decision_minOptionsError;

  /// Header for add option bottom sheet
  ///
  /// In en, this message translates to:
  /// **'ADD OPTION'**
  String get option_add;

  /// Placeholder for image picker
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get option_tapToAddPhoto;

  /// Label for option name input
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get option_nameLabel;

  /// Hint text for option name input
  ///
  /// In en, this message translates to:
  /// **'What is it?'**
  String get option_nameHint;

  /// Label for option notes input
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get option_notesLabel;

  /// Hint text for option notes input
  ///
  /// In en, this message translates to:
  /// **'Any details the judge should know?'**
  String get option_notesHint;

  /// Button to confirm adding option
  ///
  /// In en, this message translates to:
  /// **'Add to Case'**
  String get option_addToCase;

  /// Confirmation dialog title for deleting an option
  ///
  /// In en, this message translates to:
  /// **'Delete Option?'**
  String get option_deleteConfirmTitle;

  /// Confirmation dialog message for deleting an option
  ///
  /// In en, this message translates to:
  /// **'This will remove the option from your case.'**
  String get option_deleteConfirmMessage;

  /// Fun objective label
  ///
  /// In en, this message translates to:
  /// **'Fun'**
  String get objective_fun;

  /// Healthy objective label
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get objective_healthy;

  /// Fit objective label
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get objective_fit;

  /// Quick objective label
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get objective_quick;

  /// Loading message while AI processes
  ///
  /// In en, this message translates to:
  /// **'The court is in session...'**
  String get loading_courtInSession;

  /// Loading message variant
  ///
  /// In en, this message translates to:
  /// **'Examining the evidence...'**
  String get loading_examiningEvidence;

  /// Loading message variant
  ///
  /// In en, this message translates to:
  /// **'Deliberating...'**
  String get loading_deliberating;

  /// Loading message variant
  ///
  /// In en, this message translates to:
  /// **'Almost there...'**
  String get loading_almostThere;

  /// Main verdict reveal title
  ///
  /// In en, this message translates to:
  /// **'THE VERDICT IS IN'**
  String get verdict_theVerdictIsIn;

  /// Winner badge text
  ///
  /// In en, this message translates to:
  /// **'WINNER'**
  String get verdict_winner;

  /// Section header for AI reasoning
  ///
  /// In en, this message translates to:
  /// **'Judge\'s Notes'**
  String get verdict_judgesNotes;

  /// Button to expand and show all options ranked
  ///
  /// In en, this message translates to:
  /// **'See all rankings'**
  String get verdict_seeAllRankings;

  /// Button to collapse rankings
  ///
  /// In en, this message translates to:
  /// **'Hide rankings'**
  String get verdict_hideRankings;

  /// Button to start another decision
  ///
  /// In en, this message translates to:
  /// **'New Decision'**
  String get verdict_newDecision;

  /// Button to start another decision (alternative)
  ///
  /// In en, this message translates to:
  /// **'New Case'**
  String get verdict_newCase;

  /// Button to share verdict
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get verdict_share;

  /// Header for history screen
  ///
  /// In en, this message translates to:
  /// **'Past Verdicts'**
  String get history_screenTitle;

  /// Title for empty history state
  ///
  /// In en, this message translates to:
  /// **'The court records are empty...'**
  String get history_emptyTitle;

  /// Message for empty history state
  ///
  /// In en, this message translates to:
  /// **'No cases have been decided yet!'**
  String get history_emptyMessage;

  /// Section header for today's decisions
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get history_today;

  /// Section header for yesterday's decisions
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get history_yesterday;

  /// Section header for this week's decisions
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get history_thisWeek;

  /// Confirmation dialog title for deleting a decision
  ///
  /// In en, this message translates to:
  /// **'Delete Decision?'**
  String get history_deleteConfirmTitle;

  /// Confirmation dialog message for deleting a decision
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get history_deleteConfirmMessage;

  /// Header for settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_screenTitle;

  /// Section header for tone selection
  ///
  /// In en, this message translates to:
  /// **'JUDGE\'S PERSONALITY'**
  String get settings_judgePersonality;

  /// Section header for appearance settings
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settings_appearance;

  /// Section header for subscription settings
  ///
  /// In en, this message translates to:
  /// **'SUBSCRIPTION'**
  String get settings_subscription;

  /// About link
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about;

  /// Privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settings_privacy;

  /// Terms of service link
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get settings_terms;

  /// Stern judge personality option
  ///
  /// In en, this message translates to:
  /// **'Stern & Fair'**
  String get tone_stern;

  /// Preview text for stern tone
  ///
  /// In en, this message translates to:
  /// **'The court finds...'**
  String get tone_sternPreview;

  /// Sassy judge personality option
  ///
  /// In en, this message translates to:
  /// **'Sassy'**
  String get tone_sassy;

  /// Preview text for sassy tone
  ///
  /// In en, this message translates to:
  /// **'Listen, I\'ve seen...'**
  String get tone_sassyPreview;

  /// Enthusiastic judge personality option
  ///
  /// In en, this message translates to:
  /// **'Enthusiastic'**
  String get tone_enthusiastic;

  /// Preview text for enthusiastic tone
  ///
  /// In en, this message translates to:
  /// **'OH WOW! This is...'**
  String get tone_enthusiasticPreview;

  /// Chill judge personality option
  ///
  /// In en, this message translates to:
  /// **'Chill'**
  String get tone_chill;

  /// Preview text for chill tone
  ///
  /// In en, this message translates to:
  /// **'So like, here\'s...'**
  String get tone_chillPreview;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get theme_system;

  /// Pro subscription tier name
  ///
  /// In en, this message translates to:
  /// **'FoodJury Pro'**
  String get subscription_pro;

  /// Pro feature description
  ///
  /// In en, this message translates to:
  /// **'Unlimited decisions'**
  String get subscription_unlimitedDecisions;

  /// Button to upgrade to pro
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get subscription_upgradeNow;

  /// Error message for no internet connection
  ///
  /// In en, this message translates to:
  /// **'The court is offline...'**
  String get error_noInternet;

  /// Secondary message for no internet
  ///
  /// In en, this message translates to:
  /// **'Wake me when we\'re back online!'**
  String get error_noInternetMessage;

  /// Button to retry after error
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get error_tryAgain;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get error_genericTitle;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error_genericMessage;

  /// Button to skip onboarding
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// Button to go to next onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// Button to finish onboarding
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_getStarted;

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Meet Judge Bite'**
  String get onboarding_welcome_title;

  /// First onboarding screen message
  ///
  /// In en, this message translates to:
  /// **'Your personal food court judge who helps you make delicious decisions!'**
  String get onboarding_welcome_message;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get onboarding_howItWorks_title;

  /// Second onboarding screen message
  ///
  /// In en, this message translates to:
  /// **'Add your food options, set your goal, and let the judge deliver the verdict!'**
  String get onboarding_howItWorks_message;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Pick Your Style'**
  String get onboarding_personality_title;

  /// Third onboarding screen message
  ///
  /// In en, this message translates to:
  /// **'Choose how Judge Bite should deliver verdicts. You can change this anytime!'**
  String get onboarding_personality_message;

  /// Success message when decision is saved
  ///
  /// In en, this message translates to:
  /// **'Decision recorded!'**
  String get snackbar_decisionSaved;

  /// Success message when option is added
  ///
  /// In en, this message translates to:
  /// **'Option added to the case'**
  String get snackbar_optionAdded;

  /// Success message when option is deleted
  ///
  /// In en, this message translates to:
  /// **'Option removed'**
  String get snackbar_optionDeleted;

  /// Success message when decision is deleted
  ///
  /// In en, this message translates to:
  /// **'Decision deleted'**
  String get snackbar_decisionDeleted;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
