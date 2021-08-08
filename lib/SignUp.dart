import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staggered_layout/ResponsiveConstraints.dart';
import 'package:staggered_layout/VerifyOTP.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool eye = true;
  Color color = Colors.black45;
  FirebaseAuth auth = FirebaseAuth.instance;
  late String codeSent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(Responsive.height(2, context)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  },
                      icon: Icon(Icons.arrow_back_ios_rounded)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Responsive.height(4, context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign Up!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: Responsive.height(6, context),
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400)
                        ),
                      ],
                    ),
                    // Image(
                    //   image: AssetImage('Assets/refer.png'),
                    //   height: Responsive.height(20, context),
                    //   width: Responsive.width(20, context),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(Responsive.height(3, context), 0,
                    Responsive.height(3, context), Responsive.height(3, context)),
                child: TextField(
                  style: TextStyle(
                      fontSize: Responsive.height(2.0, context),
                      color: Colors.black),
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  textAlign: TextAlign.left,
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                      hintStyle:
                      TextStyle(fontSize: Responsive.height(2.0, context)),
                      prefixIcon: Icon(
                        CupertinoIcons.person,
                        color: Colors.black,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(Responsive.height(3, context), 0,
                    Responsive.height(3, context), Responsive.height(3, context)),
                child: TextField(
                  style: TextStyle(
                      fontSize: Responsive.height(2.0, context),
                      color: Colors.black),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  textAlign: TextAlign.left,
                  controller: phoneController,
                  decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                      hintText: 'Phone Number',
                      hintStyle:
                      TextStyle(fontSize: Responsive.height(2.0, context)),
                      prefixIcon: Icon(
                        CupertinoIcons.device_phone_portrait,
                        color: Colors.black,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(Responsive.height(3, context), 0,
                    Responsive.height(3, context), 0),
                child: TextField(
                  style: TextStyle(
                      fontSize: Responsive.height(2.0, context),
                      color: Colors.black),
                  cursorColor: Colors.blue,
                  obscureText: eye,
                  textAlign: TextAlign.left,
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      hintStyle:
                      TextStyle(fontSize: Responsive.height(2.0, context)),
                      prefixIcon: Icon(
                        CupertinoIcons.lock_fill,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(CupertinoIcons.eye_fill),
                        color: color,
                        onPressed: () {
                          setState(() {
                            if (color == Colors.black) {
                              color = Colors.black45;
                            } else {
                              color = Colors.black;
                            }
                            if (eye == true) {
                              eye = false;
                            } else {
                              eye = true;
                            }
                          });
                        },
                      )),
                ),
              ),
              SizedBox(height: Responsive.height(5, context),),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(Responsive.height(4, context)),
                          ))),
                  onPressed: () async {
                    if(nameController.text.toString().length<2){
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              content: Text('Invalid name'),
                            );
                          }
                      );
                    } else if(phoneController.text.toString().length<10){
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              content: Text('Invalid Phone Number'),
                            );
                          }
                      );
                    } else if(passwordController.text.toString().length<6){
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              content: Text('Password too short'),
                            );
                          }
                      );
                    } else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPVerify(name: nameController.text.toString(), phoneNumber: phoneController.text.toString(),password: passwordController.text.toString())));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Responsive.height(1.5, context),
                        horizontal: Responsive.height(2.5, context)),
                    child: Text('Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.height(2.5, context),
                            fontWeight: FontWeight.w400)),
                  )),
              Padding(
                padding: EdgeInsets.all(Responsive.height(3, context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: Responsive.height(2, context),
                          fontWeight: FontWeight.w300),
                    ),
                    TextButton(
                        onPressed: () {
                         Navigator.pop(context);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: Responsive.height(2, context),
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
