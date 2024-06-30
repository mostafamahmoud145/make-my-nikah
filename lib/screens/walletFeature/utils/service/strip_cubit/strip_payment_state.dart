part of 'strip_payment_cubit.dart';

@immutable
sealed class StripPaymentState {}

final class StripPaymentInitial extends StripPaymentState {}
final class StripPaymentUpdate extends StripPaymentState {}
