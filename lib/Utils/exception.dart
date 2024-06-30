import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class CustomException implements Exception {
  String exceptionMsg;
  CustomException(this.exceptionMsg);
}

class FirebaseErrorModel extends Equatable {
  const FirebaseErrorModel();

  static String getErrorMessage(Object error) {
    if (error is FirebaseException) {
      // Log the error if in debug mode
      if (kDebugMode) {
        print(error);
      }

      // Check the error code and return an appropriate message
      switch (error.code) {
        case 'permission-denied':
          return 'You don\'t have permission to access this resource.';
        case 'network-request-failed':
          return 'Check your internet connection and try again.';
        case 'unavailable':
          return 'The service is currently unavailable. Please try again later.';
        // Add more cases for different error codes as needed
        default:
          return 'An unexpected error occurred. Please try again.';
      }
    } else {
      // If the error is not a FirebaseException
      if (kDebugMode) {
        print(error);
      }
      return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  List<Object?> get props => [];
}
