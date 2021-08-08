import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staggered_layout/DetailedCollection.dart';
import 'package:staggered_layout/Login.dart';
import 'package:staggered_layout/ResponsiveConstraints.dart';
import 'package:staggered_layout/main.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  @override
  void initState() {
    super.initState();
    loadCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100)),
                child: Container(
                  height: 250,
                  color: PrimaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                                child: Container()
                            ),
                            // IconButton(
                            //   onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios)),
                            Expanded(
                              flex:2,
                              child: Center(
                                child: Text(
                                  'Mina Davis',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        LoginScreen()), (Route<dynamic> route) => false);
                                  }, icon: 
                                Icon(Icons.logout, size: Responsive.height(4, context),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          height: 120,
                            width: 120,
                            child: Image(
                              fit: BoxFit.cover,
                          image: AssetImage('assets/user_profile.jpeg'),
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text('10 followers   25 following',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18
                        ),),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: collectionList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:2,
                  mainAxisExtent: Responsive.height(25, context),
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: (1.05 / 1),
                ),
                //shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AlbumInfoScreen(album:allAlbumList[index].title, albumArt:  allAlbumList[index].albumArt, albumId: allAlbumList[index].id,)));
                  },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailedCollection(collectionName: collectionList[index])));
                              setState(() {
                                print('${collectionList[index]}');
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: Responsive.height(20, context),
                                width: Responsive.height(20, context),
                                color: Color(0xF000000),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: Responsive.height(10, context),
                                          width: Responsive.height(10, context),
                                          child: collectionUrl[index*4]=='null'
                                              ?Icon(Icons.image)
                                              :Image.network(collectionUrl[index*4],fit: BoxFit.cover,)
                                        ),
                                        Container(
                                          height: Responsive.height(10, context),
                                          width: Responsive.height(10, context),
                                            child: collectionUrl[index*4+1]=='null'
                                                ?Icon(Icons.image)
                                                :Image.network(collectionUrl[index*4+1],fit: BoxFit.cover,
                                            )
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: Responsive.height(10, context),
                                          width: Responsive.height(10, context),
                                            child: collectionUrl[index*4+2]=='null'
                                                ?Icon(Icons.image)
                                                :Image.network(collectionUrl[index*4+2],fit: BoxFit.cover,)
                                        ),
                                        Container(
                                          height: Responsive.height(10, context),
                                          width: Responsive.height(10, context),
                                            child: collectionUrl[index*4+3]=='null'
                                                ?Icon(Icons.image)
                                                :Image.network(collectionUrl[index*4+3],fit: BoxFit.cover,)
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('${collectionList[index]}'),
                          )
                        ],
                      )
                    )
                  );
                },


                // children: List.generate(10, (index) {
                //   return Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //     child: Column(
                //       children: [
                //         ClipRRect(
                //           borderRadius: BorderRadius.circular(20),
                //           child: Container(
                //             height: Responsive.height(20, context),
                //             width: Responsive.height(20, context),
                //             color: Colors.red,
                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     Container(
                //                       height: Responsive.height(10, context),
                //                       width: Responsive.height(10, context),
                //                       child: Image(
                //                         image: AssetImage('assets/user_profile.jpeg'),
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                     Container(
                //                       height: Responsive.height(10, context),
                //                       width: Responsive.height(10, context),
                //                       child: Image(
                //                         image: AssetImage('assets/user_profile.jpeg'),
                //                         fit: BoxFit.cover,
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //                 Row(
                //                   children: [
                //                     Container(
                //                       height: Responsive.height(10, context),
                //                       width: Responsive.height(10, context),
                //                       child: Image(
                //                         image: AssetImage('assets/user_profile.jpeg'),
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                     Container(
                //                       height: Responsive.height(10, context),
                //                       width: Responsive.height(10, context),
                //                       child: Image(
                //                         image: AssetImage('assets/user_profile.jpeg'),
                //                         fit: BoxFit.cover,
                //                       ),
                //                     )
                //                   ],
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(10.0),
                //           child: Text('$index'),
                //         )
                //       ],
                //     )
                //   );
                // }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadCollection() {
    collectionList.clear();
    collectionUrl.clear();
    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('collections').get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          collectionList.add(doc['collectionName']);
          collectionUrl.add(doc['recentUrl1']);
          collectionUrl.add(doc['recentUrl2']);
          collectionUrl.add(doc['recentUrl3']);
          collectionUrl.add(doc['recentUrl4']);
        });
      });
    });
  }

}
