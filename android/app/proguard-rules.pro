# ML Kit text recognition lists optional script modules (Chinese, Devanagari,
# Japanese, Korean) that this app does not bundle: it reads Latin text only.
# Without these rules R8 aborts the release build on the missing classes.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
