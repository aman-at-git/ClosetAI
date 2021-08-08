import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:staggered_layout/Questioner.dart';

import 'ResponsiveConstraints.dart';

class OTPVerify extends StatefulWidget {
  final String name, phoneNumber, password;

  OTPVerify(
      {Key? key,
      required this.name,
      required this.phoneNumber,
      required this.password
      })
      : super(key: key);

  @override
  _OTPVerifyState createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  int seconds = 60;
  String enteredOTP = '';
  String sentCode = '';

  int _start = 60;
  bool resendVisible = false;

  void startTimer() {
    _start = 60;
    resendVisible = false;
    const oneSec = const Duration(seconds: 1);
    Timer _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            resendVisible = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    String phoneNo = widget.phoneNumber;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(Responsive.height(2, context)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded)),
                ),
              ),
              SizedBox(
                height: Responsive.height(2, context),
              ),
              Text(
                'Enter OTP',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.height(3, context)),
              ),
              SizedBox(
                height: Responsive.height(2, context),
              ),
              Text(
                'We have sent you an SMS on +91 $phoneNo\nwith 6 digit verification code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.height(1.5, context),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                height: Responsive.height(5, context),
              ),
              PinEntryTextField(
                fields: 6,
                showFieldAsBox: true,
                onSubmit: (String pin) {
                  enteredOTP = pin;
                },
              ),
              SizedBox(
                height: Responsive.height(5, context),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () {
                    _verifyCode(enteredOTP);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Responsive.height(1.2, context),
                        horizontal: Responsive.height(3, context)),
                    child: Text('Verify',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.height(2.2, context))),
                  )),
              SizedBox(
                height: Responsive.height(3, context),
              ),
              Container(
                height: Responsive.height(0.08, context),
                color: Colors.grey,
              ),
              SizedBox(
                height: Responsive.height(3, context),
              ),
              Text(
                "Did not receive the code?",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: Responsive.height(0.5, context),
              ),
              Text(
                'Wait for $_start seconds',
                style: TextStyle(color: Colors.grey),
              ),
              Visibility(
                  visible: resendVisible,
                  child: Center(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              _verifyPhone();
                              startTimer();
                            });
                          },
                          child: Text('Resend OTP',
                              style: TextStyle(color: Colors.blueAccent)))))
            ],
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    print('sending');
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91" + widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              navigate(widget.name, widget.phoneNumber, widget.password);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          sentCode = verificationID;
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  _verifyCode(String pin) async {
    try {
      showLoaderDialog(context);
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: sentCode, smsCode: pin))
          .then((value) async {
        if (value.user != null) {
          navigate(widget.name, widget.phoneNumber, widget.password);
        }
      });
    } catch (e) {
      Navigator.pop(context);
      FocusScope.of(context).unfocus();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Wrong Code, Please try again!'),
            );
          });
    }
  }

  void navigate(name, phoneNumber, password) async {
    FirebaseFirestore.instance.collection('userCred').doc().set(
        {'phoneNumber': phoneNumber, 'password': password}).whenComplete(() {
      FirebaseFirestore.instance
          .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .set({
        'fullName': name,
        'phone': phoneNumber
      }).whenComplete((){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Questionnaire()));
      });
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: Responsive.height(5, context)),
              child: Text("Verifying OTP")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
