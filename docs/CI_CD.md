# CI/CD: build and release MedScan to Google Play

Android only. GitHub Actions builds and tests the app, and fastlane uploads it to
Google Play. This document covers everything: what the pipeline does, every
one-time setup step, daily use, and fixes for the errors you are most likely to meet.

- [1. How it works](#1-how-it-works)
- [2. What is in the repo](#2-what-is-in-the-repo)
- [3. One-time setup](#3-one-time-setup)
- [4. Your first release](#4-your-first-release)
- [5. Everyday use](#5-everyday-use)
- [6. Versions, obfuscation and crash traces](#6-versions-obfuscation-and-crash-traces)
- [7. Security and housekeeping](#7-security-and-housekeeping)
- [8. Troubleshooting](#8-troubleshooting)
- [9. Setup checklist](#9-setup-checklist)
- [Appendix: the privacy policy page](#appendix-the-privacy-policy-page)

---

## 1. How it works

```
main ──► staging ──► qa ──► prod
          │           │       │
          │           │       └─ promotes the tested release: Play internal ► Play production
          │           └───────── builds an AAB ► Google Play internal testing
          └───────────────────── builds an APK ► a file you download from GitHub
```

Code moves along the line by **merging**: `main → staging → qa → prod`. Each branch
has its own workflow, so the Actions page for a run shows **only that branch's
steps**, with no skipped jobs from the other branches.

| You push or merge to | The run shows | Where it ends up |
|---|---|---|
| `staging` | **Checks**, then **Build staging APK** | the run's **Artifacts** on GitHub, kept 30 days |
| `qa` | **Checks**, then **Build AAB and upload to Play internal testing** | Google Play **internal testing** |
| `prod` | **Checks**, then **Promote internal release to Play production** | Google Play **production** |
| a pull request into any of these | **Checks** only | nothing |
| any other branch (your feature branches) | nothing runs | nothing |

Things that are easy to get wrong:

- **Production is a promotion, not a rebuild.** Users get the exact file your
  testers already ran. So a push to `prod` only works after a `qa` push has uploaded
  a build.
- **Staging APKs use Google's sample ads.** They go to phones outside Play, and
  testers tapping real ads can get your AdMob account banned for invalid traffic.
  The `qa` and `prod` builds use your real ad units.
- **The checks come first.** If format, analyze or test fails, nothing builds and
  nothing is uploaded.
- **Merging and pushing are the same thing.** A merge into a branch is a push to it.

## 2. What is in the repo

| File | What it does |
|---|---|
| `.github/workflows/checks.yml` | The quality gates (format, analyze, test). Runs on pull requests, and the three workflows below call it first. |
| `.github/workflows/staging.yml` | On a push to `staging`: checks, then the signed APK. Nothing to do with Google Play. |
| `.github/workflows/qa.yml` | On a push to `qa`: checks, then the AAB, uploaded to Play internal testing. |
| `.github/workflows/prod.yml` | On a push to `prod`: checks, then promotes the internal release to production. |
| `.github/actions/setup/action.yml` | Shared step: Java 17, the pinned Flutter, `flutter pub get`. The Flutter version is set here, once. |
| `.github/actions/prepare-build/action.yml` | Shared step: writes `env.json` from a secret, decodes the keystore and writes `android/key.properties`. It checks every part, so a typo fails early with a clear message. |
| `android/fastlane/Fastfile` | The Play lanes: `validate`, `internal` (upload) and `promote` (internal to production). |
| `android/fastlane/Appfile` | The package name (`com.hegdev.medscan`) and the key path. |
| `android/Gemfile`, `android/Gemfile.lock` | fastlane and its pinned versions. |
| `Makefile` | `make apk` and `make aab` build locally, obfuscated by default. |
| `docs/CI_CD.md` | This document. |

Settings you can change:

| Setting | Where | Meaning |
|---|---|---|
| Flutter version | `flutter-version` default in `.github/actions/setup/action.yml` | The Flutter used in CI for every workflow. Keep it equal to `flutter --version` on your machine. |
| `VERSION_CODE_BASE` | `qa.yml` | The build number sent to Play is this plus the run number of the `qa` workflow. Raise it, never lower it. |
| `RELEASE_NOTES` | `qa.yml` | The "What's new" text on Play. One fixed sentence, 500 characters at most. |

## 3. One-time setup

Do these in order. Each step says where the value comes from.

### 3.1 Create the upload key

Google Play signs the app that users download. You sign the file you upload with an
**upload key**, so Google knows the upload really came from you.

```bash
keytool -genkeypair -keystore medscan-upload.jks -storetype PKCS12 \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

It asks for a password and some details. The details are not shown to users.

- Keep `medscan-upload.jks` **outside the git repo**, and keep a second copy
  somewhere safe, such as a password manager or an encrypted drive. If you lose the
  key or its password, you need Google's help to reset it.
- Create `android/key.properties` (git-ignored) so local builds sign with it:
  ```
  storeFile=/full/path/to/medscan-upload.jks
  storePassword=...
  keyAlias=upload
  keyPassword=...
  ```
- Check it works: `make aab`, then `jarsigner -verify build/app/outputs/bundle/release/app-release.aab`.
  It should say `jar verified` and show your certificate name, not "Android Debug".

> Without `key.properties`, Gradle quietly signs with the debug key and Play rejects
> the upload. The pipeline guards against this on purpose.

### 3.2 Prepare the secret values

You need six values for GitHub. Prepare them first, in plain text files if it helps,
and delete them afterwards.

| Secret name | Where the value comes from |
|---|---|
| `ENV_JSON` | The **whole contents** of your local `env.json` (OCR key, contact, AdMob ids). |
| `ANDROID_KEYSTORE_BASE64` | The keystore as one line of text: `base64 -w0 medscan-upload.jks > medscan-upload-base64.txt`, then copy that file's contents. |
| `ANDROID_KEYSTORE_PASSWORD` | `storePassword=` in `android/key.properties`. Only the part after `=`. |
| `ANDROID_KEY_ALIAS` | `upload` |
| `ANDROID_KEY_PASSWORD` | `keyPassword=` in `android/key.properties`. Only the part after `=`. |
| `PLAY_STORE_JSON_KEY_DATA` | The Play service account's key file (section 3.3). Paste the raw JSON. |

Never paste these values into chat tools, issues or commits.

### 3.3 Create the Play service account

The service account is a robot login. The pipeline uses its key to upload to Play
while nobody is signed in. Google's rule is simple: Play only accepts uploads from
accounts it has been told about, which is why section 3.4 matters.

1. Open **console.cloud.google.com** and sign in with a Google account.
2. Click the project picker at the top, then **New project**. Name it
   `medscan-publisher`. Leave **Organisation** and **Location** as "No organisation".
   "No organisation" is normal for a personal account. Click **Create**, wait a
   minute, then select the project in the picker. (If it is not listed, open the
   picker's **All** tab and expand "No organisation".)
3. **Enable the API.** Go to **APIs & Services → Library**, search for
   **Google Play Android Developer API**, and click **Enable**. The page should then
   show Status **Enabled**.
4. **Create the account.** Go to **IAM & Admin → Service Accounts → Create service
   account**. Name it `play-publisher`. Click **Create and continue**, skip the role
   step with **Continue**, and click **Done**. No role is needed here.
5. **Create its key.** Open `play-publisher@<project>.iam.gserviceaccount.com`, open
   the **Keys** tab, choose **Add key → Create new key → JSON → Create**. A `.json`
   file downloads. **It can only be downloaded once.**

If key creation is blocked by an "organisation policy" message, you have a Google
Workspace account with a restriction. Use a personal Google account for this
project, or ask the Workspace admin to allow it.

### 3.4 Give the service account permission in Play Console

1. Open **play.google.com/console**. Click the Play Console logo (top left) to leave
   the app view and return to the home page.
2. Open **Manage account → Users and permissions**. (Direct link:
   `play.google.com/console/users-and-permissions`.) You must be the account owner
   or an admin to see it.
3. Click **Invite new users**.
4. **Email address:** the service account's email,
   `play-publisher@medscan-publisher.iam.gserviceaccount.com`. Leave **Access
   expiry** unticked.
5. On the **App permissions** tab, click **Add app**, choose MedScan, and tick
   exactly these four:
   - **View app information (read only)**
   - **Release to production, exclude devices and use Play app signing**
   - **Release apps to testing tracks**
   - **Manage testing tracks and edit tester lists**
6. Click **Apply**, then **Invite user**, and confirm.

You do not accept this invitation. A service account has no inbox, so Play adds it
by itself. The user shows up in the list as **Active**, which can take from a few
minutes up to an hour. Do **not** give it Admin: if the key ever leaked, Admin would
let someone take over the app.

### 3.5 Create the GitHub repository and add the secrets

1. On GitHub, signed in as `hegdev2026`, create a **private**, empty repository named
   `medication-label-scanner`. Do not add a README or licence.
2. Point your local project at it and push `main`:
   ```bash
   git remote set-url origin https://github.com/hegdev2026/medication-label-scanner.git
   git push -u origin main
   ```
   GitHub asks you to sign in. Use a **personal access token** as the password. A
   normal account password does not work for git pushes.
3. In the repo, open **Settings → Secrets and variables → Actions → New repository
   secret**, and add the six secrets from section 3.2, using those exact names.
   The page lists names only. It never shows values again, so re-adding is the only
   way to change one.

### 3.6 Optional variables

**Settings → Secrets and variables → Actions → Variables.** Add these only when needed.

| Variable | When to use it |
|---|---|
| `PLAY_RELEASE_STATUS` = `draft` | For the very first upload, if Play refuses with "only releases with status draft may be created on draft app". Delete it after the app is published. |
| `PLAY_ROLLOUT` = `0.1` | A staged rollout to 10% of users on the `prod` push. Delete it to roll out to everyone. |

### 3.7 Environments and approvals

**Settings → Environments → New environment**. Create two:

- `play-internal`
- `play-production`, then tick **Required reviewers** and add yourself.

Every promotion to production now pauses and waits for your approval in the Actions
tab. It is the last gate before real users, so keep it. (GitHub creates a missing
environment the first time a run uses it, but without any reviewers.)

### 3.8 Create the other branches

The workflow files must exist on a branch before pushing to that branch starts
anything, so `main` goes first (done in 3.5). Then:

```bash
git branch staging && git branch qa && git branch prod
git push -u origin staging qa prod
```

**Creating a branch counts as a push.** `staging`, `qa` and `prod` each start their
own run the moment they appear. They fail until the secrets, the first release and the Play
permissions are in place, which is harmless but noisy. Add the secrets before
pushing the three branches.

### 3.9 Protect the branches

**Settings → Branches → Add branch ruleset** (or **Add rule**), for each of
`staging`, `qa` and `prod`:

- require a **pull request** before merging
- require the status check **Analyze, format, test** to pass

Now merging is the only way code moves forward, and a failing build can never reach
Play.

## 4. Your first release

Google Play's own rules make the very first release awkward, and your account type
adds one more requirement.

### 4.1 First upload

The Play API is most reliable once an app already has a release. Choose one:

- **Try the pipeline directly (quick to test).** Set the variable
  `PLAY_RELEASE_STATUS` to `draft`, then push `qa`. If it uploads, the release
  appears as a draft under **Test and release → Internal testing**. Click through
  Play Console once to roll it out. If it fails, read the error and use the route
  below.
- **Upload the first build by hand (the safe route).** Run `make aab`. In Play
  Console go to **Test and release → Internal testing → Create new release**, upload
  `build/app/outputs/bundle/release/app-release.aab`, and roll it out. Finish the
  store listing and the app content declarations. From then on the pipeline can add
  new versions.

### 4.2 Production needs a closed test (personal accounts)

Play Console shows "Personal account". Google requires a personal developer account
created after November 2023 to run a **closed test with at least 12 testers for 14
days in a row** before it can request **production access**. Until Google approves
that, the `prod` promotion is refused. This is separate from the pipeline.

Plan for it:
1. Create a **Closed testing** track, add at least 12 testers (an email list or a
   Google Group), and let them opt in and install.
2. Keep the test running for 14 days in a row.
3. In the Play Console **Dashboard**, apply for production access.

The `qa` branch keeps feeding internal testing during this time.

## 5. Everyday use

```bash
# 1. test on phones as an APK
git checkout staging && git merge main && git push

# 2. send to Google Play internal testing
git checkout qa && git merge staging && git push

# 3. release to everyone (waits for your approval, then promotes)
git checkout prod && git merge qa && git push
```

You can also do the same on GitHub with a pull request:

1. **Pull requests → New pull request**
2. **base** is where the code goes (for example `qa`), **compare** is where it comes
   from (for example `staging`)
3. **Create pull request**, wait for **Analyze, format, test** to go green, then
   **Merge pull request**

If GitHub says "There isn't anything to compare", the two branches already hold the
same code. Add a commit to the source branch first.

To watch a run, open the **Actions** tab. To get the staging APK, open the finished
run and download it from **Artifacts**.

To change the "What's new" text, edit `RELEASE_NOTES` in `qa.yml`. To roll out
to 10% first, set `PLAY_ROLLOUT` to `0.1` before the `prod` push.

## 6. Versions, obfuscation and crash traces

- **versionName** comes from `pubspec.yaml` (`version: 1.0.0+1`, the part before `+`).
  Change it when you release something users will notice.
- **versionCode** is sent as `VERSION_CODE_BASE + the run number of the qa workflow`.
  Only `qa.yml` uploads builds to Play, so only its counter matters. Play rejects a
  versionCode it has already seen, so raise `VERSION_CODE_BASE` in `qa.yml` if you
  ever upload by hand with a higher number, and never lower it. A re-run of a failed
  job reuses its number, which is fine because a failed upload never used it.
- **Obfuscation** is on for every release build (`--obfuscate`, with the symbol files
  kept). It makes the Dart code hard to read in the app file, but crash traces from
  those builds look scrambled.
- **Symbol files** are uploaded with every build as artifacts, kept for 90 days. To
  read a crash trace, download them, then run:
  ```bash
  flutter symbolize -i trace.txt -d <symbols folder>/app.android-arm64.symbols
  ```
  Keep the symbols of every build you ship.
- Local builds are obfuscated too: `make aab` or `make apk`. For a one-off plain
  build, use `make aab OBFUSCATE=false`.

## 7. Security and housekeeping

- **Never commit** `env.json`, `android/key.properties`, any `.jks` file, the base64
  text file, or the Play service account JSON. They are in `.gitignore`.
- **Back up** the keystore and its passwords outside the repo and outside your
  computer. It is the one thing you cannot recreate.
- **If the Play service account key leaks:** in Google Cloud, open the service
  account, **Keys**, delete the leaked key and create a new one. Then replace the
  `PLAY_STORE_JSON_KEY_DATA` secret. Your own Google account is not affected.
- **The OCR key ships inside the app.** Anyone can extract it from the app file, so
  use a free key you can replace, and rotate it by updating `ENV_JSON`.
- **Delete** the downloaded service account JSON and the base64 text file from your
  computer once the secrets are saved, or move them to a private backup.
- **Staging uses test ads.** Do not change that. Real ad units on a build that testers
  tap can get your AdMob account suspended.

## 8. Troubleshooting

| What you see | Likely cause and fix |
|---|---|
| The workflow does not start | The branch has no workflow files yet. Merge them into `main` first, then create the branches from `main`. Also check the branch name is exactly `staging`, `qa` or `prod`. |
| The run shows only **Checks** | It ran for a pull request or a push to another branch. Only a push or merge to `staging`, `qa` or `prod` builds or uploads. |
| `The ENV_JSON secret is empty` | Add `ENV_JSON` with the whole contents of `env.json`. Secret names are case-sensitive. |
| `env.json is missing [...]` | The JSON in the secret is missing `ADMOB_APP_ID` or `ADMOB_BANNER_ID`. Paste it again from your local file. |
| `The keystore did not open with the given password and alias` | Wrong `ANDROID_KEYSTORE_PASSWORD` or `ANDROID_KEY_ALIAS`, or the base64 text was cut off. Re-encode with `base64 -w0` and paste it again. |
| `ANDROID_KEYSTORE_BASE64 did not decode` | The secret is empty or has stray characters. The decoder ignores spaces and new lines, so check it is the whole text. |
| Format check fails | Run `dart format lib test` and commit the result. |
| Upload fails with **401** or **403** | The service account has no permission yet. Check it is **Active** under **Users and permissions** and has the four permissions. Wait up to an hour after inviting it. |
| `Package not found: com.hegdev.medscan` | The app does not exist in Play Console for this developer account, or the service account is not linked to it. Create the app, then invite the account with access to it. |
| `Only releases with status draft may be created on draft app` | The app is not published yet. Set the variable `PLAY_RELEASE_STATUS` to `draft`, or make the first release by hand. |
| `Version code ... has already been used` | Play has seen that versionCode. Raise `VERSION_CODE_BASE` in `qa.yml`. |
| Release notes error about a language | The release notes are written to `en-GB`. Match it to your store listing's default language by changing `PLAY_LANGUAGE` in the Fastfile. |
| The `prod` run says there is nothing to promote | No release exists on the internal track. Do a `qa` push first. |
| `Google Api Error: Invalid request - Precondition check failed` on `prod` | Play refuses the promotion. Usual causes: production access not granted yet (section 4.2); the app is still a draft, so set the variable `PLAY_RELEASE_STATUS` to `draft`; the internal release is a draft nobody rolled out in Play Console; or Play Console shows unfinished app content tasks. The run's log prints the internal and production versionCodes and these hints. |
| `The internal track has no release to promote` | Nothing has been uploaded to internal testing yet. Push to `qa` first. |
| The app is signed with the debug key | `android/key.properties` is missing in the build. Check the secrets and the **Set up release signing** step. |
| The `prod` run waits forever | It is waiting for your approval. Open the run in **Actions** and click **Review deployments**. |

If a step fails for any other reason, open the failed run in **Actions**, open the
red step, and read the first line that starts with `Error` or `::error::`.

## 9. Setup checklist

| Done | Item |
|---|---|
| ☐ | Upload keystore created and backed up outside the repo |
| ☐ | `android/key.properties` created locally and `make aab` is signed with it |
| ☐ | Google Cloud project `medscan-publisher` created |
| ☐ | Google Play Android Developer API enabled |
| ☐ | Service account `play-publisher` created, JSON key downloaded |
| ☐ | Service account invited in Play Console with the four permissions and **Active** |
| ☐ | GitHub repo created under `hegdev2026` and `main` pushed |
| ☐ | Secret `ENV_JSON` |
| ☐ | Secret `ANDROID_KEYSTORE_BASE64` |
| ☐ | Secret `ANDROID_KEYSTORE_PASSWORD` |
| ☐ | Secret `ANDROID_KEY_ALIAS` |
| ☐ | Secret `ANDROID_KEY_PASSWORD` |
| ☐ | Secret `PLAY_STORE_JSON_KEY_DATA` |
| ☐ | Environments `play-internal` and `play-production` (with required reviewer) |
| ☐ | Branches `staging`, `qa`, `prod` pushed |
| ☐ | Branch protection on `staging`, `qa` and `prod` |
| ☐ | First release uploaded to internal testing |
| ☐ | A `staging` run produced an APK in Artifacts |
| ☐ | A `qa` run uploaded to internal testing |
| ☐ | Closed test (12 testers, 14 days) finished and production access granted |
| ☐ | A `prod` run promoted a release to production |

## Appendix: the privacy policy page

Play needs a public privacy policy URL. It lives in its own small **public**
repository, because GitHub Pages on a private repository needs a paid plan, and
the policy contains nothing secret.

1. Rebuild the page after any policy text change:
   `python3 tool/build_privacy_page.py`. This writes `privacy/index.html` from the
   in-app text, so the page and the app never disagree.
2. Create a **public**, empty repo named `medscan-privacy` under `hegdev2026`.
3. Put `index.html` (and an empty `.nojekyll` file) at the top level of that repo and
   push it.
4. In that repo, **Settings → Pages**, choose **Deploy from a branch**, branch `main`,
   folder `/ (root)`, and save.
5. After a minute or two the page is at `https://hegdev2026.github.io/medscan-privacy/`.
   Open it in a private browser window to confirm it loads without signing in, then
   use that URL in Play Console and in the store listing.
