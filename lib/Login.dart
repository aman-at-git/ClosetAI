import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staggered_layout/BottomNav.dart';
import 'package:staggered_layout/ResponsiveConstraints.dart';
import 'package:staggered_layout/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:staggered_layout/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// checkAuth(){
//   FirebaseAuth.instance
//       .authStateChanges()
//       .listen((User? user) {
//     if (user == null) {
//       print('User is currently signed out!');
//     } else {
//       print('User is signed in!');
//     }
//   });
// }

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String password = '';

  bool eye = true;
  Color color = Colors.black45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: Responsive.width(100, context),
                  child: Image(
                    image: AssetImage('assets/login_back.png'),
                  ),
                ),
                Positioned(
                  bottom: Responsive.height(8, context),
                  left: Responsive.width(10, context),
                  child: Text('Welcome\nBack',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.height(4.5, context),
                          decoration: TextDecoration.none,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w800)
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Responsive.width(10, context),
                  Responsive.height(5, context),
                  Responsive.width(10, context),
                  Responsive.height(3, context)),
              child: TextField(
                style: TextStyle(
                    fontSize: Responsive.height(2.0, context),
                    color: Colors.black
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                textAlign: TextAlign.left,
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                    counterText: '',
                    hintText: 'Enter Phone Number',
                    hintStyle:
                    TextStyle(fontSize: Responsive.height(2.0, context)),
                    prefixIcon: Icon(
                      CupertinoIcons.device_phone_portrait,
                      color: Colors.black,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Responsive.height(6, context), 0,
                  Responsive.height(6, context), 0),
              child: TextField(
                style: TextStyle(
                    fontSize: Responsive.height(2.0, context),
                    color: Colors.black),
                cursorColor: Colors.blue,
                obscureText: eye,
                textAlign: TextAlign.left,
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: 'Enter Password',
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
            // Padding(
            //   padding: EdgeInsets.all(Responsive.height(2, context)),
            //   child: TextButton(
            //       onPressed: () {
            //         //sendOTP('+91', '9811130906');
            //       },
            //       child: Text(
            //         'Forgot Password?',
            //         style: TextStyle(
            //             color: Colors.blueAccent,
            //             fontSize: Responsive.height(2, context),
            //             fontWeight: FontWeight.w300),
            //       )),
            // ),

            Padding(
                padding: EdgeInsets.fromLTRB(
                    Responsive.width(10, context),
                    Responsive.height(5, context),
                    Responsive.width(10, context),
                    Responsive.height(3, context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sign in',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: Responsive.height(4, context),
                          decoration: TextDecoration.none,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w800)
                  ),
                  RawMaterialButton(
                    onPressed:
                      () async {
                        if(phoneController.text.toString().length<10){
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  content: Text('Invalid Phone Number'),
                                );
                              }
                          );
                        }
                        else{
                          FirebaseFirestore.instance.collection('userCred')
                              .where('phoneNumber', isEqualTo: phoneController.text.toString())
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              setState(() {
                                password = doc['password'];
                              });
                            });
                          }).whenComplete((){
                            if(password==''){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      content: Text('Number not registered. Please Register!'),
                                    );
                                  }
                              );
                            }
                            else if(password == passwordController.text.toString()){
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                  BottomNav()), (Route<dynamic> route) => false);
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    content: Text('Incorrect password'),
                                  );
                                }
                              );
                            }
                          });
                        }
                    },
                    elevation: 10.0,
                    fillColor: SecondaryColor,
                    child: Icon(
                      Icons.arrow_right_alt,
                      size: 60.0,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(20.0),
                    shape: CircleBorder(),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Responsive.width(10, context),
                  Responsive.height(5, context),
                  Responsive.width(10, context),
                  Responsive.height(3, context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                      //_verifyCode(passwordController.text);
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontSize: Responsive.height(2.5, context),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                      onPressed: (){},
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontSize: Responsive.height(2.5, context),
                            fontWeight: FontWeight.w500),
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
