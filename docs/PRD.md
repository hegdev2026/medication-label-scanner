# MedScan — Product Requirements (for clinical review)

This document describes what MedScan is meant to do, in non-technical terms, so
a doctor or pharmacist can review it and tell us what is wrong, missing or
risky. Status: **draft v1, awaiting clinical feedback.**

## 1. The problem

People keep many medicine strips, bottles and boxes at home, often for
different family members. Common difficulties:

- Printed labels are small and hard to read (name, strength, expiry date).
- Nobody remembers which medicines are in the house or when they expire.
- Expired medicines get kept and used by mistake.
- Older family members may find it hard to type or read small print.

## 2. Who it is for

| Person | Need |
| --- | --- |
| Patient or family caregiver | Keep a simple list of medicines at home and be warned before they expire. |
| Older adult or low-vision user | Avoid typing; read the label by camera and see it in large, clear text. |
| Hindi-speaking user | Use the whole app in Hindi. |

It is **not** meant for use by clinicians to make treatment decisions.

## 3. What the app does (and does not do)

**It does:**

1. Take a photo of the medicine package (or pick one from the gallery, or type
   the details by hand).
2. Read the printed text from the photo, on the phone itself.
3. Show what it read and **ask the user to check and correct it** before
   anything is saved.
4. Save a personal list: name, strength (e.g. 500 mg), form (tablet, syrup,
   injection…), batch number, manufacturer, manufacturing and expiry dates, and
   the photo.
5. Group medicines by how close the **printed** expiry date is: already
   expired, within 30, 60 or 90 days, or no date found.
6. Send a reminder on the phone before the expiry date.

**It deliberately does not:**

- Tell the user what a medicine is for, or how much to take.
- Check interactions, allergies or duplicates in therapy.
- Suggest alternatives or generics.
- Say that a medicine is "safe" or "OK to use". An unexpired date is not a
  statement of safety.
- Guess. If a name or date cannot be read clearly, the field is left for the
  user to fill in, and unclear values are flagged.

## 4. A typical use

1. The user opens the app and taps **Scan medicine**.
2. They photograph the front of the strip or box.
3. A review screen shows the name, strength, form, batch and dates found. Any
   doubtful item carries a warning, for example *"The expiry date has a
   two-digit year. Please confirm it."*
4. The user corrects anything wrong and saves.
5. The medicine appears in **Inventory** and in the **Expiry** tracker, and a
   reminder is scheduled.

## 5. Safeguards built in

| Risk | How the app handles it |
| --- | --- |
| The camera misreads a name or date | Nothing is saved until the user reviews it; every read value can be edited. |
| Ambiguous date (e.g. "08/26") | Flagged for confirmation, never silently assumed. |
| Several possible names or strengths | The user must choose; the app does not pick one. |
| User trusts the app too much | A notice on screen and in the Terms states the app does not identify medicines or confirm safety. |
| Missed reminder | The Terms say reminders are a convenience only and may arrive late or not at all. |
| Privacy of health information | Photos and records stay on the phone. No account, no server, no cloud AI. |

## 6. How we will judge success

- Most labels are read well enough that the user only needs to correct one or
  two fields.
- Users can find "what is expiring soon?" in under 10 seconds.
- No screen, message or reminder ever implies that a medicine is safe.
- A first-time user, including an older adult, can save a medicine without help.

## 7. Not in this version

Dose schedules and "take your tablet" reminders, interaction or allergy
checks, barcode or pharmacy lookup, sharing a list with a doctor, multiple
family profiles, cloud backup, and AI analysis of the photo.

## 8. Questions for the doctor

Please mark each as **agree / change / remove** and add notes.

1. **Scope.** Is "inventory and expiry tracking only" a sensible and safe scope
   for a first version?
2. **Fields.** Which label details matter most? Are any missing (for example
   storage conditions, prescription-only marking, active ingredient)?
3. **Expiry wording.** Is the grouping (expired / 30 / 60 / 90 days) useful? What
   should happen after opening a bottle, syrup or eye drops, where the useful
   life is shorter than the printed date?
4. **Warnings.** Is the wording of the safety notice clear and strong enough? Is
   there anything it should say about not using expired medicine, or about
   asking a pharmacist?
5. **Look-alike names.** Many brands have similar names. Is "the user confirms
   the name" enough, or should we add anything?
6. **Dose and schedule.** Should a later version include dose reminders, or does
   that carry too much clinical risk without professional input?
7. **Medicines that should not be kept.** Should the app flag certain items
   (for example antibiotics left over, controlled drugs, or items needing cold
   storage)?
8. **Language.** The Hindi text has not been reviewed by a native speaker.
   Which other languages would your patients need?
9. **Anything that would make you uncomfortable recommending this to a
   patient.**

## 9. Disclaimers

MedScan is an information-keeping tool, not a medical device. The Terms of
Service and Privacy Policy in the app are a default draft and are to be reviewed
by a lawyer before any public release.
