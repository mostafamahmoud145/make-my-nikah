import 'dart:developer';

extension CustomPrinter on String {
  /// Custom print with an emoji for info messages.
  void printInfo() {
    print('ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ $this  ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️');
  }

  /// Custom print with an emoji for warning messages.
  void printWarning() {
    print('⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️  $this  ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️');
  }

  /// Custom print with an emoji for error messages.
  void printError() {
    print('🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨 $this 🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨');
  }

  void logPrint() {
    log(this);
  }
}
