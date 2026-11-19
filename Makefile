# Release builds are obfuscated; the symbols (needed to read crash traces) land in
# build/symbols/<apk|aab>. `make aab OBFUSCATE=false` for a one-off plain build.
OBFUSCATE ?= true
BUILD_NUMBER ?=
obf = $(if $(filter true,$(OBFUSCATE)),--obfuscate --split-debug-info=build/symbols/$(1),)
build_number = $(if $(BUILD_NUMBER),--build-number=$(BUILD_NUMBER),)

.PHONY: gen watch test analyze env run apk aab

# Build-time values (OCR key, contact, AdMob ids) live in env.json, which is not
# committed. `make env` creates it from env.example.json; CI creates it from
# secrets. Empty values are fine: the matching features simply stay off.
DEFINES = --dart-define-from-file=env.json

# The AdMob *app* id is read by Gradle (the manifest), not by Dart, so it is
# handed over as an environment variable. Empty means Google's test id.
ADMOB_APP_ID_VALUE = $(shell python3 -c "import json;print(json.load(open('env.json')).get('ADMOB_APP_ID',''))")

gen:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

test:
	flutter test

analyze:
	flutter analyze

env:
	@test -f env.json || cp env.example.json env.json
	@echo "Fill in env.json (OCR_SPACE_KEY, APP_CONTACT, ADMOB_*). It is git-ignored."

run: env
	ADMOB_APP_ID="$(ADMOB_APP_ID_VALUE)" flutter run $(DEFINES)

apk: env
	ADMOB_APP_ID="$(ADMOB_APP_ID_VALUE)" flutter build apk --release $(DEFINES) $(call obf,apk) $(build_number)

aab: env
	ADMOB_APP_ID="$(ADMOB_APP_ID_VALUE)" flutter build appbundle --release $(DEFINES) $(call obf,aab) $(build_number)
