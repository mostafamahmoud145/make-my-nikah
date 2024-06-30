part of 'pay_course_cubit.dart';

@immutable
sealed class PayCourseCubitState {}

final class PayCourseCubitInitial extends PayCourseCubitState {}
final class PayCourseCubitUpdate extends PayCourseCubitState {}
