# CI/CD (GitHub Actions + fastlane, Android only)

```
main ──► staging ──► qa ──► prod
          │           │       │
          │           │       └─ promotes the tested release: Play internal ► Play production
          │           └───────── builds an AAB ► Play internal testing
          └───────────────────── builds an APK ► downloadable build artifact
```

You move code along the line by merging (pull request or `git merge`). A push to
any other branch builds nothing. Pull requests into any of the four branches run
the quality gates only.

| Branch | What a push does | Where it lands |
|---|---|---|
| `staging` | analyze, format, test, then a signed obfuscated **APK** | the run's **Artifacts** (kept 30 days) |
| `qa` | the same gates, then a signed obfuscated **AAB** | Google Play **internal testing** |
| `prod` | the same gates, then **promotes** the internal release | Google Play **production** |

The workflow is [`.github/workflows/android.yml`](../.github/workflows/android.yml).
The shared steps are in `.github/actions/`, the Play upload is in
[`android/fastlane/Fastfile`](../android/fastlane/Fastfile).

Things worth knowing:

- **Production is a promotion, not a rebuild.** Users get the exact binary your
  testers ran on internal testing. So a push to `prod` only works after a `qa`
  push has uploaded something.
- **Staging APKs use Google's sample ads.** They go to phones outside Play, so
  testers can tap ads without creating invalid traffic on your AdMob account. The
  `qa` and `prod` builds use your real ad units.
- **Every build is obfuscated.** The symbol files are uploaded as artifacts (90
  days). You need them to read a crash trace:
  `flutter symbolize -i trace.txt -d <symbols dir>/app.android-arm64.symbols`.
- **versionCode** is `100 + the workflow run number`. Play never accepts a
  versionCode it has already seen, so raise `VERSION_CODE_BASE` in the workflow
  and never lower it.

## One-time setup

### 1. Repository secrets

GitHub → repo → **Settings → Secrets and variables → Actions → New repository secret**.

| Secret | Value |
|---|---|
| `ENV_JSON` | the whole contents of your local `env.json` |
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 "<path to>/medscan-upload.jks"` (one line, no spaces) |
| `ANDROID_KEYSTORE_PASSWORD` | the `storePassword` from `android/key.properties` |
| `ANDROID_KEY_ALIAS` | `upload` |
| `ANDROID_KEY_PASSWORD` | the `keyPassword` from `android/key.properties` |
| `PLAY_STORE_JSON_KEY_DATA` | the whole contents of the Play service account `.json` (step 2) |

The upload keystore is the one thing you cannot recreate. Keep a copy outside the
repo and outside this machine.

### 2. Play service account

1. Google Cloud Console → pick or create a project → **IAM & Admin → Service
   Accounts → Create**. Name it `play-publisher`. No roles are needed.
2. Open it → **Keys → Add key → JSON**. Save the file somewhere private. This is
   `PLAY_STORE_JSON_KEY_DATA`.
3. Enable the **Google Play Android Developer API** for that same project.
4. Play Console → **Users and permissions → Invite new users**. Use the service
   account's email, and give it **Release to production, exclude devices, and use
   Play App Signing**, **Release apps to testing tracks** and **Manage testing
   tracks and edit tester lists** for MedScan. Permissions can take up to an hour.

### 3. The first release is manual

Play's API cannot publish an app's very first release. Do this once:

1. In Play Console create a release on **Internal testing**, upload an AAB
   (`make aab`) and finish the store listing and app content declarations.
2. For the first pipeline run, set the repository **variable**
   `PLAY_RELEASE_STATUS` to `draft` (**Settings → Secrets and variables →
   Actions → Variables**) if Play complains that "only releases with status draft
   may be created on draft app". Delete the variable once the app has been
   published once.

The release notes folder is `en-GB`, which is your store listing's default
language. If the Play Console rejects it, change `PLAY_LANGUAGE` in the Fastfile.

### 4. Environments (the approval gates)

**Settings → Environments → New environment**, twice:

- `play-internal`
- `play-production` → tick **Required reviewers** and add yourself. Every
  promotion to production then waits for your click.

### 5. Create the branches, and protect them

The workflow file has to exist on a branch before pushing to it does anything, so
merge it into `main` first:

```bash
git checkout main && git merge <your-branch> && git push origin main
git checkout -b staging && git push -u origin staging
git checkout -b qa      && git push -u origin qa
git checkout -b prod    && git push -u origin prod
```

Then **Settings → Branches → Add rule** for `staging`, `qa` and `prod`: require a
pull request and require the **Analyze, format, test** check to pass. That makes
merging the only way code moves along, and a red build can never reach Play.

## Everyday use

```bash
# ship to testers as an APK
git checkout staging && git merge main && git push

# ship to Play internal testing
git checkout qa && git merge staging && git push

# release to everyone (waits for your approval, then promotes)
git checkout prod && git merge qa && git push
```

For a staged rollout, set the repository variable `PLAY_ROLLOUT` to `0.1` (10%)
before the `prod` push, and clear it to roll out fully.

To change the "What's new" text, edit `RELEASE_NOTES` at the top of the workflow
(500 characters at most).

## Checking it locally

```bash
make aab                                   # signed, obfuscated bundle
cd android && bundle install
SUPPLY_JSON_KEY=fastlane/play-service-account.json \
  bundle exec fastlane android validate    # checks the Play key, uploads nothing
```
