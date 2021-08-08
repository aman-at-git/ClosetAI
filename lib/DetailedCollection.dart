import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'ResponsiveConstraints.dart';

import 'DetailedImage.dart';
import 'main.dart';

class DetailedCollection extends StatefulWidget {
  final String collectionName;
  DetailedCollection({required this.collectionName});

  @override
  _DetailedCollectionState createState() => _DetailedCollectionState();
}

List<String> detailedCollection = [];

class _DetailedCollectionState extends State<DetailedCollection> {

  @override
  void initState() {
    super.initState();
    loadCollection();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: Responsive.height(2, context), left: Responsive.height(2, context), right: Responsive.height(2, context)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(child: Text(widget.collectionName, style: TextStyle(fontSize: 20),)),
                    ),
                    StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        itemCount: detailedCollection.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              //MaterialPageRoute route = MaterialPageRoute(builder: (context)=> DetailedImage(index: index));
                              //Navigator.push(context, route);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30))
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15)),
                                child: Hero(
                                  tag: detailedCollection[index],
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: detailedCollection[index],fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.fit(1);
                          //return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                        }),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 20,
                top: 20,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: IconButton(
                    onPressed: () {
                      print('pressed');
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: SecondaryColor,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void loadCollection() {
    setState(() {
      detailedCollection.clear();
    });

    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('collections').doc(widget.collectionName).collection('data')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          print(doc['url']);
          detailedCollection.add(doc['url']);
        });
      });
    });
  }

}
