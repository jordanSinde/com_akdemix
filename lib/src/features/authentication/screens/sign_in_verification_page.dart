// ignore_for_file: unnecessary_null_comparison

import 'package:com_akdemix/src/common_widgets/error_text.dart';
import 'package:com_akdemix/src/features/authentication/global_provider.dart';
import 'package:com_akdemix/src/features/authentication/route/app_router.dart';
import 'package:com_akdemix/src/features/authentication/screens/sign_in_verification_model.dart';
import 'package:com_akdemix/src/features/authentication/state/sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pinput/pinput.dart';

final signInVerificationModelProvider =
    StateNotifierProvider.autoDispose<SignInVerificationModel, SignInState>(
        (ref) {
  final authService = ref.watch(authServiceProvider);
  return SignInVerificationModel(
    authService: authService,
  );
});

final countdownProvider = StreamProvider.autoDispose<int>((ref) {
  final signInVerificationModel =
      ref.watch(signInVerificationModelProvider.notifier);
  return signInVerificationModel.countdown.stream;
});

class SignInVerificationPageBuilder extends ConsumerWidget {
  const SignInVerificationPageBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignInState>(signInVerificationModelProvider, (_, state) {
      if (state == const SignInState.success()) {
        Navigator.popUntil(
          context,
          ModalRoute.withName(AppRoutes.startupPage),
        );
      }
    });

    final state = ref.watch(signInVerificationModelProvider);
    final countdown = ref.watch(countdownProvider);
    final model = ref.read(signInVerificationModelProvider.notifier);

    return SignInVerificationPage(
      phoneNumber: model.formattedPhoneNumber,
      resendCode: () => model.resendCode(),
      verifyCode: (String smsCode) => model.verifyCode(smsCode),
      delayBeforeNewCode: (countdown.value ?? delayBeforeUserCanRequestNewCode),
      canSubmit: state.maybeWhen(
        canSubmit: () => true,
        orElse: () => false,
      ),
      isLoading: state.maybeWhen(
        loading: () => true,
        orElse: () => false,
      ),
      errorText: state.maybeWhen(
        error: (error) => error,
        orElse: () => "",
      ),
    );
  }
}

class SignInVerificationPage extends StatefulWidget {
  const SignInVerificationPage({
    super.key,
    required this.phoneNumber,
    this.canSubmit = false,
    this.isLoading = false,
    required this.errorText,
    required this.delayBeforeNewCode,
    required this.resendCode,
    required this.verifyCode,
  });

  final String phoneNumber;
  final bool canSubmit;
  final bool isLoading;
  final int delayBeforeNewCode;
  final String errorText;
  final Function() resendCode;
  final Function(String smsCode) verifyCode;

  @override
  State<StatefulWidget> createState() => _SignInVerificationPageState();
}

class _SignInVerificationPageState extends State<SignInVerificationPage> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      textStyle: const TextStyle(fontSize: 40),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(5),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Verification code",
        ),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(children: [
            const SizedBox(height: 20),
            Text(
              "Please enter the verfication code we sent to ${widget.phoneNumber}:",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(30.0),
              child: Pinput(
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                length: 6,
                onTap: () {
                  controller.text = "";
                },
                onSubmitted: widget.verifyCode,
                focusNode: focusNode,
                controller: controller,
                pinAnimationType: PinAnimationType.none,
                pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                validator: (s) {
                  if (widget.errorText == null && s!.length == 6) {
                    widget.verifyCode(s);
                  }
                  return null;
                },
              ),
            ),
            TextButton(
              onPressed:
                  widget.delayBeforeNewCode > 0 ? null : widget.resendCode,
              child: Text(
                widget.delayBeforeNewCode > 0
                    ? "If you did not receive the SMS, you will be able to request a new one in ${widget.delayBeforeNewCode.toString()} seconds"
                    : "Resend to ${widget.phoneNumber}",
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.errorText != null) ErrorText(message: widget.errorText),
          ]),
        ),
      ),
    );
  }
}
