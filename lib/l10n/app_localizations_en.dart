// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FoodJury';

  @override
  String get appTagline => 'Order in the kitchen!';

  @override
  String get common_ok => 'OK';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_save => 'Save';

  @override
  String get common_yes => 'Yes';

  @override
  String get common_no => 'No';

  @override
  String get common_back => 'Back';

  @override
  String get common_close => 'Close';

  @override
  String get greeting_morning => 'Good morning, hungry one!';

  @override
  String get greeting_afternoon => 'Good afternoon, hungry one!';

  @override
  String get greeting_evening => 'Good evening, hungry one!';

  @override
  String get greeting_night => 'Good night, hungry one!';

  @override
  String get home_newDecision => 'New Decision';

  @override
  String get home_recentVerdicts => 'Recent Verdicts';

  @override
  String get home_emptyTitle => 'No verdicts yet...';

  @override
  String get home_emptyMessage => 'The court is empty! Time to bring a case.';

  @override
  String get home_emptyAction => 'Start Your First Case';

  @override
  String get decision_screenTitle => 'What\'s the dilemma?';

  @override
  String get decision_yourOptions => 'YOUR OPTIONS';

  @override
  String get decision_addOption => 'Add Option';

  @override
  String get decision_tapToAdd => 'Tap to add';

  @override
  String get decision_whatsYourGoal => 'WHAT\'S YOUR GOAL?';

  @override
  String get decision_letJudgeDecide => 'Let the Judge Decide';

  @override
  String get decision_minOptionsError => 'Add at least 2 options to proceed';

  @override
  String get option_add => 'ADD OPTION';

  @override
  String get option_tapToAddPhoto => 'Tap to add photo';

  @override
  String get option_nameLabel => 'Name';

  @override
  String get option_nameHint => 'What is it?';

  @override
  String get option_notesLabel => 'Notes (optional)';

  @override
  String get option_notesHint => 'Any details the judge should know?';

  @override
  String get option_addToCase => 'Add to Case';

  @override
  String get option_deleteConfirmTitle => 'Delete Option?';

  @override
  String get option_deleteConfirmMessage =>
      'This will remove the option from your case.';

  @override
  String get objective_fun => 'Fun';

  @override
  String get objective_healthy => 'Healthy';

  @override
  String get objective_fit => 'Fit';

  @override
  String get objective_quick => 'Quick';

  @override
  String get loading_courtInSession => 'The court is in session...';

  @override
  String get loading_examiningEvidence => 'Examining the evidence...';

  @override
  String get loading_deliberating => 'Deliberating...';

  @override
  String get loading_almostThere => 'Almost there...';

  @override
  String get verdict_theVerdictIsIn => 'THE VERDICT IS IN';

  @override
  String get verdict_winner => 'WINNER';

  @override
  String get verdict_judgesNotes => 'Judge\'s Notes';

  @override
  String get verdict_seeAllRankings => 'See all rankings';

  @override
  String get verdict_hideRankings => 'Hide rankings';

  @override
  String get verdict_newDecision => 'New Decision';

  @override
  String get verdict_newCase => 'New Case';

  @override
  String get verdict_share => 'Share';

  @override
  String get history_screenTitle => 'Past Verdicts';

  @override
  String get history_emptyTitle => 'The court records are empty...';

  @override
  String get history_emptyMessage => 'No cases have been decided yet!';

  @override
  String get history_today => 'Today';

  @override
  String get history_yesterday => 'Yesterday';

  @override
  String get history_thisWeek => 'This Week';

  @override
  String get history_deleteConfirmTitle => 'Delete Decision?';

  @override
  String get history_deleteConfirmMessage => 'This cannot be undone.';

  @override
  String get settings_screenTitle => 'Settings';

  @override
  String get settings_judgePersonality => 'JUDGE\'S PERSONALITY';

  @override
  String get settings_appearance => 'APPEARANCE';

  @override
  String get settings_subscription => 'SUBSCRIPTION';

  @override
  String get settings_about => 'About';

  @override
  String get settings_privacy => 'Privacy';

  @override
  String get settings_terms => 'Terms';

  @override
  String get tone_stern => 'Stern & Fair';

  @override
  String get tone_sternPreview => 'The court finds...';

  @override
  String get tone_sassy => 'Sassy';

  @override
  String get tone_sassyPreview => 'Listen, I\'ve seen...';

  @override
  String get tone_enthusiastic => 'Enthusiastic';

  @override
  String get tone_enthusiasticPreview => 'OH WOW! This is...';

  @override
  String get tone_chill => 'Chill';

  @override
  String get tone_chillPreview => 'So like, here\'s...';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_dark => 'Dark';

  @override
  String get theme_system => 'Auto';

  @override
  String get subscription_pro => 'FoodJury Pro';

  @override
  String get subscription_unlimitedDecisions => 'Unlimited decisions';

  @override
  String get subscription_upgradeNow => 'Upgrade Now';

  @override
  String get error_noInternet => 'The court is offline...';

  @override
  String get error_noInternetMessage => 'Wake me when we\'re back online!';

  @override
  String get error_tryAgain => 'Try Again';

  @override
  String get error_genericTitle => 'Oops!';

  @override
  String get error_genericMessage => 'Something went wrong. Please try again.';

  @override
  String get onboarding_skip => 'Skip';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_getStarted => 'Get Started';

  @override
  String get onboarding_welcome_title => 'Meet Judge Bite';

  @override
  String get onboarding_welcome_message =>
      'Your personal food court judge who helps you make delicious decisions!';

  @override
  String get onboarding_howItWorks_title => 'How It Works';

  @override
  String get onboarding_howItWorks_message =>
      'Add your food options, set your goal, and let the judge deliver the verdict!';

  @override
  String get onboarding_personality_title => 'Pick Your Style';

  @override
  String get onboarding_personality_message =>
      'Choose how Judge Bite should deliver verdicts. You can change this anytime!';

  @override
  String get snackbar_decisionSaved => 'Decision recorded!';

  @override
  String get snackbar_optionAdded => 'Option added to the case';

  @override
  String get snackbar_optionDeleted => 'Option removed';

  @override
  String get snackbar_decisionDeleted => 'Decision deleted';
}
