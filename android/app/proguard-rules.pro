# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keepattributes Signature
-keepattributes *Annotation*

# General Flutter
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Needed for go_router or other reflection-heavy libraries (just in case)
-keep class com.yourpackagename.** { *; }
