# ProGuard rules for Stripe push provisioning and to avoid R8 missing class errors
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**

# Add any additional keep rules from missing_rules.txt below

