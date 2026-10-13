# Firebase App Distribution

FoodJury can use Firebase App Distribution as a delivery service, following
Beautifully's signed-artifact workflow. This does not require a Firebase SDK or
Firebase initialization in the app. AI requests continue through the gateway.

## Verified configuration — October 13, 2026

The existing Firebase CLI session can list the `food-jury` project's apps. The
remote app IDs match the repository's `firebase.json`:

| Platform | Firebase app ID | Package / bundle ID |
| --- | --- | --- |
| Android | `1:922509466321:android:2e54c4e1b4f669ac6a43f0` | `dev.armandojimenez.food_jury` |
| iOS | `1:922509466321:ios:130e4568e1574a426a43f0` | `dev.armandojimenez.foodJury` |

Delivery was skipped under the owner's instruction to skip if authentication,
CLI access, signing, or another prerequisite blocks it. These checks found:

- `firebase appdistribution:groups:list --project food-jury --json` failed with
  “Failed to list groups.” This does not establish whether the project has no
  groups, App Distribution is disabled, or access is unavailable.
- Android's release configuration still selects the debug signing key. No
  FoodJury upload-key configuration was found in `android/`,
  `~/.config/foodjury/`, or `~/.config/food-jury/`.
- The local code-signing identity inventory contains an Apple Development
  identity only, with no valid Apple Distribution identity. No FoodJury delivery
  configuration or export-options file was found in those local config folders.

No login flow, tester-group creation, signing-key generation, provisioning setup,
or distribution upload was performed. Debug-signed Android builds and iOS
simulator builds are local verification artifacts, not the signed delivery used
by Beautifully.

## When delivery is resumed

Use the same verified commit for both platforms, a new increasing build number,
FoodJury's own Android release key, and an iOS ad-hoc profile covering the intended
devices with a valid Apple Distribution identity. Confirm the intended tester
group exists and is accessible. Keep keystores, credentials, provisioning and
export configuration outside Git; do not reuse another app's credentials.

Choose one environment for the delivery and use its matching entrypoint and
ignored define file for both native builds:

| Environment | Entrypoint | Dart defines |
| --- | --- | --- |
| Development | `lib/main_dev.dart` | `config/dev.local.json` |
| Production | `lib/main_prod.dart` | `config/prod.local.json` |

Pass `-t <entrypoint> --dart-define-from-file=<define-file>` to the signed Flutter
build commands. See [gateway configuration](../gateway/README.md) for generating
the private define files. Do not distribute `main_preview.dart`: it uses simulated
AI and isolated in-memory data. Production routing does not make the unfinished
Plus billing preview a purchasable entitlement.

Before uploading, verify each signed artifact's package ID, version/build,
signing identity and iOS provisioning profile. Record its SHA-256, source commit
and environment alongside release notes. Beautifully's workflow prepares and
checks both files before sending either, then reads back each Firebase release
and records its build, commit and install link.

The distribution CLI accepts the existing FoodJury app IDs once those
prerequisites are satisfied. For example, with `FOODJURY_TESTER_GROUP` set to the
verified target group and release notes already written:

```sh
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app 1:922509466321:android:2e54c4e1b4f669ac6a43f0 \
  --project food-jury --groups "$FOODJURY_TESTER_GROUP" \
  --release-notes-file build/distribution/release-notes.txt

# Set FOODJURY_IPA to the exact validated, signed IPA path.
firebase appdistribution:distribute "$FOODJURY_IPA" \
  --app 1:922509466321:ios:130e4568e1574a426a43f0 \
  --project food-jury --groups "$FOODJURY_TESTER_GROUP" \
  --release-notes-file build/distribution/release-notes.txt
```

These commands upload binaries and notify the selected tester group. They have
not been run for this delivery. Confirm the resulting releases in Firebase before
claiming delivery; successful local builds alone are not upload evidence. Keep
authentication output and temporary signed download URLs out of committed
verification records.
