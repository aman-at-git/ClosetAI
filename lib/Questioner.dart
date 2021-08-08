import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'BottomNav.dart';
import 'ResponsiveConstraints.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

List<String> apparelLink = [];
List<bool> selected = [];
int count = 0;

String article = '', category = '', style = '';

class _QuestionnaireState extends State<Questionnaire> {
  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Column(children: [
          Padding(
            padding: EdgeInsets.all(Responsive.height(2, context)),
            child: Text(
              'Select at least 5',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.height(3, context)),
            ),
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: apparelLink.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 4
                      : 3,
              mainAxisExtent: Responsive.height(20, context),
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: (1.05 / 1),
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected[index])
                      count--;
                    else
                      count++;
                    selected[index] = !selected[index];
                  });
                },
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.width(2, context),
                        vertical: Responsive.height(1, context)),
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: selected[index] ? 0.8 : 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              height: Responsive.height(20, context),
                              width: Responsive.height(20, context),
                              fit: BoxFit.cover,
                              image: NetworkImage(apparelLink[index]),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            child: Opacity(
                              opacity: selected[index] ? 1 : 0,
                              child: CircleAvatar(
                                  radius: Responsive.height(2, context),
                                  child: Icon(
                                    Icons.check,
                                    size: Responsive.height(2.5, context),
                                  )),
                            ))
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ]),
        Positioned(
          bottom: Responsive.height(5, context),
          right: 0,
          left: 0,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Responsive.width(37, context)),
            child: SizedBox(
              height: Responsive.height(7, context),
              child: FloatingActionButton.extended(
                onPressed: count < 5 ? null :
                    (){
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(Responsive.height(4, context)),
                                  child: CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: Responsive.height(2, context)),
                                  child: Text("Please wait while we arrange everything"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      for(int i=0; i<selected.length; i++){
                        if(selected[i]){
                          FirebaseFirestore.instance
                              .collection('SignupImages')
                              .where('url', isEqualTo: apparelLink[i])
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              article = doc['article'];
                              category = doc['category'];
                              style = doc['style'];
                              print(article+  category +  style);
                            });
                          }).whenComplete((){
                            FirebaseFirestore.instance
                                .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString()).collection('homepage').doc()
                                .set({
                              'article': article,
                              'style': style,
                              'category': category
                            });
                          }).whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              BottomNav()), (Route<dynamic> route) => false),
                          );
                        }
                      }
                },
                backgroundColor:
                    count < 5 ? Colors.grey : Colors.deepPurpleAccent,
                label: Text(
                  'Save',
                  style: TextStyle(
                      fontSize: Responsive.height(3, context,),
                    fontWeight: FontWeight.w400,
                    color: Colors.white
                  ),
                )
              ),
            ),
          ),
        )
      ],
    )));
  }

  void loadImages() {
    FirebaseFirestore.instance
        .collection('SignupImages')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          apparelLink.add(doc['url']);
          selected.add(false);
        });
      });
    });
  }
}
