part of 'girl_appointment_cubit.dart';

@immutable
sealed class GirlAppointmentState {}

final class GirlAppointmentInitial extends GirlAppointmentState {}
final class GirlAppointmentUpdate extends GirlAppointmentState {}

