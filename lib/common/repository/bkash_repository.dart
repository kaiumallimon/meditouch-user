import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:meditouch/common/utils/bkash_error_codes.dart';

import '../models/bkash_create_payment_response.dart';
import '../models/bkash_execute_payment.dart';
import '../models/bkash_grant_token.dart';

class BkashRepository {
// Grant token
  final username = dotenv.env["BKASH_USERNAME"] ?? "sandbox_test";
  final password = dotenv.env["BKASH_PASSWORD"] ?? "11111111";
  final appKey = dotenv.env["BKASH_APP_KEY"] ?? "";
  final appSecret = dotenv.env["BKASH_APP_SECRET"] ?? "";
  Future<GrantTokenResponse> grantToken() async {
    print("grant token credentials: $username, $password, $appKey, $appSecret");
    final response = await http.post(
      Uri.parse(
          "https://tokenized.pay.bka.sh/v1.2.0-beta/tokenized/checkout/token/grant"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "username": username,
        "password": password,
      },
      body: utf8.encode(
        jsonEncode(
          {
            "app_key": appKey,
            "app_secret": appSecret,
          },
        ),
      ),
    );

    if (response.statusCode == 200 ) {
      log("grant token: ${response.body}");
      return GrantTokenResponse.fromJson(response.body);
    } else {
      print("grant token: ${response.body}");
      return GrantTokenResponse(
        statusCode: response.statusCode.toString(),
        statusMessage:
            bkashErrorCodes[response.statusCode] ?? "Something went wrong",
        idToken: "idToken",
        tokenType: "tokenType",
        expiresIn: 123,
        refreshToken: "refreshToken",
      );
    }
  }

// Create payment
  Future<CreatePaymentResponse> createPayment({
    required String idToken,
    required String amount,
    required String invoiceNumber,
  }) async {
    final response = await http.post(
      Uri.parse(
          "https://tokenized.pay.bka.sh/v1.2.0-beta/tokenized/checkout/create"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": idToken,
        "X-App-Key": appKey,
      },
      body: utf8.encode(
        jsonEncode(
          {
            "mode": "0011",
            "payerReference": "nothing",
            "callbackURL": "https://paymentcallback.netlify.app/",
            "amount": amount,
            "currency": "BDT",
            "intent": "sale",
            "merchantInvoiceNumber": invoiceNumber
          },
        ),
      ),
    );

    if (response.statusCode == 200) {
      print("create payment: ${response.body}");
      return CreatePaymentResponse.fromJson(response.body);
    } else {
      return CreatePaymentResponse(
        paymentID: "paymentID",
        paymentCreateTime: "paymentCreateTime",
        transactionStatus: "transactionStatus",
        amount: "amount",
        currency: "currency",
        intent: "intent",
        merchantInvoiceNumber: "merchantInvoiceNumber",
        bkashURL: "bkashURL",
        callbackURL: "callbackURL",
        successCallbackURL: "successCallbackURL",
        failureCallbackURL: "failureCallbackURL",
        cancelledCallbackURL: "cancelledCallbackURL",
        statusCode: response.statusCode.toString(),
        statusMessage:
            bkashErrorCodes[response.statusCode] ?? "Something went wrong",
      );
    }
  }

// Execute payment
  Future<ExecutePaymentResponse> executePaymentresponse({
    required String idToken,
    required String paymentID,
  }) async {
    final response = await http.post(
      Uri.parse(
          'https://tokenized.pay.bka.sh/v1.2.0-beta/tokenized/checkout/execute'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": idToken,
        "X-App-Key": appKey,
      },
      body: utf8.encode(
        jsonEncode(
          {'paymentID': paymentID},
        ),
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ExecutePaymentResponse(
        paymentID: data['paymentID'],
        customerMsisdn: data['customerMsisdn'],
        payerReference: data['payerReference'],
        paymentExecuteTime: data['paymentExecuteTime'],
        trxID: data['trxID'],
        transactionStatus: data['transactionStatus'],
        amount: data['amount'],
        currency: data['currency'],
        intent: data['intent'],
        merchantInvoiceNumber: data['merchantInvoiceNumber'],
        statusCode: data['statusCode'],
        statusMessage: data['statusMessage'],
      );
    } else {
      return ExecutePaymentResponse(
        paymentID: "paymentID",
        customerMsisdn: "customerMsisdn",
        payerReference: "payerReference",
        paymentExecuteTime: "paymentExecuteTime",
        trxID: "trxID",
        transactionStatus: "transactionStatus",
        amount: "amount",
        currency: "currency",
        intent: "intent",
        merchantInvoiceNumber: "merchantInvoiceNumber",
        statusCode: response.statusCode.toString(),
        statusMessage:
            bkashErrorCodes[response.statusCode] ?? "Something went wrong",
      );
    }
  }
}
