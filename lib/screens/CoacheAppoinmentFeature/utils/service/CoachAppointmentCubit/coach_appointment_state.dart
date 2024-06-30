part of 'coach_appointment_cubit.dart';

@immutable
sealed class CoachAppointmentState {}

final class CoachAppointmentInitial extends CoachAppointmentState {}
final class CoachAppointmentUpdate extends CoachAppointmentState {}
