abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String message;

  PaymentSuccess(this.message);
}

class PaymentFailure extends PaymentState {
  final String errorMessage;

  PaymentFailure(this.errorMessage);
}

class PaymentTokenGranted extends PaymentState {
  final String grantToken;

  PaymentTokenGranted(this.grantToken);
}

class PaymentCreated extends PaymentState {
  final String paymentId;
  final String grantToken;
  final String paymentUrl;

  PaymentCreated(this.paymentId, this.grantToken, this.paymentUrl);
}
