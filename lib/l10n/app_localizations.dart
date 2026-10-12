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

  /// Header for joke bonus content
  ///
  /// In en, this message translates to:
  /// **'Judge\'s Joke'**
  String get verdict_bonusJoke;

  /// Header for fun fact bonus content
  ///
  /// In en, this message translates to:
  /// **'Fun Fact'**
  String get verdict_bonusFunFact;

  /// Header for tip bonus content
  ///
  /// In en, this message translates to:
  /// **'Pro Tip'**
  String get verdict_bonusTip;

  /// Header for story bonus content
  ///
  /// In en, this message translates to:
  /// **'Story Time'**
  String get verdict_bonusStory;

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

  /// Section header for older decisions
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get history_earlier;

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

  /// Section header for developer settings (only in dev mode)
  ///
  /// In en, this message translates to:
  /// **'DEVELOPER OPTIONS'**
  String get settings_devSection;

  /// Toggle for using mock AI instead of real AI
  ///
  /// In en, this message translates to:
  /// **'Use Simulated AI'**
  String get settings_useMockAi;

  /// Description for mock AI toggle
  ///
  /// In en, this message translates to:
  /// **'Use offline mock responses instead of real AI calls'**
  String get settings_useMockAiDescription;

  /// Snackbar message when mock AI is enabled
  ///
  /// In en, this message translates to:
  /// **'Simulated AI enabled'**
  String get settings_mockAiEnabled;

  /// Snackbar message when mock AI is disabled
  ///
  /// In en, this message translates to:
  /// **'Real AI enabled'**
  String get settings_mockAiDisabled;

  /// Footer text showing app origin
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ from Puerto Rico 🇵🇷'**
  String get settings_madeWithLove;

  /// Title for about developer screen
  ///
  /// In en, this message translates to:
  /// **'About the Developer'**
  String get about_developer;

  /// Section header for bio
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get about_aboutMe;

  /// Section header for skills
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get about_skills;

  /// Section header for published apps
  ///
  /// In en, this message translates to:
  /// **'Published Apps'**
  String get about_publishedApps;

  /// Section header for app info
  ///
  /// In en, this message translates to:
  /// **'About FoodJury'**
  String get about_aboutFoodJury;

  /// Description of the FoodJury app
  ///
  /// In en, this message translates to:
  /// **'Can’t decide what to eat? Bring your cravings to court. Judge Bite serves thoughtful Smart rulings and wildly fun Lucky Court rituals, all in a playful retro diner.'**
  String get about_foodJuryDescription;

  /// Section header for contact links
  ///
  /// In en, this message translates to:
  /// **'Let\'s Connect'**
  String get about_connect;

  /// Button text to go to about developer screen
  ///
  /// In en, this message translates to:
  /// **'Meet the Developer'**
  String get about_meetDeveloper;

  /// Developer's name
  ///
  /// In en, this message translates to:
  /// **'Armando Jiménez'**
  String get about_developerName;

  /// Developer's job title badge
  ///
  /// In en, this message translates to:
  /// **'MOBILE DEVELOPER'**
  String get about_developerTitle;

  /// Developer's location
  ///
  /// In en, this message translates to:
  /// **'Carolina, Puerto Rico 🇵🇷'**
  String get about_developerLocation;

  /// Bio introduction paragraph
  ///
  /// In en, this message translates to:
  /// **'Hey! I\'m Armando, a mobile developer from Carolina, Puerto Rico. 🇵🇷'**
  String get about_bioIntro;

  /// Bio passion paragraph
  ///
  /// In en, this message translates to:
  /// **'I have a deep passion for building apps that make people smile, feel positive, and maybe even change the way they see the world. Whether it\'s a fun tool, something for mental wellness, or just an app that brings a little joy to your day, I pour my heart into everything I create.'**
  String get about_bioPassion;

  /// Bio motivation paragraph
  ///
  /// In en, this message translates to:
  /// **'What drives me? Knowing that something I built might be used by millions of people around the world. That someone in another country might open my app and feel a little bit better. That\'s the magic of mobile development, and I\'m grateful to be part of it.'**
  String get about_bioDrive;

  /// Bio closing statement
  ///
  /// In en, this message translates to:
  /// **'Everything I create is made with love, from Puerto Rico to the world. 🌴❤️'**
  String get about_bioClosing;

  /// Years of experience label
  ///
  /// In en, this message translates to:
  /// **'YEARS'**
  String get about_statsYears;

  /// User count label
  ///
  /// In en, this message translates to:
  /// **'USERS'**
  String get about_statsUsers;

  /// Love/passion label
  ///
  /// In en, this message translates to:
  /// **'LOVE'**
  String get about_statsLove;

  /// Website contact button
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get about_contactWebsite;

  /// GitHub contact button
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get about_contactGitHub;

  /// LinkedIn contact button
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get about_contactLinkedIn;

  /// Email contact button
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get about_contactEmail;

  /// Believe app name
  ///
  /// In en, this message translates to:
  /// **'Believe'**
  String get about_appBelieve;

  /// Believe app subtitle
  ///
  /// In en, this message translates to:
  /// **'Daily Affirmations'**
  String get about_appBelieveSubtitle;

  /// Holy app name
  ///
  /// In en, this message translates to:
  /// **'Holy'**
  String get about_appHoly;

  /// Holy app subtitle
  ///
  /// In en, this message translates to:
  /// **'Daily Bible Verses'**
  String get about_appHolySubtitle;

  /// Unique app name
  ///
  /// In en, this message translates to:
  /// **'Unique'**
  String get about_appUnique;

  /// Unique app subtitle
  ///
  /// In en, this message translates to:
  /// **'Self-Love Reminders'**
  String get about_appUniqueSubtitle;

  /// Motiv app name
  ///
  /// In en, this message translates to:
  /// **'Motiv'**
  String get about_appMotiv;

  /// Motiv app subtitle
  ///
  /// In en, this message translates to:
  /// **'Inspirational Quotes'**
  String get about_appMotivSubtitle;

  /// Divine app name
  ///
  /// In en, this message translates to:
  /// **'Divine'**
  String get about_appDivine;

  /// Divine app subtitle
  ///
  /// In en, this message translates to:
  /// **'Angel Messages'**
  String get about_appDivineSubtitle;

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

  /// Network connectivity error message
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Please check your internet connection.'**
  String get error_networkError;

  /// Network error dialog title
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get error_networkErrorTitle;

  /// AI service error message with personality
  ///
  /// In en, this message translates to:
  /// **'Judge Bite is taking a break. Please try again in a moment.'**
  String get error_aiServiceError;

  /// Timeout error message
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get error_timeoutError;

  /// Generic retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

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

  /// Button to add a photo to an option
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get image_addPhoto;

  /// Button to change an existing photo
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get image_changePhoto;

  /// Button to remove a photo
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get image_removePhoto;

  /// Option to take a new photo with camera
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get image_takePhoto;

  /// Option to select a photo from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get image_chooseFromGallery;

  /// Label for photo section in retro courtroom style
  ///
  /// In en, this message translates to:
  /// **'Photo Evidence'**
  String get image_photoEvidence;

  /// Title for camera permission dialog
  ///
  /// In en, this message translates to:
  /// **'Camera Access Needed'**
  String get permission_cameraTitle;

  /// Message explaining why camera permission is needed
  ///
  /// In en, this message translates to:
  /// **'Please allow camera access to snap photos of your food options.'**
  String get permission_cameraMessage;

  /// Title for photo library permission dialog
  ///
  /// In en, this message translates to:
  /// **'Photo Library Access Needed'**
  String get permission_galleryTitle;

  /// Message explaining why gallery permission is needed
  ///
  /// In en, this message translates to:
  /// **'Please allow photo library access to select photos of your food options.'**
  String get permission_galleryMessage;

  /// Title when permission was denied
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permission_deniedTitle;

  /// Message when permission was denied
  ///
  /// In en, this message translates to:
  /// **'Without this permission, you cannot add photos. You can enable it in Settings.'**
  String get permission_deniedMessage;

  /// Button to open app settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get permission_openSettings;

  /// Error when image fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get error_imageLoad;

  /// Success message when photo is added
  ///
  /// In en, this message translates to:
  /// **'Photo evidence added!'**
  String get snackbar_photoAdded;

  /// Success message when photo is removed
  ///
  /// In en, this message translates to:
  /// **'Photo removed'**
  String get snackbar_photoRemoved;

  /// Generic loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// Status text when no options added
  ///
  /// In en, this message translates to:
  /// **'Add your food options to begin'**
  String get decision_addOptionsToBegin;

  /// Status text showing how many more options needed
  ///
  /// In en, this message translates to:
  /// **'Add {count} more option{count, plural, =1{} other{s}}'**
  String decision_addMoreOptions(int count);

  /// Status text when options added but no goal selected
  ///
  /// In en, this message translates to:
  /// **'Now pick your goal!'**
  String get decision_pickYourGoal;

  /// Status text when ready to submit
  ///
  /// In en, this message translates to:
  /// **'Ready for the verdict!'**
  String get decision_readyForVerdict;

  /// Empty state title for options list
  ///
  /// In en, this message translates to:
  /// **'No evidence yet!'**
  String get decision_noEvidenceYet;

  /// Empty state message for options list
  ///
  /// In en, this message translates to:
  /// **'Add your food options to build your case'**
  String get decision_addOptionsToBuildCase;

  /// Button text to add first option
  ///
  /// In en, this message translates to:
  /// **'Add First Option'**
  String get decision_addFirstOption;

  /// Header for add option sheet
  ///
  /// In en, this message translates to:
  /// **'Add to your case'**
  String get decision_addToYourCase;

  /// Shows remaining option slots
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String decision_slotsLeft(int count);

  /// Validation error for empty name field
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get validation_pleaseEnterName;

  /// Judge Bite message when no options
  ///
  /// In en, this message translates to:
  /// **'Present your evidence!'**
  String get judgeBite_presentEvidence;

  /// Judge Bite message with only one option
  ///
  /// In en, this message translates to:
  /// **'One option? Add more to compare!'**
  String get judgeBite_addMoreToCompare;

  /// Judge Bite message when no goal selected
  ///
  /// In en, this message translates to:
  /// **'Now tell me your goal!'**
  String get judgeBite_tellMeYourGoal;

  /// Judge Bite message when ready to submit
  ///
  /// In en, this message translates to:
  /// **'Ready to deliver the verdict!'**
  String get judgeBite_readyToDeliver;

  /// Judge Bite message while building case
  ///
  /// In en, this message translates to:
  /// **'Building a solid case...'**
  String get judgeBite_buildingCase;

  /// Accessibility label for remove option button
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String a11y_removeOption(String name);

  /// Accessibility label for option photo
  ///
  /// In en, this message translates to:
  /// **'Photo of {name}'**
  String a11y_photoOf(String name);

  /// Retro diner design copy: diner_court
  ///
  /// In en, this message translates to:
  /// **'Court'**
  String get diner_court;

  /// Retro diner design copy: diner_history
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get diner_history;

  /// Retro diner design copy: diner_homeTitle
  ///
  /// In en, this message translates to:
  /// **'Hungry?\nCourt’s in session.'**
  String get diner_homeTitle;

  /// Retro diner design copy: diner_homeSubtitle
  ///
  /// In en, this message translates to:
  /// **'Bring your options. Judge Bite will settle it.'**
  String get diner_homeSubtitle;

  /// Retro diner design copy: diner_startCase
  ///
  /// In en, this message translates to:
  /// **'Start a food case'**
  String get diner_startCase;

  /// Retro diner design copy: diner_recent
  ///
  /// In en, this message translates to:
  /// **'Recent verdicts'**
  String get diner_recent;

  /// Retro diner design copy: diner_viewAll
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get diner_viewAll;

  /// Retro diner design copy: diner_newCase
  ///
  /// In en, this message translates to:
  /// **'New case'**
  String get diner_newCase;

  /// Retro diner design copy: diner_menuTitle
  ///
  /// In en, this message translates to:
  /// **'What’s on the menu?'**
  String get diner_menuTitle;

  /// Retro diner design copy: diner_menuHint
  ///
  /// In en, this message translates to:
  /// **'Add 2–5 contenders. Photos are optional.'**
  String get diner_menuHint;

  /// Retro diner design copy: diner_addAnother
  ///
  /// In en, this message translates to:
  /// **'Add another option'**
  String get diner_addAnother;

  /// Retro diner design copy: diner_mood
  ///
  /// In en, this message translates to:
  /// **'Tonight’s mood'**
  String get diner_mood;

  /// Retro diner design copy: diner_caseClosed
  ///
  /// In en, this message translates to:
  /// **'Case closed'**
  String get diner_caseClosed;

  /// Retro diner design copy: diner_approved
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get diner_approved;

  /// Retro diner design copy: diner_ruling
  ///
  /// In en, this message translates to:
  /// **'Judge Bite’s ruling'**
  String get diner_ruling;

  /// Retro diner design copy: diner_otherOptions
  ///
  /// In en, this message translates to:
  /// **'See the other options'**
  String get diner_otherOptions;

  /// Retro diner design copy: diner_share
  ///
  /// In en, this message translates to:
  /// **'Share verdict'**
  String get diner_share;

  /// Retro diner design copy: diner_anotherCase
  ///
  /// In en, this message translates to:
  /// **'Start another case'**
  String get diner_anotherCase;

  /// Retro diner design copy: diner_deliberating
  ///
  /// In en, this message translates to:
  /// **'The jury is deliberating…'**
  String get diner_deliberating;

  /// Retro diner design copy: diner_weighing
  ///
  /// In en, this message translates to:
  /// **'Weighing the delicious evidence.'**
  String get diner_weighing;

  /// Retro diner design copy: diner_reveal
  ///
  /// In en, this message translates to:
  /// **'The verdict is in!'**
  String get diner_reveal;

  /// Retro diner design copy: diner_revealNow
  ///
  /// In en, this message translates to:
  /// **'Show my verdict'**
  String get diner_revealNow;

  /// Retro diner design copy: diner_replay
  ///
  /// In en, this message translates to:
  /// **'Replay the reveal'**
  String get diner_replay;

  /// Retro diner design copy: diner_editOption
  ///
  /// In en, this message translates to:
  /// **'Edit option'**
  String get diner_editOption;

  /// Retro diner design copy: diner_saveOption
  ///
  /// In en, this message translates to:
  /// **'Save option'**
  String get diner_saveOption;

  /// Retro diner design copy: diner_deleteOption
  ///
  /// In en, this message translates to:
  /// **'Remove option'**
  String get diner_deleteOption;

  /// Retro diner design copy: diner_emptyMenu
  ///
  /// In en, this message translates to:
  /// **'Every great case starts with two contenders.'**
  String get diner_emptyMenu;

  /// Retro diner design copy: diner_archiveTitle
  ///
  /// In en, this message translates to:
  /// **'The case files'**
  String get diner_archiveTitle;

  /// Retro diner design copy: diner_archiveSubtitle
  ///
  /// In en, this message translates to:
  /// **'Good taste. On the record.'**
  String get diner_archiveSubtitle;

  /// Retro diner design copy: diner_settingsTitle
  ///
  /// In en, this message translates to:
  /// **'House rules'**
  String get diner_settingsTitle;

  /// Retro diner design copy: diner_settingsSubtitle
  ///
  /// In en, this message translates to:
  /// **'Your court. Your kind of judge.'**
  String get diner_settingsSubtitle;

  /// Retro diner design copy: diner_personalityHint
  ///
  /// In en, this message translates to:
  /// **'This is how Judge Bite will deliver your next verdict.'**
  String get diner_personalityHint;

  /// Retro diner design copy: diner_aboutTitle
  ///
  /// In en, this message translates to:
  /// **'Made with appetite'**
  String get diner_aboutTitle;

  /// Retro diner design copy: diner_demo
  ///
  /// In en, this message translates to:
  /// **'Try a sample case'**
  String get diner_demo;

  /// Retro diner design copy: diner_demoHint
  ///
  /// In en, this message translates to:
  /// **'A preview with sample options. Your next case starts fresh.'**
  String get diner_demoHint;

  /// Retro diner design copy: diner_noPhoto
  ///
  /// In en, this message translates to:
  /// **'No photo needed. Taste makes the case.'**
  String get diner_noPhoto;

  /// Retro diner design copy: diner_maxOptions
  ///
  /// In en, this message translates to:
  /// **'Five contenders. One delicious verdict.'**
  String get diner_maxOptions;

  /// Retro diner design copy: diner_routeError
  ///
  /// In en, this message translates to:
  /// **'Wrong courtroom!'**
  String get diner_routeError;

  /// Retro diner design copy: diner_goHome
  ///
  /// In en, this message translates to:
  /// **'Back to court'**
  String get diner_goHome;

  /// Retro diner design copy: diner_copied
  ///
  /// In en, this message translates to:
  /// **'Verdict copied. Ready to share!'**
  String get diner_copied;

  /// Retro diner design copy: diner_wins
  ///
  /// In en, this message translates to:
  /// **'{food} wins!'**
  String diner_wins(String food);

  /// Retro diner design copy: diner_bestFor
  ///
  /// In en, this message translates to:
  /// **'Best for {goal}'**
  String diner_bestFor(String goal);

  /// Retro diner design copy: diner_verdictCount
  ///
  /// In en, this message translates to:
  /// **'{count} cases on the record'**
  String diner_verdictCount(int count);

  /// Retro diner design copy: diner_deleteCase
  ///
  /// In en, this message translates to:
  /// **'Delete this case?'**
  String get diner_deleteCase;

  /// Retro diner design copy: diner_deleteCaseHint
  ///
  /// In en, this message translates to:
  /// **'This verdict will be removed from your history.'**
  String get diner_deleteCaseHint;

  /// Retro diner design copy: diner_bonus
  ///
  /// In en, this message translates to:
  /// **'On the side'**
  String get diner_bonus;

  /// Retro diner design copy: diner_nameLimit
  ///
  /// In en, this message translates to:
  /// **'Keep the name under 80 characters.'**
  String get diner_nameLimit;

  /// Retro diner design copy: diner_notesLimit
  ///
  /// In en, this message translates to:
  /// **'Keep notes under 500 characters.'**
  String get diner_notesLimit;

  /// Retro diner design copy: diner_emptyArchive
  ///
  /// In en, this message translates to:
  /// **'No cases on the record. Yet.'**
  String get diner_emptyArchive;

  /// Retro diner design copy: diner_archiveHint
  ///
  /// In en, this message translates to:
  /// **'Your delicious decisions will be right here.'**
  String get diner_archiveHint;

  /// Retro diner design copy: diner_welcome
  ///
  /// In en, this message translates to:
  /// **'Order in the kitchen!'**
  String get diner_welcome;

  /// Diner verdict screen title
  ///
  /// In en, this message translates to:
  /// **'The verdict'**
  String get diner_verdict;

  /// No description provided for @diner_kitchen.
  ///
  /// In en, this message translates to:
  /// **'Design kitchen'**
  String get diner_kitchen;

  /// No description provided for @diner_cast.
  ///
  /// In en, this message translates to:
  /// **'Meet Judge Bite'**
  String get diner_cast;

  /// No description provided for @diner_demoActions.
  ///
  /// In en, this message translates to:
  /// **'Try the details'**
  String get diner_demoActions;

  /// No description provided for @diner_demoFood.
  ///
  /// In en, this message translates to:
  /// **'Tacos al pastor'**
  String get diner_demoFood;

  /// No description provided for @diner_demoReasoning.
  ///
  /// In en, this message translates to:
  /// **'A little smoky, a little spicy, and a whole lot of joy. These tacos take the crown. Case closed!'**
  String get diner_demoReasoning;

  /// No description provided for @diner_demoDialog.
  ///
  /// In en, this message translates to:
  /// **'Preview a dialog'**
  String get diner_demoDialog;

  /// No description provided for @diner_demoSheet.
  ///
  /// In en, this message translates to:
  /// **'Preview a sheet'**
  String get diner_demoSheet;

  /// No description provided for @diner_poseIdle.
  ///
  /// In en, this message translates to:
  /// **'In session'**
  String get diner_poseIdle;

  /// No description provided for @diner_poseThinking.
  ///
  /// In en, this message translates to:
  /// **'Deliberating'**
  String get diner_poseThinking;

  /// No description provided for @diner_poseExcited.
  ///
  /// In en, this message translates to:
  /// **'Ready to rule'**
  String get diner_poseExcited;

  /// No description provided for @diner_poseStern.
  ///
  /// In en, this message translates to:
  /// **'Order in court'**
  String get diner_poseStern;

  /// No description provided for @diner_poseConfused.
  ///
  /// In en, this message translates to:
  /// **'Objection?'**
  String get diner_poseConfused;

  /// No description provided for @diner_poseCelebrating.
  ///
  /// In en, this message translates to:
  /// **'Case closed!'**
  String get diner_poseCelebrating;

  /// No description provided for @diner_poseSleeping.
  ///
  /// In en, this message translates to:
  /// **'Court recess'**
  String get diner_poseSleeping;

  /// No description provided for @diner_poseEating.
  ///
  /// In en, this message translates to:
  /// **'Taste test'**
  String get diner_poseEating;

  /// No description provided for @diner_posePointing.
  ///
  /// In en, this message translates to:
  /// **'Your evidence'**
  String get diner_posePointing;

  /// No description provided for @diner_poseWaving.
  ///
  /// In en, this message translates to:
  /// **'Welcome in'**
  String get diner_poseWaving;

  /// Developer diner page: diner_behindCounter
  ///
  /// In en, this message translates to:
  /// **'Behind the counter'**
  String get diner_behindCounter;

  /// Developer diner page: diner_moreFromKitchen
  ///
  /// In en, this message translates to:
  /// **'More from my kitchen'**
  String get diner_moreFromKitchen;

  /// Developer diner page: diner_makerStamp
  ///
  /// In en, this message translates to:
  /// **'Meet the maker'**
  String get diner_makerStamp;

  /// Tablet home court guide: diner_houseRules
  ///
  /// In en, this message translates to:
  /// **'House rules'**
  String get diner_houseRules;

  /// Tablet home court guide: diner_houseStepOne
  ///
  /// In en, this message translates to:
  /// **'Bring 2–5 contenders. Photos are welcome.'**
  String get diner_houseStepOne;

  /// Tablet home court guide: diner_houseStepTwo
  ///
  /// In en, this message translates to:
  /// **'Pick what matters: fun, healthy, fit, or quick.'**
  String get diner_houseStepTwo;

  /// Tablet home court guide: diner_houseStepThree
  ///
  /// In en, this message translates to:
  /// **'The judge settles it. You enjoy it.'**
  String get diner_houseStepThree;

  /// No description provided for @library_title.
  ///
  /// In en, this message translates to:
  /// **'The food menu'**
  String get library_title;

  /// No description provided for @library_hint.
  ///
  /// In en, this message translates to:
  /// **'Pick your plate.'**
  String get library_hint;

  /// No description provided for @library_search.
  ///
  /// In en, this message translates to:
  /// **'Find a food or category'**
  String get library_search;

  /// No description provided for @library_all.
  ///
  /// In en, this message translates to:
  /// **'All dishes'**
  String get library_all;

  /// No description provided for @library_favorites.
  ///
  /// In en, this message translates to:
  /// **'Diner favorites'**
  String get library_favorites;

  /// No description provided for @library_lighter.
  ///
  /// In en, this message translates to:
  /// **'Fresh picks'**
  String get library_lighter;

  /// No description provided for @library_comfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort food'**
  String get library_comfort;

  /// No description provided for @library_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get library_breakfast;

  /// No description provided for @library_sweet.
  ///
  /// In en, this message translates to:
  /// **'Sweet & sips'**
  String get library_sweet;

  /// No description provided for @library_categories.
  ///
  /// In en, this message translates to:
  /// **'Any dish'**
  String get library_categories;

  /// No description provided for @library_empty.
  ///
  /// In en, this message translates to:
  /// **'Off-menu? The court allows it.'**
  String get library_empty;

  /// No description provided for @library_genericHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a broad category below, then enter your exact dish and details.'**
  String get library_genericHint;

  /// No description provided for @library_choose.
  ///
  /// In en, this message translates to:
  /// **'Choose an illustration'**
  String get library_choose;

  /// No description provided for @library_change.
  ///
  /// In en, this message translates to:
  /// **'Change illustration'**
  String get library_change;

  /// No description provided for @library_artNote.
  ///
  /// In en, this message translates to:
  /// **'Artwork sets the scene. Your name, notes and own photo tell the real story.'**
  String get library_artNote;

  /// No description provided for @library_photoFirst.
  ///
  /// In en, this message translates to:
  /// **'Your photo gets the spotlight. The illustration stays as a backup.'**
  String get library_photoFirst;

  /// No description provided for @library_categoryBadge.
  ///
  /// In en, this message translates to:
  /// **'Add your dish name'**
  String get library_categoryBadge;

  /// No description provided for @lucky_title.
  ///
  /// In en, this message translates to:
  /// **'Lucky Court'**
  String get lucky_title;

  /// No description provided for @lucky_chooseTitle.
  ///
  /// In en, this message translates to:
  /// **'A little wisdom.\nOr a little luck.'**
  String get lucky_chooseTitle;

  /// No description provided for @lucky_chooseHint.
  ///
  /// In en, this message translates to:
  /// **'Your case is ready. How should the court decide?'**
  String get lucky_chooseHint;

  /// No description provided for @lucky_continue.
  ///
  /// In en, this message translates to:
  /// **'Choose how to decide'**
  String get lucky_continue;

  /// No description provided for @lucky_ai.
  ///
  /// In en, this message translates to:
  /// **'Smart rulings'**
  String get lucky_ai;

  /// No description provided for @lucky_aiHint.
  ///
  /// In en, this message translates to:
  /// **'Judge Bite weighs your goal, details and photos. A verdict with a reason.'**
  String get lucky_aiHint;

  /// No description provided for @lucky_aiButton.
  ///
  /// In en, this message translates to:
  /// **'Let the judge deliberate'**
  String get lucky_aiButton;

  /// No description provided for @lucky_freeTitle.
  ///
  /// In en, this message translates to:
  /// **'LET LUCK COOK'**
  String get lucky_freeTitle;

  /// No description provided for @lucky_freeHint.
  ///
  /// In en, this message translates to:
  /// **'Unlimited fun. Always on the house.'**
  String get lucky_freeHint;

  /// No description provided for @lucky_wheel.
  ///
  /// In en, this message translates to:
  /// **'Spin the plate'**
  String get lucky_wheel;

  /// No description provided for @lucky_wheelHint.
  ///
  /// In en, this message translates to:
  /// **'A dinner-sized wheel of destiny.'**
  String get lucky_wheelHint;

  /// No description provided for @lucky_ticket.
  ///
  /// In en, this message translates to:
  /// **'Draw a ticket'**
  String get lucky_ticket;

  /// No description provided for @lucky_ticketHint.
  ///
  /// In en, this message translates to:
  /// **'One order. Straight from the box.'**
  String get lucky_ticketHint;

  /// No description provided for @lucky_cloche.
  ///
  /// In en, this message translates to:
  /// **'Lift the lid'**
  String get lucky_cloche;

  /// No description provided for @lucky_clocheHint.
  ///
  /// In en, this message translates to:
  /// **'A little suspense. A grand reveal.'**
  String get lucky_clocheHint;

  /// No description provided for @lucky_coin.
  ///
  /// In en, this message translates to:
  /// **'Flip the coin'**
  String get lucky_coin;

  /// No description provided for @lucky_coinHint.
  ///
  /// In en, this message translates to:
  /// **'Two contenders. One final flip.'**
  String get lucky_coinHint;

  /// No description provided for @lucky_coinNeedsTwo.
  ///
  /// In en, this message translates to:
  /// **'Needs exactly 2 options. Edit your case to use the coin.'**
  String get lucky_coinNeedsTwo;

  /// No description provided for @lucky_editCase.
  ///
  /// In en, this message translates to:
  /// **'Edit this case'**
  String get lucky_editCase;

  /// No description provided for @lucky_start.
  ///
  /// In en, this message translates to:
  /// **'Let luck decide'**
  String get lucky_start;

  /// No description provided for @lucky_equalOdds.
  ///
  /// In en, this message translates to:
  /// **'A fair draw. A delicious destiny.'**
  String get lucky_equalOdds;

  /// No description provided for @lucky_goalNote.
  ///
  /// In en, this message translates to:
  /// **'Lucky Court gives every dish an equal chance. Want the judge to weigh your details? Choose a Smart ruling.'**
  String get lucky_goalNote;

  /// No description provided for @lucky_ready.
  ///
  /// In en, this message translates to:
  /// **'Court is in session.'**
  String get lucky_ready;

  /// No description provided for @lucky_drawing.
  ///
  /// In en, this message translates to:
  /// **'No objections. Just suspense.'**
  String get lucky_drawing;

  /// No description provided for @lucky_skip.
  ///
  /// In en, this message translates to:
  /// **'Reveal now'**
  String get lucky_skip;

  /// No description provided for @lucky_cancel.
  ///
  /// In en, this message translates to:
  /// **'Back to methods'**
  String get lucky_cancel;

  /// No description provided for @lucky_winner.
  ///
  /// In en, this message translates to:
  /// **'IT IS!'**
  String get lucky_winner;

  /// No description provided for @lucky_closed.
  ///
  /// In en, this message translates to:
  /// **'CASE CLOSED'**
  String get lucky_closed;

  /// No description provided for @lucky_quoteLabel.
  ///
  /// In en, this message translates to:
  /// **'A WORD FROM THE JUDGE'**
  String get lucky_quoteLabel;

  /// No description provided for @lucky_save.
  ///
  /// In en, this message translates to:
  /// **'Keep this verdict'**
  String get lucky_save;

  /// No description provided for @lucky_saved.
  ///
  /// In en, this message translates to:
  /// **'Filed in your case book'**
  String get lucky_saved;

  /// No description provided for @lucky_reroll.
  ///
  /// In en, this message translates to:
  /// **'Another draw'**
  String get lucky_reroll;

  /// No description provided for @lucky_otherMethod.
  ///
  /// In en, this message translates to:
  /// **'Try another method'**
  String get lucky_otherMethod;

  /// No description provided for @lucky_replay.
  ///
  /// In en, this message translates to:
  /// **'Replay the reveal'**
  String get lucky_replay;

  /// No description provided for @lucky_rerollNote.
  ///
  /// In en, this message translates to:
  /// **'Every new draw has the same odds. The same dish can win again.'**
  String get lucky_rerollNote;

  /// No description provided for @lucky_caseDetails.
  ///
  /// In en, this message translates to:
  /// **'THE ORIGINAL CASE'**
  String get lucky_caseDetails;

  /// No description provided for @lucky_sameJudge.
  ///
  /// In en, this message translates to:
  /// **'Same judge.\nNew tricks.'**
  String get lucky_sameJudge;

  /// No description provided for @lucky_exhausted.
  ///
  /// In en, this message translates to:
  /// **'You’ve enjoyed your 3 welcome Smart rulings. Keep the fun going with unlimited Lucky Court, or get Plus for more deliberation.'**
  String get lucky_exhausted;

  /// No description provided for @lucky_aiError.
  ///
  /// In en, this message translates to:
  /// **'The judge needs a moment. Your ruling is still yours to use. Try again or take a chance in Lucky Court.'**
  String get lucky_aiError;

  /// No description provided for @lucky_saveError.
  ///
  /// In en, this message translates to:
  /// **'The court could not file this verdict. Your result is still here. Try saving again.'**
  String get lucky_saveError;

  /// No description provided for @lucky_drawError.
  ///
  /// In en, this message translates to:
  /// **'The draw could not start. Your case is safe. Try again.'**
  String get lucky_drawError;

  /// No description provided for @lucky_lastAi.
  ///
  /// In en, this message translates to:
  /// **'One last welcome ruling. Make it delicious.'**
  String get lucky_lastAi;

  /// No description provided for @lucky_aiLabel.
  ///
  /// In en, this message translates to:
  /// **'Smart ruling'**
  String get lucky_aiLabel;

  /// No description provided for @lucky_randomLabel.
  ///
  /// In en, this message translates to:
  /// **'Lucky verdict'**
  String get lucky_randomLabel;

  /// No description provided for @lucky_newCase.
  ///
  /// In en, this message translates to:
  /// **'Start another case'**
  String get lucky_newCase;

  /// No description provided for @plus_title.
  ///
  /// In en, this message translates to:
  /// **'A seat at the judge’s table.'**
  String get plus_title;

  /// No description provided for @plus_hint.
  ///
  /// In en, this message translates to:
  /// **'FoodJury Plus'**
  String get plus_hint;

  /// No description provided for @plus_unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Smart rulings'**
  String get plus_unlimited;

  /// No description provided for @plus_details.
  ///
  /// In en, this message translates to:
  /// **'Give your cravings a clever judge. Thoughtful verdicts based on your goal, dish details and photos, with reasons worth hearing. Four judge personalities. Every Lucky Court ritual.'**
  String get plus_details;

  /// No description provided for @plus_year.
  ///
  /// In en, this message translates to:
  /// **'\$24.99 / year'**
  String get plus_year;

  /// No description provided for @plus_month.
  ///
  /// In en, this message translates to:
  /// **'\$5.99 / month'**
  String get plus_month;

  /// No description provided for @plus_value.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get plus_value;

  /// No description provided for @plus_preview.
  ///
  /// In en, this message translates to:
  /// **'Subscription preview'**
  String get plus_preview;

  /// No description provided for @plus_notConnected.
  ///
  /// In en, this message translates to:
  /// **'Purchases are not available yet. These are the planned prices. No payment will be taken.'**
  String get plus_notConnected;

  /// No description provided for @plus_continueFree.
  ///
  /// In en, this message translates to:
  /// **'Keep cooking for free'**
  String get plus_continueFree;

  /// No description provided for @plus_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore Plus'**
  String get plus_explore;

  /// No description provided for @lucky_remaining.
  ///
  /// In en, this message translates to:
  /// **'{count} of 3 welcome Smart rulings left'**
  String lucky_remaining(int count);

  /// No description provided for @lucky_heads.
  ///
  /// In en, this message translates to:
  /// **'Heads'**
  String get lucky_heads;

  /// No description provided for @lucky_tails.
  ///
  /// In en, this message translates to:
  /// **'Tails'**
  String get lucky_tails;

  /// No description provided for @lucky_orderUp.
  ///
  /// In en, this message translates to:
  /// **'ORDER UP!'**
  String get lucky_orderUp;

  /// No description provided for @lucky_useLast.
  ///
  /// In en, this message translates to:
  /// **'Use my Smart ruling'**
  String get lucky_useLast;

  /// No description provided for @lucky_useFree.
  ///
  /// In en, this message translates to:
  /// **'Let luck decide instead'**
  String get lucky_useFree;

  /// No description provided for @lucky_lastConfirm.
  ///
  /// In en, this message translates to:
  /// **'This is your last welcome Smart ruling. Lucky Court is always on the house. Plus keeps the judge deliberating, without limits.'**
  String get lucky_lastConfirm;

  /// No description provided for @lucky_stageHint.
  ///
  /// In en, this message translates to:
  /// **'Every contender gets an equal chance.'**
  String get lucky_stageHint;
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
