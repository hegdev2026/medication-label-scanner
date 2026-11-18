# Ads setup (Google AdMob)

The app shows ads from Google AdMob. Formats and where they appear:

| Format | Where | Notes |
|---|---|---|
| Banner | Home tab, bottom | Adaptive width |
| Native | Search results, below the notes | In the app's colours, labelled "Advertisement" |
| Interstitial | After adding a medicine | Only every 3rd add and at least 4 min apart; never after an edit |
| Rewarded | Settings → Ads | Watching a video hides ads for 24 hours |

There are no ads on the scanner, the review/edit form, the consent dialog or
the medicine details screen, and ads never use saved medicines. App Open ads
are deliberately not used (they cover the screen the moment the app opens,
including expiry-reminder taps).

## Test vs real ads

Debug and profile builds always use Google's TEST units.
A release build uses the real units from `env.json` and shows no ad for a
format whose unit is empty. Create the app and four ad units in the AdMob
console (https://admob.google.com), then fill in `env.json`:

```json
{
  "ADMOB_APP_ID": "ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX",
  "ADMOB_BANNER_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
  "ADMOB_NATIVE_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
  "ADMOB_INTERSTITIAL_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
  "ADMOB_REWARDED_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
}
```

`ADMOB_APP_ID` (with `~`) goes into the Android manifest through Gradle; the
four unit ids (with `/`) are read by the app. `make run/apk/aab` hand all of
them over. In CI, also export `ADMOB_APP_ID` as an environment variable. The
iOS app id is in `ios/Runner/Info.plist` (currently Google's test id).

## Before publishing

- Never tap your own live ads; use test devices while developing.
- Consent: the app asks through Google's User Messaging Platform where the law
  requires it (set up the message under AdMob → Privacy & messaging). Settings
  shows "Ad privacy choices" when a user is entitled to change it.
- In AdMob, block sensitive ad categories you do not want next to a health app
  (Blocking controls → Sensitive categories).
- Play Console: declare ads in the content declaration; in Data safety declare
  the Advertising ID and the device/usage data AdMob collects (Google's AdMob
  page lists them); keep the privacy policy URL current. The in-app Privacy
  text already describes ads.
- Do not target the app at children, or use a different ad setup if you do.
