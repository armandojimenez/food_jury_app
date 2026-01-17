// Localization Usage Guide
//
// This file demonstrates common patterns for using localized strings
// throughout the FoodJury app.

import 'package:flutter/material.dart';

import '../utils/l10n_extensions.dart';

/// Example 1: Simple text widget
class LocalizedTextExample extends StatelessWidget {
  const LocalizedTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.appTitle);
  }
}

/// Example 2: Button with localized label
class LocalizedButtonExample extends StatelessWidget {
  const LocalizedButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(context.l10n.common_ok),
    );
  }
}

/// Example 3: Time-based greeting
class LocalizedGreetingExample extends StatelessWidget {
  const LocalizedGreetingExample({super.key});

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return context.l10n.greeting_morning;
    } else if (hour < 17) {
      return context.l10n.greeting_afternoon;
    } else if (hour < 21) {
      return context.l10n.greeting_evening;
    } else {
      return context.l10n.greeting_night;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_getGreeting(context));
  }
}

/// Example 4: Snackbar with localized message
void showLocalizedSnackbar(BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(context.l10n.snackbar_decisionSaved)));
}

/// Example 5: Dialog with localized content
Future<bool?> showLocalizedDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.l10n.option_deleteConfirmTitle),
      content: Text(context.l10n.option_deleteConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.common_no),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.l10n.common_yes),
        ),
      ],
    ),
  );
}

/// Example 6: Form with localized labels and hints
class LocalizedFormExample extends StatelessWidget {
  const LocalizedFormExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: context.l10n.option_nameLabel,
            hintText: context.l10n.option_nameHint,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: context.l10n.option_notesLabel,
            hintText: context.l10n.option_notesHint,
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}

/// Example 7: List of objectives with localized labels
class LocalizedObjectivesList extends StatelessWidget {
  const LocalizedObjectivesList({super.key});

  @override
  Widget build(BuildContext context) {
    final objectives = [
      context.l10n.objective_fun,
      context.l10n.objective_healthy,
      context.l10n.objective_fit,
      context.l10n.objective_quick,
    ];

    return ListView.builder(
      itemCount: objectives.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(objectives[index]));
      },
    );
  }
}

/// Example 8: Error state with localized message
class LocalizedErrorExample extends StatelessWidget {
  const LocalizedErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.error_noInternet,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(context.l10n.error_noInternetMessage),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          child: Text(context.l10n.error_tryAgain),
        ),
      ],
    );
  }
}

/// Example 9: Loading states with different messages
class LocalizedLoadingExample extends StatelessWidget {
  const LocalizedLoadingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      context.l10n.loading_courtInSession,
      context.l10n.loading_examiningEvidence,
      context.l10n.loading_deliberating,
      context.l10n.loading_almostThere,
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            messages.first,
          ), // Rotate through messages in real implementation
        ],
      ),
    );
  }
}

/// Example 10: Accessing current locale
class LocaleInfoExample extends StatelessWidget {
  const LocaleInfoExample({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isSpanish = locale.languageCode == 'es';

    return Text(
      isSpanish ? 'Idioma actual: Español' : 'Current language: English',
    );
  }
}
