import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int _remainingTimeInSeconds = 300;
  bool _isResendingOtp = false;
  String _errorMessage = '';

  Timer? _timer;

  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _stopCountdown();
    super.dispose();
  }

  Future<void> _verifyOtp(String otp) async {
    setState(() {
      _errorMessage = '';
    });

    final url = Uri.parse('https://prod-api.hustleshub.com/user/verifyotp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: {'otp': otp},
    );

    if (response.statusCode == 200) {
      // OTP verification successful, navigate to next screen
      _errorMessage = 'verified';
      Navigator.pushReplacementNamed(context, '/nextScreen');
    } else {
      setState(() {
        _errorMessage = 'Invalid OTP, please try again';
      });
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResendingOtp = true;
      _errorMessage = '';
    });

    final url = Uri.parse('https://prod-api.hustleshub.com/user/resendotp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: {},
    );

    setState(() {
      _isResendingOtp = false;
    });

    if (response.statusCode == 200) {
      // OTP resend successful, start countdown again
      _remainingTimeInSeconds = 300;
      _startCountdown();
    } else {
      setState(() {
        _errorMessage = 'Failed to resend OTP, please try again';
      });
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTimeInSeconds == 0) {
        _stopCountdown();
      } else {
        setState(() {
          _remainingTimeInSeconds--;
        });
      }
    });
  }

  void _stopCountdown() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Resend OTP in $_remainingTimeInSeconds seconds',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isResendingOtp ? null : _resendOtp,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isResendingOtp
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
                  : Text(
                'Resend OTP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _verifyOtp(_otpController.text);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}